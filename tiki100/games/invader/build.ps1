param(
    [switch]$Copy,
    [switch]$Run
)

$ErrorActionPreference = "Stop"

$Project = $PSScriptRoot
$Build = Join-Path $Project "build"
New-Item -ItemType Directory -Force -Path $Build | Out-Null
$Repo = $null
$Probe = $Project
while ($Probe) {
    $CandidateAssembler = Join-Path $Probe "tools\sjasmplus.exe"
    $CandidateBuild = Join-Path $Probe "build.ps1"
    if ((Test-Path $CandidateAssembler) -and (Test-Path $CandidateBuild)) {
        $Repo = $Probe
        break
    }
    $Parent = Split-Path -Parent $Probe
    if (-not $Parent -or $Parent -eq $Probe) { break }
    $Probe = $Parent
}
if (-not $Repo) { throw "Fant ikke Tiki100-roten med tools\sjasmplus.exe." }
$Assembler = Join-Path $Repo "tools\sjasmplus.exe"
$RootBuild = Join-Path $Repo "build.ps1"

if (-not (Test-Path $Assembler)) {
    throw "Fant ikke SjASMPlus: $Assembler"
}
if (-not (Test-Path $RootBuild)) {
    throw "Fant ikke hovedbygget: $RootBuild"
}

Set-Location $Project
New-Item -ItemType Directory -Force -Path "build" | Out-Null

if ([string]::IsNullOrWhiteSpace($Build)) {
    throw "Intern build-feil: `$Build er tom. Project=$Project"
}

Write-Host "==> 0/3 SjASMPlus runtime source audit (PowerShell)"
$AuditErrors = New-Object System.Collections.Generic.List[string]

Get-ChildItem -Path (Join-Path $Project "runtime") -Filter *.asm -Recurse | ForEach-Object {
    if ($_.FullName -match "\\symbols\\") { return }

    $LineNo = 0
    Get-Content $_.FullName | ForEach-Object {
        $LineNo++
        $Code = ($_ -split ';',2)[0]

        # Bare hexadecimal literals beginning A-F must be 0-prefixed for SjASMPlus.
        if ($Code -match '(?<![A-Za-z0-9_])([A-F][0-9A-F]*h)(?![A-Za-z0-9_])') {
            $AuditErrors.Add("$($_.Name):$LineNo bare hex literal: $($Matches[1])")
        }

        # SjASMPlus 1.23.1 rejects these undocumented indexed IXH/IXL spellings.
        if ($Code -match '\bLD\s+(\(IX\+\d+\),IX[HL]|IX[HL],\(IX\+\d+\))') {
            $AuditErrors.Add("$($_.Name):$LineNo unsupported IXH/IXL indexed form")
        }
    }
}

$RuntimeAsm = Get-Content (Join-Path $Project "runtime\runtime.asm") -Raw
if ($RuntimeAsm -notmatch 'TAIL_BLOCK_B51B\s+EQU\s+0B51Bh') {
    $AuditErrors.Add("runtime.asm: missing TAIL_BLOCK_B51B EQU 0B51Bh")
}
if ($RuntimeAsm -match 'compatibility_aliases\.asm') {
    $AuditErrors.Add("runtime.asm: stale compatibility_aliases include")
}

if ($AuditErrors.Count -gt 0) {
    $AuditErrors | ForEach-Object { Write-Host "AUDIT: $_" }
    throw "Runtime source audit feilet med $($AuditErrors.Count) funn."
}
Write-Host "PASS: runtime source audit"

Write-Host "==> 1/3 Bygger runtime 8000h-BFFFh fra kilde"

$RuntimeSource = ($Project + "/runtime/runtime.asm").Replace("\\", "/")
$RuntimeSld    = ($Project + "/build/INVADER_RUNTIME.sld").Replace("\\", "/")
$RuntimeLst    = ($Project + "/build/INVADER_RUNTIME.lst").Replace("\\", "/")

& $Assembler `
    --fullpath `
    --sld=$RuntimeSld `
    --lst=$RuntimeLst `
    $RuntimeSource

if ($LASTEXITCODE -ne 0) {
    throw "Runtime-assemblering feilet med kode $LASTEXITCODE"
}

Write-Host "==> 2/3 Verifiserer alle 16384 runtimebyte (PowerShell)"

$BuiltRuntime = Join-Path $Build "INVADER_RUNTIME_8000_BFFF.bin"
$ReferenceRuntime = Join-Path $Project "tests\reference\INVADER_RUNTIME_8000_BFFF.bin"

if (-not (Test-Path $BuiltRuntime)) {
    throw "Mangler bygget runtime: $BuiltRuntime"
}
if (-not (Test-Path $ReferenceRuntime)) {
    throw "Mangler original runtime-referanse: $ReferenceRuntime"
}

$BuiltBytes = [System.IO.File]::ReadAllBytes($BuiltRuntime)
$ReferenceBytes = [System.IO.File]::ReadAllBytes($ReferenceRuntime)

$BuiltSha = (Get-FileHash -Algorithm SHA256 $BuiltRuntime).Hash.ToLowerInvariant()
$ReferenceSha = (Get-FileHash -Algorithm SHA256 $ReferenceRuntime).Hash.ToLowerInvariant()
Write-Host "Built runtime     : $($BuiltBytes.Length) bytes"
Write-Host "Reference runtime : $($ReferenceBytes.Length) bytes"
Write-Host "Built SHA-256     : $BuiltSha"
Write-Host "Reference SHA-256 : $ReferenceSha"

if ($BuiltBytes.Length -ne 16384) {
    throw "Bygget runtime har feil størrelse: $($BuiltBytes.Length), forventet 16384."
}
if ($ReferenceBytes.Length -ne 16384) {
    throw "Referanse-runtime har feil størrelse: $($ReferenceBytes.Length), forventet 16384."
}

$AllowedRanges = @(
    @{ Start = 0xAF49; End = 0xAF50; Why = "G shortest original UFO timer" },
    @{ Start = 0xB545; End = 0xB7FF; Why = "verified-unused high-RAM UFO seam helper" },
    @{ Start = 0xA838; End = 0xA83C; Why = "G one-shot original full world init" },
    @{ Start = 0x8000; End = 0x805A; Why = "proven per-row IRQ sprite blitter" },
    @{ Start = 0x8109; End = 0x817F; Why = "proven row-atomic move + arrows in original padding" },
    @{ Start = 0xA800; End = 0xA81D; Why = "proven row-bounded clear" },
    @{ Start = 0xAA47; End = 0xAA49; Why = "invader old-state capture" },
    @{ Start = 0xAA97; End = 0xAA99; Why = "invader row-atomic present" },
    @{ Start = 0xABB4; End = 0xABBD; Why = "player row-atomic move" },
    @{ Start = 0xAFBB; End = 0xB003; Why = "UFO row-atomic movement" },
    @{ Start = 0x805B; End = 0x807F; Why = "fire/up helper in original padding" },
    @{ Start = 0x8109; End = 0x817F; Why = "arrow helper in original padding" },
    @{ Start = 0xA92D; End = 0xA92F; Why = "G formation start-height only" },
    @{ Start = 0xAB9D; End = 0xABA1; Why = "right/arrow input hook" },
    @{ Start = 0xABEB; End = 0xABF5; Why = "fire/up input hook" },
    @{ Start = 0xAD5E; End = 0xAD60; Why = "G hit-immunity hook" },
    @{ Start = 0xAEFD; End = 0xAF01; Why = "G enemy/death-event gate" },
    @{ Start = 0xB09D; End = 0xB09F; Why = "G bottom-limit round gate" },
    @{ Start = 0xB19E; End = 0xB1A0; Why = "P/Q/G control gate" },
    @{ Start = 0xB2EE; End = 0xB2FB; Why = "intro controller hook" },
    @{ Start = 0xB318; End = 0xB31A; Why = "game-start wrapper" },
    @{ Start = 0xB31B; End = 0xB31D; Why = "game-over wrapper" }
)

$Unexpected = New-Object System.Collections.Generic.List[string]
$Changed = 0
for ($i = 0; $i -lt 16384; $i++) {
    if ($BuiltBytes[$i] -ne $ReferenceBytes[$i]) {
        $Changed++
        $Addr = 0x8000 + $i
        $Allowed = $false
        foreach ($Range in $AllowedRanges) {
            if ($Addr -ge $Range.Start -and $Addr -le $Range.End) {
                $Allowed = $true
                break
            }
        }
        if (-not $Allowed) {
            $Unexpected.Add(("{0:X4}" -f $Addr))
        }
    }
}

if ($Unexpected.Count -gt 0) {
    throw "INVADER enhanced diff feilet. Uventede runtime-endringer: $($Unexpected -join ', ')"
}

Write-Host "PASS: runtime avviker bare i eksplisitt godkjente INVADER enhanced-områder"
Write-Host "Endrede runtimebyte: $Changed"

Write-Host "==> 3/3 Bygger INVADER.COM gjennom TIKI-100-hovedbygget"

# IMPORTANT:
# Do not array-splat "-Source". Array splatting is positional and makes
# the root script receive "-Source" as its first positional $Project value.
# Pass real named parameters instead.
& $RootBuild `
    -Source "$Project\INVADER.ASM" `
    -Copy:$Copy `
    -Run:$Run

if ($LASTEXITCODE -ne 0) {
    throw "Hovedbygget feilet med kode $LASTEXITCODE"
}

(*  VER 028   TAB-S1,2
 *  LIBG.INC
 *
 *  Biblioteksfil for bruk av Tiki grafikk i TurboPascal.
 *  Prosedyrer som ikke brukes kan slettes for } spare plass
 *)

type
  GWORD = integer;
  GBYTE = char;
  STRING80 = string(.80.);
  GCBS = record
    gx    : GWORD;
    gy    : GWORD;
    gfont : GWORD;
    gcolc : GBYTE;
    gwrtm : GBYTE;
    gltyp : GBYTE;
    gmisc : GBYTE;
    garg1 : GWORD;
    garg2 : GWORD;
    garg3 : GWORD;
    gxorg : GWORD;
    gyorg : GWORD;
    gxmag : GWORD;
    gymag : GWORD
  end;
  FNCS = record
    fx    : GBYTE;
    fy    : GBYTE;
    fmap  : GBYTE
  end;
  FHDR = record
    fid1  : GBYTE;
    fid2  : GBYTE;
    fmode : GBYTE;
    fsize : GBYTE;
    fxsiz : GWORD;
    fysiz : GWORD;
    fres  : array(.0..119.) of GBYTE
  end;

var
  gcb : GCBS;

procedure gio(arg1:integer;var arg2:GCBS);

begin inline (
$ED/$4B/ARG1/$DD/$2A/ARG2/$CD/*+$0016/$C3/*+$0992/$79/$FE/$17/$D0/$87/
$4F/$06/$00/$21/*+$0033/$09/$7E/$23/$66/$6F/$E9/$C5/$CD/*+$005A/$21/*-$0016/
$22/*-$001E/$C1/$E9/$00/$00/$00/$02/$04/$10/$00/$00/$00/$00/$00/$00/$00/
$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$00/$FF/$00/
*+$002E/*+$003E/*+$0077/*+$0444/*+$00F1/*+$0780/*+$02FF/*+$00B4/*+$00F5/
*+$00F3/*+$07B7/*+$0317/*+$0583/*+$0433/*+$0654/*+$06D9/*+$072B/*+$0738/
*+$073A/*+$0741/*+$038D/*+$07D0/*+$0896/$CD/$3C/$F0/$CD/*+$06A3/$3A/$4D/
$F0/$0F/$0F/$0F/$0F/$32/*-$005A/$18/$0A/$DD/$7E/$0A/$E6/$03/$20/$05/$3A/
*-$0066/$E6/$03/$32/*-$006C/$16/$00/$5F/$87/$87/$87/$87/$32/$4D/$F0/$D3/
$0C/$21/*-$0079/$19/$7E/$32/*-$007E/$3A/$50/$F0/$2A/$4E/$F0/$1D/$20/$03/
$87/$29/$1C/$1D/$20/$02/$87/$29/$32/*-$008E/$22/*-$0090/$C9/$DD/$46/$0E/
$CB/$38/$CB/$38/$CB/$38/$DD/$7E/$0C/$E6/$E0/$B0/$47/$CB/$38/$CB/$38/$CB/
$38/$DD/$7E/$0A/$E6/$E0/$B0/$2F/$D3/$14/$3A/*-$00B8/$3D/$DD/$A6/$06/$4F/
$3A/$4D/$F0/$B1/$F6/$80/$F3/$D3/$0C/$06/$13/$10/$FE/$E6/$7F/$D3/$0C/$FB/
$3A/*-$00D2/$81/$FE/$10/$38/$E5/$3A/$4D/$F0/$D3/$0C/$C9/$3A/*-$00E2/$FE/
$03/$20/$0D/$DD/$7E/$0A/$E6/$0F/$4F/$87/$87/$87/$87/$B1/$18/$1F/$FE/$02/
$20/$11/$DD/$7E/$0A/$E6/$03/$4F/$87/$87/$B1/$87/$87/$B1/$87/$87/$B1/$18/
$0A/$DD/$7E/$0A/$E6/$01/$3E/$00/$28/$01/$3D/$DD/$77/$06/$C9/$DD/$E5/$E1/
$AF/$06/$10/$77/$23/$10/$FC/$18/$EF/$CD/*+$0170/$D8/$4F/$2F/$57/$2F/$DD/
$A6/$06/$5F/$DD/$7E/$07/$3D/$FA/*+$0033/$28/$21/$3D/$28/$18/$3D/$28/$0F/
$3D/$28/$21/$3D/$28/$00/$CD/$3F/$F0/$47/$7B/$2F/$A0/$18/$1F/$CD/$3F/$F0/
$AB/$18/$19/$CD/$3F/$F0/$B3/$18/$13/$CD/$3F/$F0/$47/$7B/$B2/$A0/$18/$0A/
$CD/$3F/$F0/$A1/$C0/$CD/$3F/$F0/$A2/$B3/$C3/$42/$F0/$DD/$7E/$09/$E6/$08/
$20/$06/$DD/$7E/$07/$B7/$28/$25/$DD/$6E/$00/$DD/$66/$01/$E5/$78/$B1/$28/
$12/$C5/$CD/*-$0066/$C1/$0B/$DD/$6E/$00/$DD/$66/$01/$23/$CD/*+$0005/$18/
$EA/$E1/$DD/$75/$00/$DD/$74/$01/$C9/$78/$B1/$C8/$3A/*-$01A6/$FE/$03/$20/
$32/$C5/$CD/*+$00E7/$C1/$38/$CA/$0F/$38/$0F/$07/$C5/$CD/*-$0091/$C1/$0B/
$78/$B1/$C8/$23/$7D/$E6/$7F/$C8/$CB/$38/$CB/$19/$F5/$78/$41/$B7/$28/$02/
$06/$FF/$DD/$7E/$06/$CD/$45/$F0/$F1/$3E/$0F/$DA/*-$00B3/$C9/$FE/$02/$20/
$57/$C5/$CD/*+$00B1/$C1/$38/$94/$57/$0F/$38/$21/$AF/$B2/$FA/*+$0010/$CB/
$22/$CB/$22/$0D/$20/$F5/$04/$05/$28/$04/$05/$18/$EE/$0B/$C5/$CD/*-$00DB/
$C1/$78/$B1/$C8/$23/$7D/$E6/$7F/$C8/$1E/$00/$CB/$38/$CB/$19/$CB/$1B/$CB/
$38/$CB/$19/$CB/$1B/$78/$41/$B7/$28/$02/$06/$FF/$D5/$DD/$7E/$06/$CD/$45/
$F0/$D1/$7B/$07/$07/$87/$C8/$47/$AF/$37/$17/$10/$FC/$C3/*-$010F/$C5/$CD/
*+$005A/$C1/$DA/*-$00C2/$57/$0F/$38/$1F/$AF/$B2/$FA/*+$000E/$CB/$22/$0D/
$20/$F7/$04/$05/$28/$04/$05/$18/$F0/$0B/$C5/$CD/*-$0131/$C1/$78/$B1/$C8/
$23/$7D/$E6/$7F/$C8/$CB/$38/$CB/$19/$CB/$1B/$CB/$38/$CB/$19/$CB/$1B/$CB/
$38/$CB/$19/$CB/$1B/$78/$41/$B7/$28/$02/$06/$FF/$D5/$DD/$7E/$06/$CD/$45/
$F0/$D1/$7B/$07/$07/$07/$E6/$07/$C8/$47/$AF/$37/$17/$10/$FC/$C3/*-$016B/
$DD/$66/$01/$DD/$6E/$00/$DD/$56/$03/$DD/$5E/$02/$DD/$7E/$09/$E6/$08/$28/
$28/$7D/$DD/$96/$14/$7C/$DD/$9E/$15/$3F/$D8/$7B/$DD/$96/$16/$7A/$DD/$9E/
$17/$3F/$D8/$7D/$DD/$86/$10/$6F/$7C/$DD/$8E/$11/$67/$7B/$DD/$86/$12/$5F/
$7A/$DD/$8E/$13/$57/$3A/*-$02CB/$4F/$06/$00/$09/$3A/*-$02D8/$FE/$03/$20/
$0F/$7C/$B2/$37/$C0/$63/$CB/$3C/$CB/$1D/$3E/$0F/$D0/$2F/$3F/$C9/$FE/$02/
$20/$1B/$3E/$03/$A5/$87/$47/$CB/$3C/$CB/$1D/$7C/$B2/$37/$C0/$63/$CB/$3C/
$CB/$1D/$78/$B7/$3E/$03/$C8/$07/$10/$FD/$C9/$3E/$07/$A5/$47/$CB/$3C/$CB/
$1D/$CB/$3C/$CB/$1D/$7C/$B2/$37/$C0/$63/$CB/$3C/$CB/$1D/$78/$B7/$3E/$01/
$C8/$07/$10/$FD/$C9/$CD/*+$0009/$DD/$74/$0B/$DD/$75/$0A/$C9/$CD/*-$00A0/
$30/$04/$21/$FF/$FF/$C9/$57/$CD/$3F/$F0/$A2/$6F/$26/$00/$7A/$0F/$D8/$CB/
$3D/$18/$FA/$CD/*+$00F2/$D8/$FD/$E5/$19/$E5/$CD/*+$0094/$E3/$5E/$23/$56/
$22/*-$0351/$DD/$66/$01/$DD/$6E/$00/$22/*-$0357/$4B/$CD/*+$00C8/$E5/$7A/
$B7/$20/$1A/$18/$4D/$15/$28/$4A/$FD/$66/$01/$FD/$6E/$00/$23/$3A/*-$0370/
$1F/$30/$02/$2B/$2B/$FD/$74/$01/$FD/$75/$00/$0E/$FF/$0C/$79/$BB/$30/$E1/
$E6/$07/$C2/*+$000A/$2A/*-$038C/$23/$46/$22/*-$0391/$CB/$10/$30/$EA/$C5/
$D5/$2A/*-$0397/$CD/*+$0089/$DD/$74/$01/$DD/$75/$00/$DD/$E5/$DD/$2A/*-$03AB/
$CD/*-$0293/$DD/$E1/$D1/$C1/$18/$CD/$E1/$D1/$FD/$72/$01/$FD/$73/$00/$DD/
$74/$01/$DD/$75/$00/$DD/$2A/*-$03C6/$FD/$E1/$C9/$FD/$E5/$CD/*+$0068/$11/
$05/$00/$19/$4E/$CD/*+$000A/$DD/$6E/$0A/$DD/$66/$0B/$18/$DE/$DD/$22/*-$03E2/
$FD/$2A/*-$03E6/$16/$00/$DD/$7E/$09/$E6/$07/$5F/$21/*+$002F/$19/$7E/$1F/
$32/*-$03F3/$38/$06/$FD/$23/$FD/$23/$18/$04/$DD/$23/$DD/$23/$FD/$66/$01/
$FD/$6E/$00/$E5/$AF/$47/$ED/$42/$3A/*-$040D/$1F/$30/$02/$09/$09/$FD/$74/
$01/$FD/$75/$00/$E1/$C9/$00/$05/$06/$03/$02/$07/$04/$01/$06/$00/$AF/$ED/
$42/$3A/*-$042A/$1F/$1F/$D8/$09/$09/$C9/$DD/$66/$05/$DD/$6E/$04/$7C/$B5/
$20/$03/$2A/$4B/$F0/$DD/$7E/$0A/$E5/$23/$23/$96/$38/$12/$23/$BE/$3F/$38/
$0D/$23/$4E/$23/$23/$5F/$16/$00/$19/$19/$5E/$23/$56/$AF/$E1/$C9/$C3/$48/
$F0/$DD/$7E/$07/$F5/$AF/$DD/$77/$07/$CD/*+$0007/$F1/$DD/$77/$07/$C9/$DD/
$7E/$0A/$32/*-$0470/$DD/$7E/$0B/$32/*-$0475/$57/$D5/$CD/*-$0161/$D1/$DD/
$7E/$0A/$FE/$FF/$C8/$14/$20/$0D/$32/*-$0488/$5F/$3A/*-$049A/$3D/$DD/$A6/
$06/$BB/$C8/$DD/$66/$01/$DD/$6E/$00/$E5/$DD/$7E/$02/$F5/$CD/*+$000E/$F1/
$DD/$77/$02/$E1/$DD/$74/$01/$DD/$75/$00/$C9/$21/$FF/$FF/$E5/$E5/$E5/$E5/
$CD/*+$00E7/$CD/*+$00AD/$28/$F8/$CD/*+$00D2/$CD/*+$00A5/$20/$68/$CD/*-$03B2/
$DD/$35/$02/$CD/*+$009A/$20/$22/$E1/$23/$7C/$B5/$28/$13/$DD/$7E/$00/$BD/
$20/$06/$DD/$7E/$01/$BC/$28/$0F/$2B/$E5/$CD/*-$0051/$18/$09/$E1/$DD/$66/
$01/$DD/$6E/$00/$E5/$E5/$DD/$34/$02/$DD/$34/$02/$CD/*+$006D/$20/$28/$C1/
$D1/$E1/$23/$7C/$B5/$28/$15/$DD/$7E/$00/$BD/$20/$06/$DD/$7E/$01/$BC/$28/
$11/$2B/$E5/$D5/$C5/$CD/*-$0082/$18/$0B/$E1/$DD/$66/$01/$DD/$6E/$00/$E5/
$E5/$D5/$C5/$DD/$35/$02/$CD/*+$0067/$18/$93/$E1/$D1/$23/$7C/$B5/$28/$20/
$DD/$72/$01/$DD/$73/$00/$DD/$35/$02/$E1/$D1/$23/$7C/$B5/$CA/*-$0095/$D5/
$2B/$E5/$DD/$7E/$02/$3C/$F5/$CD/*-$00A0/$F1/$DD/$77/$02/$E1/$D1/$23/$7C/
$B5/$C8/$DD/$72/$01/$DD/$73/$00/$DD/$34/$02/$C3/*-$00B6/$CD/*-$024D/$3A/
*-$0569/$3C/$3A/*-$056E/$20/$04/$DD/$BE/$0A/$C9/$DD/$BE/$0A/$28/$12/$FE/
$FF/$28/$0E/$3A/*-$058E/$3D/$DD/$A6/$06/$DD/$BE/$0A/$28/$02/$AF/$C9/$AF/
$3C/$C9/$DD/$7E/$00/$C6/$01/$DD/$77/$00/$D0/$DD/$34/$01/$C9/$DD/$7E/$00/
$D6/$01/$DD/$77/$00/$D0/$DD/$35/$01/$C9/$21/*-$059D/$DD/$7E/$08/$E6/$07/
$BE/$28/$0C/$77/$16/$00/$5F/$21/*+$00BD/$19/$7E/$32/*-$05B2/$21/$01/$00/
$22/*-$05C3/$22/*-$05C4/$2B/$DD/$56/$0B/$DD/$5E/$0A/$7A/$B7/$F2/*+$000A/
$2B/$22/*-$05D6/$23/$ED/$52/$EB/$DD/$46/$0D/$DD/$4E/$0C/$78/$B7/$F2/*+$000D/
$21/$FF/$FF/$22/*-$05E9/$23/$ED/$42/$44/$4D/$60/$69/$AF/$ED/$52/$FA/*+$000B/
$ED/$53/*-$05F8/$60/$69/$3C/$18/$05/$ED/$43/*-$0601/$EB/$22/*-$0603/$32/
*-$0602/$E5/$CB/$2C/$CB/$1D/$22/*-$060C/$E1/$7C/$B5/$C8/$2B/$E5/$21/*-$0612/
$CB/$06/$DC/*-$0510/$ED/$5B/*-$0622/$2A/*-$0621/$19/$22/*-$0625/$ED/$5B/
*-$062B/$ED/$52/$FA/*+$0027/$22/*-$0631/$2A/*-$063C/$DD/$56/$01/$DD/$5E/
$00/$19/$DD/$74/$01/$DD/$75/$00/$2A/*-$064A/$DD/$56/$03/$DD/$5E/$02/$19/
$DD/$74/$03/$DD/$75/$02/$18/$B9/$3A/*-$0654/$B7/$20/$E8/$2A/*-$0664/$DD/
$56/$01/$DD/$5E/$00/$19/$DD/$74/$01/$DD/$75/$00/$18/$A1/$FF/$FF/$7C/$44/
$4E/$66/$78/$55/$DD/$7E/$0A/$B7/$28/$5F/$DD/$56/$0D/$DD/$5E/$0C/$DD/$66/
$0F/$DD/$6E/$0E/$4F/$FE/$05/$28/$2B/$FE/$03/$28/$33/$38/$05/$FE/$04/$20/
$44/$3D/$3D/$F5/$87/$CD/*+$0053/$F1/$C6/$08/$EB/$CD/*+$0054/$7C/$B5/$3E/
$07/$D3/$16/$DB/$17/$28/$06/$47/$79/$2F/$A0/$18/$35/$B1/$18/$32/$3E/$0B/
$CD/*+$0034/$7D/$2F/$5F/$3E/$0D/$18/$33/$3E/$06/$CD/*+$0030/$EB/$3E/$07/
$D3/$16/$DB/$17/$F6/$38/$57/$7B/$87/$87/$87/$2F/$A2/$18/$0F/$11/$00/$00/
$3E/$08/$CD/*+$000E/$3E/$0A/$CD/*+$0011/$3E/$FF/$5F/$3E/$07/$18/$08/$F5/
$3C/$D3/$16/$7A/$D3/$17/$F1/$D3/$16/$7B/$D3/$17/$C9/$DB/$78/$4F/$E6/$80/
$20/$43/$F3/$DB/$7A/$5F/$16/$00/$79/$E6/$03/$67/$DB/$79/$6F/$FB/$3A/*-$072C/
$3D/$28/$06/$CB/$3C/$CB/$1D/$18/$F7/$DD/$7E/$09/$E6/$08/$28/$16/$C5/$DD/
$46/$11/$DD/$4E/$10/$AF/$ED/$42/$EB/$DD/$46/$13/$DD/$4E/$12/$AF/$ED/$42/
$EB/$C1/$DD/$74/$0B/$DD/$75/$0A/$DD/$72/$0D/$DD/$73/$0C/$79/$E6/$40/$3E/
$00/$20/$0A/$3C/$18/$07/$3A/*-$0769/$3D/$DD/$A6/$06/$DD/$77/$0A/$AF/$DD/
$77/$0B/$C9/$3E/$05/$18/$F4/$3A/$2F/$E0/$FE/$C3/$C0/$C3/$2F/$E0/$CD/*-$0348/
$19/$06/$00/$48/$50/$58/$38/$05/$54/$5D/$46/$23/$4E/$DD/$73/$0A/$DD/$72/
$0B/$DD/$70/$0C/$DD/$77/$0D/$DD/$71/$0E/$DD/$77/$0F/$C9/$2A/*-$07A3/$23/
$11/$00/$01/$DD/$7E/$09/$E6/$08/$28/$0C/$DD/$6E/$14/$DD/$66/$15/$DD/$5E/
$16/$DD/$56/$17/$DD/$75/$00/$DD/$74/$01/$DD/$73/$02/$DD/$72/$03/$3A/*-$07D0/
$DD/$77/$0A/$3A/*-$07D4/$DD/$77/$0E/$AF/$DD/$77/$0B/$DD/$77/$0D/$DD/$77/
$0F/$3C/$DD/$77/$0C/$C9/$DD/$46/$03/$DD/$4E/$02/$C5/$DD/$46/$0D/$DD/$4E/
$0C/$78/$B1/$28/$16/$C5/$DD/$46/$0B/$DD/$4E/$0A/$CD/*-$0693/$DD/$34/$02/
$20/$03/$DD/$34/$03/$C1/$0B/$18/$E6/$C1/$DD/$70/$03/$DD/$71/$02/$C9/$CD/
*+$012E/$CD/*-$0588/$D8/$DD/$56/$0F/$DD/$5E/$0E/$DD/$46/$0C/$4F/$C5/$E5/
$DD/$66/$0B/$DD/$6E/$0A/$22/*-$081B/$E1/$E5/$D5/$79/$0F/$38/$6D/$C5/$D5/
$EB/$6E/$79/$0F/$38/$03/$29/$18/$FA/$EB/$7B/$C5/$CD/*+$008B/$ED/$4B/*-$0837/
$0B/$ED/$43/*-$083C/$78/$B1/$C1/$28/$0B/$51/$CB/$01/$38/$06/$79/$A2/$20/
$F8/$18/$E2/$D1/$C1/$23/$E5/$2A/*-$0853/$CD/*+$00EB/$45/$7D/$B4/$E1/$28/
$0D/$CD/*+$004B/$C5/$0E/$FF/$CD/*+$0059/$C1/$23/$10/$F3/$3A/*-$0870/$B7/
$CA/*+$0010/$37/$CB/$10/$D6/$20/$20/$F9/$CD/*+$0030/$48/$CD/*+$0040/$D1/
$2A/*-$0880/$19/$EB/$E1/$01/$80/$00/$09/$C1/$10/$84/$C3/*+$0091/$DD/$7E/
$07/$B7/$20/$BA/$3A/*-$089E/$47/$B7/$28/$CD/$1A/$13/$C5/$CD/$42/$F0/$C1/
$23/$10/$F6/$18/$C1/$79/$0F/$38/$0D/$E5/$EB/$5E/$23/$56/$EB/$29/$0F/$30/
$FC/$7C/$E1/$C9/$1A/$13/$C9/$D5/$A1/$5F/$79/$2F/$57/$CD/*-$07AD/$D1/$C9/
$CD/*+$0066/$CD/*-$0650/$D8/$DD/$56/$0F/$DD/$5E/$0E/$DD/$46/$0C/$4F/$0F/
$38/$2B/$C5/$E5/$E5/$CD/$3F/$F0/$CD/*+$0043/$3A/*-$08E5/$47/$7C/$12/$E1/
$23/$C5/$CD/$3F/$F0/$C1/$E5/$CD/*+$0032/$1A/$B5/$12/$13/$10/$ED/$E1/$E1/
$01/$80/$00/$09/$C1/$10/$D7/$18/$18/$C5/$E5/$3A/*-$0909/$47/$C5/$CD/$3F/
$F0/$C1/$12/$23/$13/$10/$F6/$E1/$01/$80/$00/$09/$C1/$10/$E8/$DD/$72/$0F/
$DD/$73/$0E/$C9/$6F/$26/$00/$79/$29/$87/$20/$FC/$C9/$DD/$66/$0B/$DD/$6E/
$0A/$CD/*+$000A/$B7/$28/$01/$23/$22/*-$093C/$C9/$D5/$3A/*-$095B/$16/$00/
$CB/$3C/$CB/$1D/$CB/$1A/$3C/$FE/$04/$38/$F5/$7A/$32/*-$0958/$22/*-$095D/
$D1/$C9/$00);
end;

procedure ginit;
begin
  gio(4,gcb)
end;

procedure gpar(var xp,yp,ip:integer);
var
  x,y:integer;
begin
  x := gcb.gx;
  y := gcb.gy;
  gio(5,gcb);
  xp := gcb.gx;
  yp := gcb.gy;
  ip := gcb.garg3;
  gcb.gx := x;
  gcb.gy := y
end;

function gmode(m:integer): integer;
(* bruker: gpar *)
var
  dummy:integer;
begin
  if m <> 0 then begin
    gcb.garg1 := m;
    gcb.garg2 := 1;
    gio(1,gcb)
  end;
  gpar(dummy,dummy,dummy);
  gmode := gcb.garg1
end;

procedure ink(i:integer);
begin
  gcb.garg1 := i;
  gio(7,gcb)
end;

function curink:integer;
begin
  gio(16,gcb);
  curink := gcb.garg1
end;

procedure defink(r,g,b:integer);
begin
  gcb.garg1 := (r*255) div 100;
  gcb.garg2 := (g*255) div 100;
  gcb.garg3 := (b*255) div 100;
  gio(2,gcb)
end;

procedure apos(x,y:integer);
begin
  gcb.gx := x;
  gcb.gy := y
end;

procedure rpos(xrel,yrel:integer);
begin
  gcb.gx := gcb.gx + xrel;
  gcb.gy := gcb.gy + yrel
end;

procedure dot;
begin
  gio(9,gcb)
end;

procedure wrtm(m:integer);
begin
  gcb.gwrtm := chr(m)
end;

procedure ltyp(t:integer);
begin
  gcb.gltyp := chr(t)
end;

procedure font(fp:GWORD);
begin
  gcb.gfont := fp
end;

function gpix:integer;
begin
  gio(6,gcb);
  gpix := gcb.garg1
end;

procedure block(width,depth:integer);
begin
  gcb.garg1 := width;
  gcb.garg2 := depth;
  gio(10,gcb)
end;

procedure rline(xrel,yrel:integer);
begin
  gcb.garg1 := xrel;
  gcb.garg2 := yrel;
  gio(12,gcb)
end;

procedure aline(x,y:integer);
begin
  rline(x-gcb.gx, y-gcb.gy)
end;

procedure ch(c:char);
begin
  gcb.garg1 := ord(c);
  gio(11,gcb)
end;

procedure txt(p:STRING80); (* TurboPascal string *)
var
  i:integer;
begin
  for i:=1 to length(p) do begin
    gcb.garg1 := ord(p(.i.));
    gio(11,gcb)
  end
end;

procedure fill(i:integer);
begin
  gcb.garg1 := i;
  gio(13,gcb)
end;

procedure scroll(n:integer);
begin
  gcb.garg1 := n;
  gio(3,gcb)
end;

procedure sound(chan,per,ampl:integer); 
begin
  gcb.garg1 := chan;
  gcb.garg2 := per;
  gcb.garg3 := ampl;
  gio(14,gcb)
end;

procedure hardcopy; 
begin
  gio(18,gcb)
end;

procedure curpos(var xp,yp:integer);
begin
  xp := gcb.gx;
  yp := gcb.gy
end;

procedure chsize(c:char;var xp,yp:integer);
type
  TWO = (INT,PTR);
  FNCSP = ^FNCS;
  FNCSV = record
    case TWO of
      INT: (i: integer);
      PTR: (p: FNCSP)
  end;
var
  fp: FNCSV;
begin
  gcb.garg1 := ord(c);
  gio(19,gcb);
  with fp do begin
    i := gcb.garg1;
    xp := ord(p^.fx);
    yp := ord(p^.fy)
  end
end;

procedure circle(r,rx:integer);
type
  UNSIGNED = integer;
var
  x,y,i,j,e,ei,eabs:integer;
  r2:UNSIGNED;
procedure dots;
  begin
    gcb.gx := x+(i+ei);
    gcb.gy := y+j;
    gio(9,gcb); (* dot *)
    gcb.gy := y-j;
    gio(9,gcb);
    gcb.gx := x-(i+ei);
    gio(9,gcb);
    gcb.gy := y+j;
    gio(9,gcb);
  end;
begin
  x := gcb.gx;
  y := gcb.gy;
  r := r+1;
  r2 := r*r;
  e := 0;
  ei := rx-r;
  eabs := ei;
  if eabs<0 then eabs := -ei;
  i := r-1;
  j := 0;
  while (i+ei)>0 do begin
    dots;
    j := j+1;
    if (i*i + j*j) > r2 then begin
      i := i-1; 
      e := e+eabs;
      if (i*i + j*j) > r2 then j := j-1;
      if e >= r then begin 
        if ei>0 then dots;
        e := e-r;
        if ei>0 then ei := ei-1 else if ei<0 then ei := ei+1;
      end
    end
  end;
  dots;
  gcb.gx := x;
  gcb.gy := y
end;

procedure txtdir(d:integer);
begin
  gcb.gmisc := chr((d and 7) or (ord(gcb.gmisc) and not 7))
end;

procedure viewport(xsiz,ysiz:integer);
begin
  if xsiz=0 then begin
    gcb.gmisc := chr(ord(gcb.gmisc) and not 8)
  end else begin
    gcb.gmisc := chr(ord(gcb.gmisc) or 8);
    gcb.gxorg:=gcb.gx;
    gcb.gyorg:=gcb.gy;
    gcb.gxmag:=xsiz;
    gcb.gymag:=ysiz
  end
end;

function getbar(xsiz,ysiz:integer;ar:GWORD):integer;
begin
  gcb.garg1 := xsiz;
  gcb.garg2 := ysiz;
  gcb.garg3 := ar;
  gio(22,gcb);
  getbar := gcb.garg3 - ar
end;

function putbar(xsiz,ysiz:integer;ar:GWORD):integer;
begin
  gcb.garg1 := xsiz;
  gcb.garg2 := ysiz;
  gcb.garg3 := ar;
  gio(21,gcb);
  putbar := gcb.garg3 - ar
end;


with(plots):
with(plottools):
with(LinearAlgebra):

######################################################################
# We do this as a separate function to work around an annoying 
# issue about local/global interpretation of the names U and S.

singular_values := proc(A)
 return SingularValues(A,output=['S','U']);
end:

######################################################################

curve_to_tikz := proc(C)
 cat("\\draw[red] ",
     substring(cat(op(map(xy -> sprintf(" -- (%.3f,%.3f)",op(xy)),
                 convert(op(1,C),listlist)))),4..-1),";\n"
 );
end:

######################################################################

curves_to_tikz := proc(P)
 local s,C;

 s := "";
 for C in [op(P)] do
  if type(C,function) and op(0,C) = CURVES then
   s := cat(s,curve_to_tikz(C));
  fi;
 od:
 return s;
end:

######################################################################

curve_to_paperscript := proc(C)
 cat("new Point(",
     substring(cat(op(map(xy -> sprintf(",[%d,%d]",
                                        round(1000*xy[1]),
                                        round(1000*xy[2])),
                 convert(op(1,C),listlist)))),2..-1),")"
 );
end:

######################################################################

curve_to_json := proc(C)
 local L,s,t,comma,xy;

 L := op(1,C);
 if type(L,Matrix) then
  L := convert(L,listlist);
 fi;

 s := "[";
 comma := "";
 for xy in L do
  t := sprintf("[%0.4f,%0.4f]",xy[1],xy[2]);
  if StringTools[Search]("#IND",t) = 0 then
   s := cat(s,comma,t);
   comma := ",";
  fi;
 od;
 s := cat(s,"]");

 return(s);
end:

######################################################################

curves_to_json := proc(P)
 local s,comma,C;

 s := "[";
 comma := "";
 for C in [op(P)] do
  if type(C,function) and op(0,C) = CURVES then
   s := cat(s,comma,curve_to_json(C));
   comma := ",";
  fi;
 od:
 s := cat(s,"]");
 return s;
end:

######################################################################

linear_2d_construct := proc()
 local S;

 S := table();

 S["view"] := [-1..1,-1..1];
 S["vars"] := [x,y];

 return eval(S);
end:

######################################################################

linear_2d_set_matrix := proc(S,A)
 local L,U,V,L0,xy,xyt,r_series,i,a,aa,aas;

 # Note: if A is diagonalisable then U will be a matrix whose
 # columns form a basis of eigenvectors.  Otherwise, U will 
 # still be a square matrix but some columns will be zero.
 L,U := Eigenvectors(A);
 L := map(simplify,map(rationalize,L));
 U := map(simplify,map(rationalize,U));

 if is(Re(L[1]) > Re(L[2])) or
    (is(Re(L[1])=Re(L[2])) and is(Im(L[1]) > Im(L[2]))) then
  L := <L[2],L[1]>;
  U := <Column(U,2)|Column(U,1)>;
 fi;

 S["has_real_eigenvalues"] := is(L[1],'real');
 S["has_distinct_eigenvalues"] := not(is(L[1]-L[2]=0));

 for i from 1 to 2 do 
  S["u",i] := Column(U,i);
  if S["has_real_eigenvalues"] then
   if Norm(S["u",i]) <> 0 then
    S["u_hat",i] := evalf(S["u",i]/Norm(S["u",i],2));
    if S["u_hat",i][2] < 0 then
     S["u_hat",i] := - S["u_hat",i];
    fi;
    S["u_theta",i] := evalf(arctan(S["u_hat",i][2],S["u_hat",i][1]));
   fi;
  fi;
 od;

 S["A"] := A;
 S["tau"] := simplify(Trace(A));
 S["delta"] := simplify(Determinant(A));
 S["Delta"] := simplify(S["tau"]^2 - 4*S["delta"]);
 S["chi"] := CharacteristicPolynomial(A,t);
 S["lambda"] := L;
 S["U"] := U;
 S["is_diagonalizable"] := evalb(Determinant(U) <> 0);
 S["D"] := DiagonalMatrix(L);
 S["E"] := MatrixExponential(t * S["D"]);
 S["P"] := MatrixExponential(t * A);

 S["mu"],S["V"] := singular_values(A);
 S["v",1] := Column(S["V"],1);
 S["v",2] := Column(S["V"],2);

 xy := Vector(S["vars"]);

 if S["is_diagonalizable"] then
  S["lyapunov"] := expand(Transpose((1/U).xy) . (1/U) . xy);
 fi;

 a := convert(S["P"] . Vector([a0[1],a0[2]]),list);
 aa := a[1]^2 + a[2]^2;
 aas := simplify(expand(convert(series(aa-1,t=0,5),polynom,t)));

 linear_2d_classify(S);
end:

######################################################################

linear_2d_eval := proc(S,a0,t0)
 local E0,a1;
 E0 := evalf(map2(subs,t=t0,S["P"]));
 a1 := Vector(evalf([a0[1],a0[2]]));
 E0 . a1;
end:

######################################################################

linear_2d_types := [
 "constant",
 "improper stable node",
 "stable node",
 "semistable node",
 "improper unstable node",
 "unstable node",
 "semiunstable node",
 "saddle",
 "clockwise centre",
 "anticlockwise centre",
 "clockwise stable focus",
 "anticlockwise stable focus",
 "clockwise unstable focus",
 "anticlockwise unstable focus",
 "degenerate stable node",
 "shear flow",
 "degenerate unstable node"
]:

######################################################################

linear_2d_type_example := table([
 "constant"                     = << 0| 0>,< 0| 0>>,
 "improper stable node"         = <<-1| 0>,< 0|-1>>,
 "stable node"                  = <<-2| 0>,< 0|-1>>,
 "semistable node"              = <<-1| 0>,< 0| 0>>,
 "improper unstable node"       = << 1| 0>,< 0| 1>>,
 "unstable node"                = << 1| 0>,< 0| 2>>,
 "semiunstable node"            = << 0| 0>,< 0| 1>>,
 "saddle"                       = <<-1| 0>,< 0| 1>>,
 "clockwise centre"             = << 0| 1>,<-1| 0>>,
 "anticlockwise centre"         = << 0|-1>,< 1| 0>>,
 "clockwise stable focus"       = <<-1/2| 1>,<-1|-1/2>>,
 "anticlockwise stable focus"   = <<-1/2|-1>,< 1|-1/2>>,
 "clockwise unstable focus"     = << 1/2| 1>,<-1| 1/2>>,
 "anticlockwise unstable focus" = << 1/2|-1>,< 1| 1/2>>,
 "degenerate stable node"       = <<-1|1>,<0|-1>>,
 "shear flow"                   = <<0|1>,<0|0>>,
 "degenerate unstable node"       = <<1|1>,<0|1>>
]):

######################################################################

linear_2d_type_typical_example := table([
 "constant"                     = << 0| 0>,< 0| 0>>,
 "improper stable node"         = <<-1| 0>,< 0|-1>>,
 "stable node"                  = <<-37/21|-8/21>,<-10/21|-26/21>>,
 "semistable node"              = <<-5/8|15/8>,<1/8|-3/8>>,
 "improper unstable node"       = << 1| 0>,< 0| 1>>,
 "unstable node"                = <<14/17|4/17>,<-15/17|37/17>>,
 "semiunstable node"            = <<-9/79|24/79>,<-33/79|88/79>>,
 "saddle"                       = <<29/25|-24/25>,<9/25|-29/25>>,
 "clockwise centre"             = <<-10/11|13/11>,<-17/11|10/11>>,
 "anticlockwise centre"         = <<1/22|-10/11>,<97/88|-1/22>>,
 "clockwise stable focus"       = <<-3/23|37/46>,<-65/46|-20/23>>,
 "anticlockwise stable focus"   = <<-76/67|-149/134>,<169/134|9/67>>,
 "clockwise unstable focus"     = <<55/218|130/109>,<-97/109|163/218>>,
 "anticlockwise unstable focus" = <<5/46|-61/46>,<20/23|41/46>>,
 "degenerate stable node"       = <<-41/31|4/31>,<-25/31|-21/31>>,
 "shear flow"                   = <<40/119|25/119>,<-64/119|-40/119>>,
 "degenerate unstable node"     = <<7/3|4/3>,<-4/3|-1/3>>
]):

######################################################################

linear_2d_classify := proc(S)
 local xy,L;

 L := S["lambda"];

 if S["is_diagonalizable"] then
  if is(L[1],'real') and is(L[2],'real') then
   if is(L[2] <0) then
    if is(L[1] = L[2]) then
     S["type"] := "improper stable node";
    else
     S["type"] := "stable node";
    fi;
   elif is(L[2] = 0) then
    if is(L[1] < 0) then
     S["type"] := "semistable node";
    else # L[1] = L[2] = 0
     S["type"] := "constant";
    fi;
   else # L[1] <= L[2],  L[2] > 0
    if is(L[1] < 0) then
     S["type"] := "saddle";
    elif is(L[1] = 0) then
     S["type"] := "semiunstable node";
    elif is(L[1] = L[2]) then
     S["type"] := "improper unstable node";
    else # 0 < L[1] < [2]
     S["type"] := "unstable node";
    fi;
   fi;
  else # non-real eigenvalues
   S["direction"] := `if`(is(S["A"][2,1] < 0),"clockwise","anticlockwise");
   if is(Re(L[1]) < 0) then
    S["type"] := cat(S["direction"]," stable focus");
   elif is(Re(L[1]) = 0) then
    S["type"] := cat(S["direction"]," centre");
   else # Re(L[1]) > 0
    S["type"] := cat(S["direction"]," unstable focus");
   fi;
  fi;
 else # not diagonalizable 
  if is(L[1] < 0) then
   S["type"] := "degenerate stable node";
  elif is(L[1] = 0) then
   S["type"] := "shear flow";
  else # L[1] > 0 
   S["type"] := "degenerate unstable node";
  fi;
 fi;
 NULL;
end:

######################################################################

# a0 is assumed to be a point inside the unit circle.
# linear_2d_flow_line_limits(S,a0) returns a parameter range t0 .. t1
# such that the flow line passing through a0 at t = 0 stays within
# the unit disc for t0 <= t <= t1.

linear_2d_flow_line_limits := proc(S,a0)
 local a,aa,aas,aa0,aa1,aa2,aa3,aa4,opts,t0,t1,t2,u,i,cp,ab,c;

 a := S["P"] . <a0[1],a0[2]>;
 aa := evalf(simplify(combine(expand(a[1]^2 + a[2]^2))));
 return find_limits(aa);
end:

find_limits := proc(f)
 local fs,tt,tt0,tt1,t0,t1,err,trig_args,omega,old_digits;

 if evalf(subs(t=0,f)) >= 1 then
  return 0..0;
 fi;

 if f = 0. then
  return 0 .. 0;
 fi;

 old_digits := Digits;
 Digits := 100;

 fs := convert(series(evalf(f),t=0,40),polynom,t);
 fs := add(Re(coeff(fs,t,i))*t^i,i=0..39);
 tt := select(u -> Im(u) = 0., [fsolve(fs-1)]);
 tt0 := select(u -> u < 0,tt);
 tt1 := select(u -> u > 0,tt);

 if degree(fs,t) <= 2 and tt0 <> [] and tt1 <> [] then
  return max(tt0) .. min(tt1);
 fi;

 if tt0 = [] then
  t0 := -infinity;
 else
  t0 := max(op(tt0));
  err := abs(evalf(subs(t=t0,f-1)));
  if err < 0.01 then
   t0 := fsolve(f = 1,t=t0,maxsols=1);
  else
   t0 := -infinity;
  fi;
 fi;
 if tt1 = [] then
  t1 :=  infinity;
 else
  t1 := min(op(tt1));
  err := abs(evalf(subs(t=t1,f-1)));
  if err < 0.01 then
   t1 := fsolve(f = 1,t=t1,maxsols=1);
  else
   t1 := infinity;
  fi;
 fi;

 Digits := old_digits;

 if not(has(f,exp)) then
  if (has(f,sin) or has(f,cos)) then
   if ((t0 = -infinity) or (t1 = infinity)) then
    trig_args := 
     map(u -> op(1,u),select(u -> (op(0,u) = sin or op(0,u) = cos),indets(f,function)));
    if nops(trig_args) <> 1 then 
     return FAIL;
    fi;
    omega := subs(t=1,op(trig_args));
    return -evalf(Pi/omega) .. evalf(Pi/omega);
   fi;
  fi;
 fi;

 return t0 .. t1;
end:

######################################################################

linear_2d_flow_line := proc(S,a0)
 local a,t01,t0,t1,u,opts;

 t01 := linear_2d_flow_line_limits(S,a0);
 t0,t1 := op(t01);

 opts := NULL;

 for u in args[3..-1] do
  if type(u,`=`) and lhs(u) = 't_min' then
   t0 := rhs(u);
  elif type(u,`=`) and lhs(u) = 't_max' then
   t1 := rhs(u);
  else
   opts := opts,u;
  fi;
 od;

 a := convert(S["P"] . Vector([a0[1],a0[2]]),list);
 return plot([op(a),t=t0..t1],view=S["view"],opts);
end:

######################################################################

linear_2d_flow_line_tikz := proc(S,a0)
 local a,t01,t0,t1,u,N,tt,aa,ss,dd,b;

 t01 := linear_2d_flow_line_limits(S,a0);
 t0,t1 := op(t01);
 if t0 = -infinity then t0 := -10; fi;
 if t1 =  infinity then t1 :=  10; fi;

 a := convert(S["P"] . Vector([a0[1],a0[2]]),list);
 N := 20;
 tt := [seq(t0 + i/N*(t1 - t0),i=0..N)];
 aa := map(u -> evalf[3](subs(t=u,a)),tt);
 ss := "draw[smooth,red] ";
 dd := "";
 for b in aa do
  ss := cat(ss,dd,sprintf("(%1.3f,%1.3f)",b[1],b[2]));
  dd := " -- ";
 od;
 ss := cat(ss,";\n");

 return ss;
end:

######################################################################

linear_2d_flow_line_paperscript := proc(S,a0)
 local a,t01,t0,t1,u,N,tt,aa,ss,dd,b;

 t01 := linear_2d_flow_line_limits(S,a0);
 t0,t1 := op(t01);
 if t0 = -infinity then t0 := -10; fi;
 if t1 =  infinity then t1 :=  10; fi;

 a := convert(S["P"] . Vector([a0[1],a0[2]]),list);
 N := 20;
 tt := [seq(t0 + i/N*(t1 - t0),i=0..N)];
 aa := map(u -> evalf[3](subs(t=u,a)),tt);
 ss := "new Path(";
 dd := "";
 for b in aa do
  ss := cat(ss,dd,sprintf("[%d,%d]",round(1000*b[1]),round(1000*b[2])));
  dd := ",";
 od;
 ss := cat(ss,")");

 return ss;
end:

######################################################################

linear_2d_sample_points := proc(S)
 local c,p,q,r,a,u1,u2,s0,SP,w1,w2,w3,cd;
 if S["type"] = "constant" then
  return [];
 elif S["type"] = "semistable node" or 
      S["type"] = "semiunstable node" then
  if S["type"] = "semistable node" then
   w1 := S["u_hat",1];
   w2 := S["u_hat",2];
  else
   w1 := S["u_hat",2];
   w2 := S["u_hat",1];
  fi;
  w3 := <w1[2],-w1[1]>;
  cd := (w1[1]*w2[1] + w1[2]*w2[2])/(w3[1]*w2[1] + w3[2]*w2[2]);
  SP := NULL;
  for p from -11/12 to 11/12 by 1/6 do
   if p^2 * (1 + cd^2) < 1 then
    SP := SP,
          evalf(p * w3 + (p*cd+sqrt(1-p^2))/2*w1),
          evalf(p * w3 + (p*cd-sqrt(1-p^2))/2*w1);
   else
    SP := SP, evalf(p * w3);
   fi;
  od; 
  return [SP];
 elif S["type"] = "saddle" then
  s0 := fsolve(<cos(s)|sin(s)> . S["A"] . <cos(s),sin(s)>);
  u1 := <cos(s0),sin(s0)>;
  u2 := <u1[2],-u1[1]>;
  return [ seq(p*u1,p=-11/12 .. 11/12,1/6), 
           seq(p*u2,p=-11/12 .. 11/12,1/6) ];
 elif S["type"] = "clockwise stable focus" or 
      S["type"] = "anticlockwise stable focus" or 
      S["type"] = "clockwise unstable focus" or 
      S["type"] = "anticlockwise unstable focus" or 
      S["type"] = "clockwise centre" or 
      S["type"] = "anticlockwise centre" then
  if S["mu"][1] < S["mu"][2] then
   return [ seq(p*S["v",1],p=-11/12 .. 11/12,1/6)]; 
  else  
   return [ seq(p*S["v",2],p=-11/12 .. 11/12,1/6)]; 
  fi;
 elif S["type"] = "shear flow" then
  return [seq([p * S["u_hat",1][2], - p * S["u_hat",1][1]],
              p=-0.95 .. 0.95,0.1)];
 else 
  return evalf([seq([0.99*cos(m*Pi/12),0.99*sin(m*Pi/12)],m=0..23)]);
 fi;
end:

######################################################################

linear_2d_flow_lines := proc(S)
 display(seq(linear_2d_flow_line(S,a),a in linear_2d_sample_points(S)));
end:

######################################################################

linear_2d_flow_lines_tikz := proc(S)
 cat(seq(linear_2d_flow_line_tikz(S,a),a in linear_2d_sample_points(S)));
end:

######################################################################

linear_2d_flow_lines_paperscript := proc(S)
 local a,s,comma;

 s := "[\n";
 comma := "";

 for a in linear_2d_sample_points(S) do 
  s := cat(s,comma,linear_2d_flow_line_paperscript(S,a));
  comma := ",\n";
 od;

 s := cat(s,"]");
end:

######################################################################

linear_2d_eigenline := proc(S,i)
 local u;

 if not(is(S["lambda"][1],'real')) then return NULL; fi;
 if S["is_diagonalizable"] then
  if is(S["lambda"][1] = S["lambda"][2]) then return NULL; fi
 else
  if i = 2 then return NULL; fi;
 fi;

 u := evalf(convert(Column(S["U"],i),list));
 u := u /~ sqrt(u[1]^2+u[2]^2);
 return line(u,-~ u,args[3..-1]); 
end:

######################################################################

linear_2d_eigenline_paperscript := proc(S,i)
 local u;

 if not(is(S["lambda"][1],'real')) then return NULL; fi;
 if S["is_diagonalizable"] then
  if is(S["lambda"][1] = S["lambda"][2]) then return NULL; fi
 else
  if i = 2 then return NULL; fi;
 fi;

 u := evalf(convert(Column(S["U"],i),list));
 u := u /~ sqrt(u[1]^2+u[2]^2);
 u := map(round,1000 *~ u);

 return sprintf("new Path([%d,%d],[%d,%d])",u[1],u[2],-u[1],-u[2]);
end:

######################################################################

interface(warnlevel = 0);

linear_2d_html := proc(S)
 local html;

 html := sprintf("
<!DOCTYPE html>
<html>
<head>
 <meta charset=\"UTF-8\">
 <title>%s</title>
 <link rel=\"stylesheet\" href=\"style.css\">
 <script src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js\"> 
   MathJax.Hub.Config({
     extensions: [\"tex2jax.js\"],
     jax: [\"input/TeX\",\"output/HTML-CSS\"],
     tex2jax: {inlineMath: [[\"$\",\"$\"]]}
   });
 </script> 
 <script type=\"text/javascript\" src=\"linear_2d.js\"></script>
 <script type=\"text/javascript\" src=\"/js/paperjs/dist/paper.js\"></script>
 <script type=\"text/paperscript\" canvas=\"canvas\">

var A = %A;
var L = linear_2d.create(A);

",
  S["type"],
  convert(S["A"],listlist)
 );

 if S["has_real_eigenvalues"] then
  html := cat(html,sprintf("
L.u_hat = [%A,%A];

",
  convert(1000 * S["u_hat",1],list),
  convert(1000 * S["u_hat",2],list)
  ));
 fi;  

 html := cat(html,"
L.create_group();
L.draw_outline();

");

 if S["has_real_eigenvalues"] and S["has_distinct_eigenvalues"] then
  html := cat(html,"  
L.draw_eigenlines();

");
 fi;

 if S["type"] <> "constant" then
  html := cat(html,sprintf("
L.fetch_flow_lines('%s_lines.json');

", StringTools[SubstituteAll](S["type"]," ","_")));
 fi;

 html := cat(html,"
function onFrame(event) { L.on_frame(event); }
function onMouseDown(event) { L.on_mouse_down(event); }

 </script>
</head>
<body>
 <canvas id=\"canvas\" resize></canvas>
</body>
</html>

");

 return html;
 
end;

linear_2d_save_html := proc(S)
 web_dir := "D:/wamp/www/pm1nps/courses/MAS290/linear_2d/";
 t := StringTools[SubstituteAll](S["type"]," ","_");

 fn := cat(web_dir,t,".html");
 fd := fopen(fn,WRITE);
 fprintf(fd,linear_2d_html(S));
 fclose(fd);

 fn := cat(web_dir,t,"_lines.json");
 fd := fopen(fn,WRITE);
 fprintf(fd,curves_to_json(linear_2d_flow_lines(S)));
 fclose(fd);
end:

interface(warnlevel = 3);


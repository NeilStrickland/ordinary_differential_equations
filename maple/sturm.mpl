with(plots):
with(plottools):
with(ColorTools):

image_dir := "../lectures/images/";
video_dir := "../lectures/images/";
read("latex.mpl"):

Order := 12:

######################################################################

create_ode := proc()
 return table([]);
end:

######################################################################

set_pqr := proc(ode,p,q,r,lambda_)
 local lambda;
 lambda := `if`(nargs > 4,lambda_,0);

 ode["p"] := p;
 ode["q"] := q;
 ode["r"] := r;
 ode["lambda"] := lambda;
 ode["A"] := simplify(p/r);
 ode["B"] := simplify(diff(p,x)/r);
 ode["C"] := simplify(q/r);
 ode["P"] := simplify(ode["B"]/ode["A"]);
 ode["Q"] := simplify((ode["C"]-lambda)/ode["A"]);
 ode["P_series"] := series(ode["P"],x=0,Order);
 ode["Q_series"] := series(ode["Q"],x=0,Order);

 NULL;
end:

######################################################################

set_ABC := proc(ode,A,B,C,lambda_)
 local p,q,r,lambda;

 lambda := `if`(nargs > 4,lambda_,0);

 ode["A"] := A;
 ode["B"] := B;
 ode["C"] := C;
 ode["P"] := simplify(B/A);
 ode["Q"] := simplify((C-lambda)/A);
 ode["P_series"] := series(ode["P"],x=0,Order);
 ode["Q_series"] := series(ode["Q"],x=0,Order);
 
 p := simplify(exp(int(ode["P"],x)));
 r := simplify(p/A);
 q := simplify(r*C);

 ode["p"] := p;
 ode["q"] := q;
 ode["r"] := r;
 ode["lambda"] := lambda;

 NULL;
end:

######################################################################

set_PQ := proc(ode,P,Q,lambda_)
 set_ABC(ode,1,P,Q,args[4..-1]);
end:

######################################################################

sturm_L := proc(ode,y)
 (diff(ode["p"]*diff(y,x),x) + ode["q"]*y)/ode["r"];
end:

######################################################################

sturm_L_shift := proc(ode,y)
 sturm_L(ode,y) - ode["lambda"]*y;
end:

######################################################################

sturm_L_ABC := proc(ode,y)
 ode["A"] * diff(y,x,x) + ode["B"] * diff(y,x) + ode["C"] * y;
end:

######################################################################

sturm_L_ABC_shift := proc(ode,y)
 sturm_L_ABC(ode,y) - ode["lambda"]*y;
end:

######################################################################

sturm_L_PQ := proc(ode,y)
 diff(y,x,x) + ode["P"] * diff(y,x) + ode["Q"] * y;
end:

######################################################################

find_sols := proc(ode)
 dsolve(sturm_L_shift(ode,y(x))=0);
end:

######################################################################

find_indicial_polynomial := proc(ode)
 ode["indicial_polynomial"] :=
  alpha^2 - alpha + alpha*coeff(ode["P_series"],x,-1) + coeff(ode["Q_series"],x,-2);
 ode["indicial_roots"] := {solve(ode["indicial_polynomial"],alpha)};
 return ode["indicial_polynomial"];
end:

######################################################################

set_y := proc(ode,Y)
 local alpha,err;

 err := factor(simplify(expand(sturm_L_shift(ode,Y))));
 if err <> 0 then
  error("Given value of y is not a solution");
 fi;
 ode["y"] := Y;
 alpha := limit(simplify(x*diff(Y,x)/Y),x=0);
 ode["y_order"] := alpha;
 ode["y_series"] :=
  x^alpha*convert(series(Y/x^alpha,x=0,Order),polynom,x);
 NULL;
end:

######################################################################

set_z := proc(ode,Z)
 local alpha,err;

 err := factor(simplify(expand(sturm_L_shift(ode,Z))));
 if err <> 0 then
  error("Given value of z is not a solution");
 fi;
 ode["z"] := Z;
 alpha := limit(simplify(x*diff(Z,x)/Z),x=0);
 ode["z_order"] := alpha;
 ode["z_series"] :=
  x^alpha*convert(series(Z/x^alpha,x=0,Order),polynom,x);
 NULL;
end:

######################################################################

reduce_order := proc(ode)
 ode["v"] := simplify(int(ode["P"],x));
 ode["u"] := simplify(int(exp(-ode["v"])/ode["y"]^2,x));
 set_z(ode,ode["y"] * ode["u"]);
end:

######################################################################

find_normal_form := proc(ode)
 ode["m"] := simplify(exp(-1/2*int(ode["P"],x)));
 ode["R"] := simplify(expand(ode["Q"] - 1/2*diff(ode["P"],x) - 1/4*ode["P"]^2));
 NULL;
end:

######################################################################

find_auxiliary_polynomial := proc(L)
 local a,b,c,u;

 a := subs(x=0,L(x^2)/2);
 b := subs(x=0,L(x));
 c := subs(x=0,L(1));

 if expand(convert(L(u(x)) - a*D(D(u))(x) - b*D(u)(x) - c*u(x),D)) <> 0 then
  error "Not a constant coefficient operator of degreee two";
 fi;

 return a*lambda^2 + b*lambda + c;
end:

######################################################################

find_ode := proc(y,z)
 local y0,y1,y2,z0,z1,z2;
 y0 := y;
 z0 := z;
 y1 := diff(y,x);
 y2 := diff(y1,x);
 z1 := diff(z,x);
 z2 := diff(z1,x);
 factor([y0*z1 - y1*z0, y2*z0 - y0*z2, y1*z2 - y2*z1]);
end:

######################################################################

cols := [
 COLOR(RGB,1,0,0),
 COLOR(RGB,0,1,0),
 COLOR(RGB,0,0,1),
 COLOR(RGB,0,1,1),
 COLOR(RGB,1,0,1),
 COLOR(RGB,1,1,0)
]:

cols := map(s -> COLOR(RGB,op(NameToRGB24(s) /~ 256.)),[
 "Red",
 "Green",
 "Blue",
 "DarkTurquoise",
 "Magenta",
 "DarkOrange"
]):

######################################################################

fade := proc(c) local d; d := 0.7; COLOR(RGB,seq(d + (1-d)*op(i,c),i=2..4)); end:

######################################################################

save_pdf := proc(P,fn,w_,h_)
 local old_dir,cmd,w,h,o;

 w := `if`(nargs > 2,w_,500);
 h := `if`(nargs > 3,h_,500);
 o := sprintf("noborder,width=%d,height=%d",w,h);

 plotsetup(eps,plotoutput=cat(image_dir,fn,".eps"),
           plotoptions=o);
 print(P);
 plotsetup(default);
 old_dir := currentdir(image_dir);
 cmd := sprintf("ps2pdf.bat -dEPSCrop %s.eps %s.pdf",fn,fn);
 ssystem(cmd);
 currentdir(old_dir);
 NULL;
end:



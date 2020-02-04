read("phase.mpl"):

ODE :=
 create_ode(y^3-y,x-x^3,
            "conserved_quantity" = (x^2-1)^2/4 + (y^2-1)^2/4,
            "view" = [-2.2..2.2,-2.2..2.2],
            "key" = "contour_flow",
	    "title" = "Contour flow",
	    "x_scale" = 80,
	    "y_scale" = 80,
	    "t_scale" = 0.4
	    ):

ODE["make_plots"] := proc(ODE)
 local P,P1,P2,P3,i,j,v,r0,r1,r2,R2;
 
 classify_equilibria(ODE);

 #find_flow_lines(
 # ODE,
 # [seq([i*0.1,i*0.1,6],i=-10..10),seq([i*0.1,-i*0.1,6],i=-10..10),
 #  seq([i*0.1,0],i=13..20),
 #  seq(seq(evalf([sqrt(1+1/sqrt(2))*i,sqrt(1+1/sqrt(2))*j,-5..5]),j=-1..1,2),i=-1..1,2)]
 # ):

 for v from 0.25 to 2.45 by 0.3 do 
  r0 := sqrt(2)*sqrt((2+sqrt(4*v*cos(4*t)+12*v-2*cos(4*t)-2))/(cos(4*t)+3));
  add_flow_line(ODE,r0*cos(t),r0*sin(t),0..2*Pi):
 od:

 for v from 0.25 to 0.5 by 0.05 do 
  r1 := sqrt(-(2*(-2+sqrt(4*v*cos(4*t)+12*v-2*cos(4*t)-2)))/(cos(4*t)+3));
  add_flow_line(ODE,r1*cos(t),r1*sin(t),0..2*Pi):
 od:

 R2 := collect(combine(subs(
  RootOf(4*_Z^2-1) = 1/2,
   convert(series(solve(((1+r*cos(t))^2-1)^2+((1+r*sin(t))^2-1)^2 = V,r),
		  V=0,6),polynom,V))),
  V):

 for v from 0.1 to 0.7 by 0.2 do 
  r2 := evalf(subs(V=v,R2));
  add_flow_line(ODE, 1+r2*cos(t), 1+r2*sin(t),0..2*Pi);
  add_flow_line(ODE,-1-r2*sin(t), 1+r2*cos(t),0..2*Pi);
  add_flow_line(ODE,-1-r2*cos(t),-1-r2*sin(t),0..2*Pi);
  add_flow_line(ODE, 1+r2*sin(t),-1-r2*cos(t),0..2*Pi);
 od:

 ODE["x_nullcline_plot"] := display(
  seq(line([-2.2,i],[2.2,i],colour=cyan),i=-1..1)
 ):
 ODE["y_nullcline_plot"] := display(
  seq(line([i,-2.2],[i,2.2],colour=green),i=-1..1)
 ):

 ODE["arrows"] := table():
 for i in {2,3} do
  for j from 0 to 3 do
   add_arrow_by_index(ODE,i,evalf(j*Pi/2));
  od;
 od;

 add_arrow_by_index(ODE,10);
 add_arrow_by_index(ODE,12);

 for i from 19 to 22 do add_arrow_by_index(ODE,i,3.8); od:

 P := display(
  all_flow_lines_plot(ODE),
  curve([[-2.2,-2.2],[2.2,-2.2],[2.2,2.2],[-2.2,2.2],[-2.2,-2.2]],colour=white),
 # ODE["x_nullcline_plot"],
 # ODE["y_nullcline_plot"],
  NULL
 ):

 P1 := display(P,ODE["x_nullcline_plot"]):
 save_pdf(P1,"contour_flow_xn");
 P2 := display(P1,ODE["y_nullcline_plot"]):
 save_pdf(P2,"contour_flow_xnyn");
 P3 := display(P2,seq(seq(blob([i,j],0.02),i=-1..1),j=-1..1)):
 save_pdf(P3,"contour_flow_xnynep");

 save_lines(ODE);
end:

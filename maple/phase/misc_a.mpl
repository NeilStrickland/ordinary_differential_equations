read("phase.mpl"):

ODE := create_ode(x*(1-x-y),y*(2-y^2-3*x^2),
                  "view"=[-2..2,-2..2],
                  "key"="misc_a",
		  "x_scale"=100,
		  "y_scale"=100
		  ):

ODE["make_plots"] := proc(ODE)
 local P;
 
 find_flow_lines(ODE,
  [seq([-2, 2*t0^2,-10..0],t0=0.3..1,0.1),
   seq([-2,-2*t0^2,-10..0],t0=0.3..1,0.1),
   seq([ 2, 2*t0^2,0..10],t0=0..1,0.2),
   seq([t0,2,0..10],t0=-0.55..1.95,0.2),
   seq([t0,-2],t0=-0.45..1.95,0.2),
   seq([x1,1-x1,-10..10],x1=-0.3..0.7,0.1),
   seq(evalf([sqrt(2/3)*cos(t0*Pi),sqrt(2)*sin(t0*Pi),-10..10]),t0=15/24..2,2/24)
  ]):

 ODE["x_nullcline_plot"] := 
  display(
   plot([0,y,y=-2..2],colour=cyan),
   plot(1-x,x=-1..2,colour=cyan),
   view=ODE["view"]
  ):

 ODE["y_nullcline_plot"] := 
  display(
   plot([sqrt(2/3)*cos(t),sqrt(2)*sin(t),t=0..2*Pi],colour=green),
   plot(0,x=-2..2,colour=green),
   view=ODE["view"]
  ):

 P := full_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:



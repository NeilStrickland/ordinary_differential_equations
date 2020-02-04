read("phase.mpl"):

ODE := create_ode(x*(1-x-y),y*(2-y-3*x),
                  "view"=[-1..2,-0.5..2],
                  "key"="misc_b",
		  "x_scale"=150,
		  "y_scale"=150
):

ODE["make_plots"] := proc(ODE)
 local P;
 
 find_flow_lines(ODE,
 [
	 seq([-1,t0,-10..0],t0=-0.5..1.1,0.2),
	 seq([ 2,t0, 0..10],t0=-0.6..2,0.2),
	 seq([x1,2,0..10],x1=1.2..2,0.2),
	 seq([x1,-0.5,-10..0],x1=-1..0.8,0.2),
	 seq([x1,-0.5,0..10],x1=1.1..1.9,0.2),
	 seq([x1,1-x1,-10..10],x1=-1..0.5,0.1),
	 seq([x1,2-3*x1,-10..10],x1=1/24..11/24,1/12),
	 seq([x1,2-3*x1,-10..10],x1=13/24..20/24,1/24),
	 NULL
 ]):

 ODE["x_nullcline_plot"] := 
  display(
   plot([0,y,y=-2..2],colour=cyan),
   plot(1-x,x=-1..2,colour=cyan),
   view=ODE["view"]
  ):

 ODE["y_nullcline_plot"] :=
  display(
   plot(2-3*x,x=0..2,colour=green),
   plot(0,x=-2..2,colour=green),
   view=ODE["view"]
  ):

 P := full_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:



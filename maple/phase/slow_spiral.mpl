read("phase.mpl"):

ODE := create_ode( y-(x^2+y^2)*x,
                  -x-(x^2+y^2)*y,
                  "view"=[-1..1,-1..1],
                  "key"="slow_spiral",
		  "title"="Slow spiral"):

ODE["make_plots"] := proc(ODE)
 local P,i;

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([cos(i*Pi/24),sin(i*Pi/24),0..10],i=0..47,2)
 ]):

 for i from  2 to  24 by 2 do add_arrow_by_index(ODE,i,0.1); od:

 ODE["x_nullcline_plot"] :=
  display(
   plot((1-sqrt(1-4*x^4))/(2*x),x=-1/sqrt(2)..1/sqrt(2),colour=cyan,view=ODE["view"])
  ):

 ODE["y_nullcline_plot"] :=
  display(
   plot([(-1+sqrt(1-4*y^4))/(2*y),y,y=-1/sqrt(2)..1/sqrt(2)],colour=green,view=ODE["view"])
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:

ODE_lin := create_ode( y,
                  -x,
                  "view"=[-1..1,-1..1],
                  "key"="slow_spiral_lin",
		  "title"="Slow spiral linearisation"):

ODE_lin["make_plots"] := proc(ODE)
 local P,i;

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([i*0.1,0,0..10],i=1..10)
 ]):

 for i from  1 to  10 do add_arrow_by_index(ODE,i,0.1); od:

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


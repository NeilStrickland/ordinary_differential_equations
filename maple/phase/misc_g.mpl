read("phase.mpl"):

ODE := create_ode(x^2+y^2-1,
                  x^2-y^2,
		  "view"=[-2..2,-2..2],
		  "key" = "misc_g",
 	          "x_scale" = 120,
		  "y_scale" = 120,
		  "t_scale" = 0.2
):

ODE["make_plots"] := proc(ODE)
 local P,i;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([-2, i, 0..2],i=-1.41..1.99,0.2),
  seq([ i, 2, 0..2],i=-1.61..1.99,0.2),
  seq([ 2,-i,-2..0],i=-1.41..1.99,0.2),
  seq([-i,-2,-2..0],i=-1.61..1.99,0.2),
  seq([ 0,i,-2..2],i=-0.61..0.59,0.2),
  NULL
 ]):

 ODE["x_nullcline_plot"] :=
  display(plot([cos(t),sin(t),t=0..2*Pi],colour=cyan),
   axes=none,scaling=constrained
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-2,-2],[2,2],colour=green),
   line([-2, 2],[2,-2],colour=green),
   axes=none,scaling=constrained
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


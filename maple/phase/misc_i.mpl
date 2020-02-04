read("phase.mpl"):

ODE := create_ode(sin(Pi*x) + y,
                  cos(Pi*x) - y,
		  "view"=[-3..3,-3..3],
		  "key" = "misc_i",
 	          "x_scale" = 120,
		  "y_scale" = 120,
		  "t_scale" = 0.2
):

ODE["make_plots"] := proc(ODE)
 local R,P,i;

 R := 3;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ i, R, 0.. 3],i=-2.95..2.95,0.2),
  seq([ i,-R, 0.. 3],i=-2.95..2.95,0.2),
  seq([-R, i, 0.. 3],i=    0..2.80,0.2),
  seq([ R, i, 0.. 3],i=-2.80..   0,0.2),
  NULL
 ]):

 ODE["x_nullcline_plot"] :=
  display(
   plot(-sin(Pi*t),t=-R..R,colour=cyan),
   axes=none,scaling=constrained
  ):

 ODE["y_nullcline_plot"] :=
  display(
   plot( cos(Pi*t),t=-R..R,colour=green),
   axes=none,scaling=constrained
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


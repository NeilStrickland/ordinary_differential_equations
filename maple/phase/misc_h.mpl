read("phase.mpl"):

ODE := create_ode(1+x*y,
                  1-y^2,
		  "view"=[-2..2,-2..2],
		  "key" = "misc_h",
 	          "x_scale" = 120,
		  "y_scale" = 120,
		  "t_scale" = 0.2,
		  "conserved_quantity" =
		   sqrt(1-y^2) * sin(x * sqrt(1-y^2)) - y * cos(x * sqrt(1-y^2)) 
):

ODE["make_plots"] := proc(ODE)
 local R,P,i;

 R := 2;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([-i, i,-3..3],i=-1.95..1.95,0.2),
  seq([ i, 2, 0..3],i=-0.95..1.95,0.2),
  seq([-2, i, 0..3],i=-0.25..0.45,0.1),
  seq([ i,-2,-3..0],i=-1.95..0.95,0.2),
  seq([ 2,-i,-3..0],i=-0.25..0.45,0.1),
  NULL
 ]):

 ODE["x_nullcline_plot"] :=
  display(
   plot(-1/t,t=-R..-1/R,colour=cyan),
   plot(-1/t,t= 1/R.. R,colour=cyan),
   axes=none,scaling=constrained
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-R,-1],[ R,-1],colour=green),
   line([-R, 1],[ R, 1],colour=green),
   axes=none,scaling=constrained
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


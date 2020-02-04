read("phase.mpl"):

ODE := create_ode(x*(3-x-2*y),
                  y*(x-1),
                  "view"=[-1..5,-2..3],
                  "key"="predator",
		  "title"="Predator",
		  "x_scale"=80,
		  "y_scale"=80,
		  "t_scale"=0.4
):

ODE["make_plots"] := proc(ODE)
 local P,i;

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([-1, i,-3..0],i=-1.9..1.9,0.2),
  seq([5, i,0..5],i=0..3,0.2),
  seq([1,i,-3..3],i=-2..0,0.2),
  seq([1,i,-3..5],i=0.1..0.3,0.1),
  seq([5,i],i=-1.6..-0.2,0.2),
  NULL
 ]):

 #for i from  2 to  8 by 2 do add_arrow_by_index(ODE,i,0); od:

 ODE["x_nullcline_plot"] :=
  display(
   line([0,-2],[0,3],colour=cyan),
   plot((3-x)/2,x=-1..5,colour=cyan,view=ODE["view"])
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-1,0],[5,0],colour=green),
   line([1,-2],[1,3],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 ODE["faded"] := fade_curves(all_flow_lines_plot(ODE));
 save_pdf(ODE["faded"],"predator_faded");

 ODE["sketch_a"] := display(
  ODE["x_nullcline_plot"],
  ODE["y_nullcline_plot"],
  axes=none,scaling=constrained
 ):

 ODE["sketch_b"] := display(
  ODE["sketch_a"],
  blob([0,0],0.025),blob([3,0],0.025),blob([1,1],0.025)
 ):
end:



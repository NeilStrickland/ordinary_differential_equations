read("phase.mpl"):

ODE := create_ode(2*x*(1-x-y),
                  y*(1-2*x-2*y),
                  "view"=[0..1.2,0..1.2],
                  "key"="competition",
		  "title"="Competition",
		  "x_scale"=400,
		  "y_scale"=400,
		  "t_scale"=0.4):

ODE["make_plots"] := proc(ODE)
 local i,P;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([1.2, i,0..3],i=0.05..1.15,0.1),
  seq([ i,1.2,0..3],i=0.05..1.15,0.1),
  seq([ i,1/2-i,-3..3],i=0.05..0.45,0.05)
 ]):

 for i from  2 to 24 by 2 do add_arrow_by_index(ODE,i,0.3); od:
 for i from 26 to 32 by 2 do add_arrow_by_index(ODE,i,0.0); od:

 ODE["x_nullcline_plot"] :=
  display(
   line([0,0],[0,1.2],colour=cyan),
   line([0,1],[1,0],colour=cyan),
   view=ODE["view"]
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([ 0,0],[2,0],colour=green),
   line([0,1/2],[1/2,0],colour=green),
   view=ODE["view"]
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:

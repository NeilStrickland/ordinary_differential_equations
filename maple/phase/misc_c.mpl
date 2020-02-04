read("phase.mpl"):

ODE := create_ode(x^2+2*y^2-y,2*x+2*y,
                  "view"=[-1..1,-1..1],
                  "key"="misc_c"):

ODE["make_plots"] := proc(ODE)
 local P,P0,P1;

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  [-1/3+0.01,1/3,-4..4],
  [-1/3-0.01,1/3,-4..4],
  [-1/3,1/3-0.01,-4..4],
  [-1/3,1/3+0.01,-4..4],
  seq([ i, 1,-4..0],i=-1..1,0.2),
  seq([-1, i, 0..4],i=-1..1,0.2),
  seq([ 1, i,-4..0],i=-1..1,0.2)
 ]):

 ODE["x_nullcline_plot"] := 
  display(
   plot([cos(t)/sqrt(8),(1+sin(t))/4,t=0..2*Pi],colour=cyan),
   view=ODE["view"]
  ):

 ODE["y_nullcline_plot"] :=
  display(
   plot(-x,x=-1..1,colour=green),
   view=ODE["view"]
  ):

 P := all_flow_lines_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 P0 := full_plot(ODE):
 save_pdf(P0,cat(ODE["key"],"_0")):

 P1 := display(P0,blob([0,0],0.006),blob([-0.333,0.333],0.006)):
 save_pdf(P1,cat(ODE["key"],"_1")):

end:

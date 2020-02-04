# Used for ex-read-portrait

read("phase.mpl"):

ODE := create_ode(x^2+2*y^2-1/2,-sqrt(2)*x*y,
                  "view"=[-1..1,-1..1],
                  "key"="misc_e"):

ODE["make_plots"] := proc(ODE)
 local P,i;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ 0, i,-5..5],i=-0.45..0.45,0.05),
  seq([ 1,i,-5..5],i=-1..1,0.1),
  seq([-1,i,-5..5],i=-1..1,0.1),
  [0, 0.7769,-10..10],
  [0,-0.7769,-10..10],
  NULL
 ]):

 ODE["x_nullcline_plot"] := 
  plot([cos(t)/sqrt(2),sin(t)/2,t=0..2*Pi],colour=cyan):

 ODE["y_nullcline_plot"] := 
  display(line([-1,0],[1,0],colour=green),line([0,-1],[0,1],colour=green)):

 for i in {1,3,5,7,9,10,11,13,15,17,19} do add_arrow_by_index(ODE,i,0); od:
 for i in {25,28,32,35} do add_arrow_by_index(ODE,i,-0.2); od:
 #for i from 33 to 50 by 3 do add_arrow_by_index(ODE,i,-0.5); od:

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 ODE["points"] := display(
  fade_curves(all_flow_lines_plot(ODE)),
  blob([ 0.00, 0.00],0.005),
  blob([ 0.00, 0.50],0.005),
  blob([ 0.71, 0.00],0.005),
  blob([ 0.71, 0.71],0.005),
  blob([-0.71, 0.00],0.005),
  blob([ 0.50, 0.30],0.005),
  blob([-0.75,-0.68],0.005),
  axes=boxed
 ):

 save_pdf(ODE["points"],"misc_e_points");

end:
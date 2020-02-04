read("phase.mpl"):

R := 2.0;
ODE := create_ode(x^2-y^2+2*x*y,
                  x^2-y^2-2*x*y,
                  "view"=[-R..R,-R..R],
                  "key"="fluid",
		  "title"="Fluid",
		  "x_scale"=100,
		  "y_scale"=100,
		  "t_scale"=0.5
):

ODE["make_plots"] := proc(ODE)
 local P,i,j,extra_lines_blue,extra_lines_red;
 
 classify_equilibria(ODE);

 check_solution(ODE,1/2/t,-1/2/t);
 check_solution(ODE,(-1+sqrt(3))/4/t,( 1+sqrt(3))/4/t);
 check_solution(ODE,(-1-sqrt(3))/4/t,( 1-sqrt(3))/4/t);

 find_flow_lines(ODE,[
  seq([i, i,-3..3],i=-2..2,0.2),
  seq([-i/(1+sqrt(2)),i,-4..4],i=-2..2,0.2),
  seq([i,-i/(1+sqrt(2)),-4..4],i=-2..2,0.2)
 ]):

 for i in {3,6,9,13,16,19} do
  for j from 0 to 2 do
   add_arrow_by_index(ODE,i+21*j,0);
  od:
 od:

 ODE["x_nullcline_plot"] :=
  display(
   line([-R, (1+sqrt(2))*R],[R, -(1+sqrt(2))*R],colour=cyan),
   line([-R, (1-sqrt(2))*R],[R, -(1-sqrt(2))*R],colour=cyan),
   view=ODE["view"]
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-R,-(1+sqrt(2))*R],[R, (1+sqrt(2))*R],colour=green),
   line([-R,-(1-sqrt(2))*R],[R, (1-sqrt(2))*R],colour=green),
   view=ODE["view"]
  ):

 extra_lines_blue := 
  display(
   line([-2,2],[2,-2],thickness=2,colour=blue),
   line([-R/(2+sqrt(3)),-R],[R/(2+sqrt(3)),R],thickness=2,colour=blue),
   line([-R,-R/(2+sqrt(3))],[R,R/(2+sqrt(3))],thickness=2,colour=blue)
  ):

 extra_lines_red := 
  subs(op(2,op(1,extra_lines_blue)) = COLOUR(RGB,1,0,0),extra_lines_blue);

 P := display(all_flow_lines_plot(ODE),extra_lines_blue);

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(all_flow_lines_plot(ODE),cat(ODE["key"],"_0"));

 ODE["flow_plot_blue"] := display(ODE["flow_plot"],extra_lines_blue):
 ODE["flow_plot"]      := display(ODE["flow_plot"],extra_lines_red):

end:
read("phase.mpl"):

R := 2.0;
ODE := create_ode(x^2-y^2,x+1,
                  "view"=[-R..R,-R..R],
                  "key"="misc_d",
		  "x_scale"=100,
		  "y_scale"=100
):

ODE["make_plots"] := proc(ODE)
 local P,P0,R;

 R := ODE["view_x_max"];
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([i,i,-4..4],i=-2..2,0.2),
  seq([2,i,-4..0],i=-2..2,0.2),
  seq([-1,i,-4..4],i=-2..0.8,0.2),
  [-1.01,-1],[-0.99,-1],[-1.8,-0.75,-1..1],[-0.7,-1.13,-2..1]
 ]):

 add_arrow_by_index(ODE, 2,-0.2);
 add_arrow_by_index(ODE, 4,-0.6);
 add_arrow_by_index(ODE, 8,-0.6);
 add_arrow_by_index(ODE,10,-0.6);
 add_arrow_by_index(ODE,12,-0.5);
 add_arrow_by_index(ODE,14,-0.4);
 add_arrow_by_index(ODE,16,-0.3);
 add_arrow_by_index(ODE,18,-0.2);
 add_arrow_by_index(ODE,26,-0.1);
 add_arrow_by_index(ODE,29,-0.1);
 add_arrow_by_index(ODE,32,-0.1);
 add_arrow_by_index(ODE,35,-0.1);
 add_arrow_by_index(ODE,51,-0.2);
 add_arrow_by_index(ODE,53,-0.2);
 add_arrow_by_index(ODE,55,-0.2);
 add_arrow_by_index(ODE,57,-0.2);

 ODE["x_nullcline_plot"] :=
  display(
   line([-R,-R],[R,R],colour=cyan),
   line([-R,R],[R,-R],colour=cyan)
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-1,-R],[-1,R],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 P0 := all_flow_lines_plot(ODE):
 save_pdf(P0,cat(ODE["key"],"_0"));
end:




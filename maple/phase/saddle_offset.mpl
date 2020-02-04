read("phase.mpl"):

key := "saddle_offset";

R := 2.0;

ODE := create_ode(y-1,x-1,
                  "conserved_quantity" = (x-1)^2-(y-1)^2,
                  "view"=[-R..R,-R..R],
		  "key"="saddle_offset",
		  "title"="Offset saddle",
		  "x_scale"=100,
		  "y_scale"=100
		  ):

ODE["make_plots"] := proc(ODE)
 local P,i,R;

 R := ODE["view_x_max"];

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([1,i,-5..5],i=-2..2,0.2),
  seq([i,1,-5..5],i=-2..2,0.2),
  [1.01,1.01],[0.99,0.99]
 ]):

 for i from 3 to 41 by 2 do
  add_arrow_by_index(ODE,i,0.2);
 od:

 ODE["x_nullcline_plot"] :=
  display(
   line([-R,1],[R,1],colour=cyan)
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([1,-R],[1,R],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


read("phase.mpl"):

R := 2.0;
ODE := create_ode(x^2+y^2,
                  x+1,
		  "view"=[-R..R,-R..R],
		  "key"="free_flow",
		  "title"="Free flow",
		  "x_scale" = 100,
		  "y_scale" = 100
		  ):

ODE["make_plots"] := proc(ODE)
 local P,i,j,R;

 R := ODE["view_x_max"];
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([-R, i*R, 0..10],i=-0.4..1,0.1),
  seq([ R, i*R, -10..0],i=-1..1,0.1)
 ]):

 for i from 2 to 16 by 2 do add_arrow_by_index(ODE,i,0.1); od:
 for i from 20 to 34 by 2 do add_arrow_by_index(ODE,i,-0.1); od:

 ODE["y_nullcline_plot"] :=
  display(
   line([-1,-R],[-1,R],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(all_flow_lines_plot(ODE),cat(ODE["key"],"_0"));
end:

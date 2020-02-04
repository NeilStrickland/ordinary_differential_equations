read("phase.mpl"):

R := 2.0;

ODE := create_ode(1+y,1-2*x,
                  "conserved_quantity" = (x-1/2)^2 + (y+1)^2/2, 
                  "view"=[-R..R,-R..R],
                  "key" = "centre_offset",
		  "title" = "Offset centre",
		  "x_scale" = 100,
		  "y_scale" = 100):

ODE["make_plots"] := proc(ODE)
 local P,i,R;

 R := ODE["view_x_max"];
 
 classify_equilibria(ODE);

 for i from 0.2 to 3 by 0.2 do 
  add_flow_line(ODE,1/2+i*cos(t),-1-i*evalf(sqrt(2))*sin(t),0..2*Pi):
 od:

 for i from 1 to 10 do
  add_arrow_by_index(ODE,i,-3*Pi/4);
 od:

 ODE["x_nullcline_plot"] :=
  display(
   line([-R,-1],[R,-1],colour=cyan)
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([1/2,-R],[1/2,R],colour=green)
  ):

 P := full_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:
read("phase.mpl"):

R := 2;
ODE := create_ode(sin(Pi*y),0,
                  "conserved_quantity" = y,
                  "view"=[-R..R,-R..R],
                  "key"="periodic_shear",
		  "title"="Periodic shear",
		  "x_scale"=100,
		  "y_scale"=100
):

ODE["make_plots"] := proc(ODE)
 local i,P,R,s;

 R := ODE["view_x_max"];
 
 for i from -1.95 to 1.95 by 0.1 do
  s := sin(evalf(Pi)*i);
  add_flow_line(ODE,s*t,i,-2/s..2/s);
 od: 

 for i from 1 to 40 do
  add_arrow_by_index(ODE,i,1);
 od:

 ODE["x_nullcline_plot"] :=
  display(seq(line([-R,i],[R,i],colour=cyan),i=-2..2)):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:


read("phase.mpl"):

ODE := create_ode(1,
                  sin(Pi*y),
		  "view"=[-2..2,-2..2],
		  "key" = "bands",
		  "title" = "Bands",
		  "x_scale" = 100,
		  "y_scale" = 100,
		  "t_scale" = 0.4,
		  "show_trace" = true):

# The quantity below is conserved when floor(y) is even.
# It is not conserved in general, so an error would be generated
# if we specified it as an argument to create_ode().

ODE["conserved_quantity"] := arcsinh(tan(Pi*(y-1/2)))/Pi - x:

ODE["make_plots"] := proc(ODE)
 local P,i,j;
 
 find_flow_lines(ODE,
  [seq(seq([i*0.2,j+1/2,(-2-i*0.2)..(2-i*0.2)],i=-15..15),j=-2..1)]
 ):

 ODE["arrows"] := table():
 for i in {10,16,22} do
  for j from 0 to 3 do
   add_arrow_by_index(ODE,i+31*j,0);
  od:
 od:

 P := all_flow_lines_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:

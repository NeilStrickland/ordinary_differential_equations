read("phase.mpl"):

ODE := create_square_ode(18,10*sqrt(7),sqrt(7)/8,5/8,
                         "key"="quad_a",
			 "title"="Quadratic A",
			 "view" = [-2..2,-2..2],
			 "x_scale" = 120,
			 "y_scale" = 120,
			 "t_scale" = 0.1
			 ):

ODE["make_plots"] := proc(ODE)
 local P,i;

 classify_equilibria(ODE);

 find_flow_lines(ODE,
 [
  seq([i,i,-10..10],i=-0.9..0.9,0.2),
  seq([-2,i,-10..0],i=-2..2,0.2),
  seq([i,-2,0..10],i=-0.6..2,0.2),
  seq([i,2,-10..0],i=-2..2,0.2),
  seq([2,i,0..10],i=-2..0.6,0.2),
  [-1.01,-1.01,-1..1],[-0.99,-0.99,-1..1],[1.01,1.01,-1..1],[0.99,0.99,-1..1]
 ]):

 ODE["arrows"] := table():
 for i in {1,3,5,6,8,10} do
  add_arrow_by_index(ODE,i,0);
 od;
 add_arrow_by_index(ODE,17,-0.05);
 add_arrow_by_index(ODE,20,-0.02);
 add_arrow_by_index(ODE,24,-0.02);
 add_arrow_by_index(ODE,31,-0.02);
 add_arrow_by_index(ODE,34, 0.02);
 add_arrow_by_index(ODE,38, 0.02);
 add_arrow_by_index(ODE,45, 0.02);
 add_arrow_by_index(ODE,53,-0.02);
 add_arrow_by_index(ODE,57,-0.02);
 add_arrow_by_index(ODE,60,-0.05);
 add_arrow_by_index(ODE,74, 0.02);
 add_arrow_by_index(ODE,78, 0.02);

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(P,"quad_a_xnyn");

end:



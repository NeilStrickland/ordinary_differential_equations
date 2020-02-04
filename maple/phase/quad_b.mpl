read("phase.mpl"):

ODE := create_square_ode(1/5,1,3/4,1/2,
                         "key"="quad_b",
			 "title"="Quadratic B",
			 "view" = [-2..2,-2..2],
			 "x_scale" = 120,
			 "y_scale" = 120,
			 "t_scale" = 0.2
			 ):

ODE["equations"] := cat(
   "\\begin{align*}\n",
   " \\dot{x} &= (12y^2-9x^2-3)/40 \\\\\n",
   " \\dot{y} &= (46y^2+25x^2-71)/40 \n",
   "\\end{align*}\n"
  );

ODE["make_plots"] := proc(ODE)
 local P,i;

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([i,0,-10..10],i=-0.8..0.8,0.2),
  seq([i, 2,-10..0],i=-2..2,0.2),
  seq([i,-2,0..10],i=-2..2,0.2),
  seq([-2,i,-10..0],i=-0.3..1.1,0.2),
  seq([ 2,i,0..10],i=-1.1..0.3,0.2),
  [-2,-0.35657195,-6..0],[2,0.35657195,0..6],
  NULL
 ]):

 ODE["arrows"] := table();
 for i in {1,3,5,7,9} do 
  add_arrow_by_index(ODE,i,0);
 od;

 add_arrow_by_index(ODE,11,-0.10);
 add_arrow_by_index(ODE,16,-0.18);
 add_arrow_by_index(ODE,21,-0.18);
 add_arrow_by_index(ODE,26,-0.18);
 add_arrow_by_index(ODE,28,-0.18);
 add_arrow_by_index(ODE,33, 0.18);
 add_arrow_by_index(ODE,35, 0.18);
 add_arrow_by_index(ODE,40, 0.18);
 add_arrow_by_index(ODE,45, 0.18);
 add_arrow_by_index(ODE,50, 0.18);
 add_arrow_by_index(ODE,53,-0.68);
 add_arrow_by_index(ODE,65, 0.68);

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(P,"quad_b_xnyn");
end:


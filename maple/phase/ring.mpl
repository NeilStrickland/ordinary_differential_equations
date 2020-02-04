read("phase.mpl"):

R := 1.0;
ODE := create_ode(x^2+y^2-1,x^2+y^2-1,
                  "conserved_quantity" = y-x,
                  "view"=[-2..2,-2..2],
                  "key"="ring",
		  "title" = "Ring of equilibrium points",
		  "x_scale" = 100,
		  "y_scale" = 100,
		  "t_scale" = 0.5
):

ODE["make_plots"] := proc(ODE)
 local P,P_grey,i,j,R,rr,tt,r0,r1;

 R := ODE["view_x_max"];
 
# classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([i,-2,0..2],i=-2..2,0.2),
  seq([-2,i,0..2],i=-2..2,0.2),
  seq([i,2.4-i,-2..1],i=0.4..2,0.1),
  seq([i,-i,-2..2],i=-0.7..0.7,0.1)
 ]):

 for i from 2 to 28 by 2 do add_arrow_by_index(ODE,i,0); od:

 ODE["x_nullcline_plot"] :=
  display(plot([cos(t),sin(t),t=0..2*Pi],colour=cyan),
   axes=none,scaling=constrained
  ):

 ODE["y_nullcline_plot"] :=
  display(plot([cos(t),sin(t),t=0..2*Pi],colour=green),
   axes=none,scaling=constrained
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


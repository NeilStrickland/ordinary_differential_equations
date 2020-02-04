read("phase.mpl"):

ODE := create_ode( x-y-x^3-x*y^2,
                   x+y-x^2*y-y^3,
                  "view"=[-1.5..1.5,-1.5..1.5],
                  "key"="limit_cycle",
		  "title"="Limit cycle",
		  "x_scale" = 150,
		  "y_scale" = 150
		  ):

ODE["extra_options"] := "ODE.view_type='disc'; ODE.view_radius=1.5;";

ODE["make_plots"] := proc(ODE)
 local P,i;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([cos(i*Pi/24)/2,sin(i*Pi/24)/2,-5..5],i=0..47,2),
  seq([cos(i*Pi/24)*3/2,sin(i*Pi/24)*3/2,0..5],i=0..47,2)
 ]):

 for i from  2 to  48 by 2 do add_arrow_by_index(ODE,i,0.1); od:

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:



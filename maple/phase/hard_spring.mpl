read("phase.mpl"):

epsilon := -0.5:
R := 4:

ODE := create_ode(y,-x+epsilon*x^3,
                  "view"=[-R..R,-R..R],
                  "key"="hard_spring",
		  "title"="Hard spring",
		  "x_scale" = 50,
		  "y_scale" = 50,
		  "t_scale" = 1
		  ):

ODE["epsilon"] := epsilon;

ODE["make_plots"] := proc(ODE)
 local P,i,j,R,epsilon;

 R := ODE["view_x_max"];
 epsilon := ODE["epsilon"];
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ i*R,0,-5..5],i=-1.15..1.15,0.05)
 ]):

 for i from  2 to 18 by 2 do add_arrow_by_index(ODE,i,0.3); od:

 ODE["x_nullcline_plot"] :=
  display(line([-R,0],[R,0],colour=cyan)):

 ODE["y_nullcline_plot"] :=
  display(
   line([ 0,-R],[0,R],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:


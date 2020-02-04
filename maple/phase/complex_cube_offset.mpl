read("phase.mpl"):

R := 2.3:

ODE := create_ode(x^3-3*x*y^2-1,3*x^2*y-y^3,
                  "view"=[-R..R,-R..R],
                  "key" = "complex_cube_offset",
		  "title" = "Offset complex cube",
		  "x_scale" = 100,
		  "y_scale" = 100):

ODE["extra_opts"] := cat(
 "ODE.view_type = 'disc';\n",
 "ODE.view_radius = 2.3;\n",
 "ODE.display_digits = 4;\n"
):

ODE["make_plots"] := proc(ODE)
 local P,i,S,zz,om,R;

 R := ODE["view_x_max"];
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  [1.5,0,-1..1],
  seq([ 0,i,-10..10,numpoints=500],i=-1..1,0.1),
  seq([0.7*cos(i*Pi/24),0.7*sin(i*Pi/24),-10..10,numpoints=500],i=-5..5)
 ]):

 for i from 1 to 21 by 2 do add_arrow_by_index(ODE,i,0); od:

 S := evalf(sqrt(R^6-1)):
 zz := (1+I*s)^(1/3):
 om := evalf(exp(2*Pi*I/3)):

 ODE["x_nullcline_plot"] :=
  display(
   plot([Re(zz   ),Im(zz   ),s=-S..S],colour=cyan),
   plot([Re(zz*om),Im(zz*om),s=-S..S],colour=cyan),
   plot([Re(zz/om),Im(zz/om),s=-S..S],colour=cyan),
   view=ODE["view"]
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-R,0],[R,0],colour=green),
   line([-R/2,-R*sqrt(3)/2],[ R/2, R*sqrt(3)/2],colour=green),
   line([-R/2, R*sqrt(3)/2],[ R/2,-R*sqrt(3)/2],colour=green)
  ):

 P := full_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(all_flow_lines_plot(ODE),cat(ODE["key"],"_0"));
end:

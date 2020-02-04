read("phase.mpl"):

R := 2.0;
ODE := create_ode(x^2-y^2-1/4,2*x*y,
                  "x" = -(1/2)*(exp(2*t)*A^2+exp(2*t)*B^2-1)/
                         (exp(2*t)*A^2+exp(2*t)*B^2-2*exp(t)*A+1),
                  "y" = exp(t)*B/
                         (exp(2*t)*A^2+exp(2*t)*B^2-2*exp(t)*A+1),
                  "x_nullcline" = [[cosh(s)/2,sinh(s)/2],[-cosh(s)/2,sinh(s)/2]],
                  "y_nullcline" = [[s,0],[0,s]],
                  "conserved_quantity" = y/(x^2+y^2-1/4),
                  "lyapunov_function" = (x+1/2)^2+y^2,
                  "lyapunov_derivative" = 2*(x-1/2)*((x+1/2)^2+y^2),
                  "view"=[-R..R,-R..R],
                  "key" = "complex_square_offset",
		  "title" = "Offset complex square",
		  "x_scale" = 100,
		  "y_scale" = 100):

ODE["make_plots"] := proc(ODE)
 local P,i,j;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ 0,i*R,-10..10],i=-1..1,0.1),
  seq([i*R, i*R,-10..10],i=0.6..1,0.1),
  seq([i*R,-i*R,-10..10],i=0.6..1,0.1),
  seq([  R, i*R,-10..0],i=-0.55..0.55,0.1),
  seq([ -R, i*R, 0..10],i=-0.55..0.55,0.1)
 ]):

 for i from 2 to 20 by 2 do add_arrow_by_index(ODE,i,0); od:

 ODE["x_nullcline_plot"] :=
  display(
   plot([ sqrt(y^2+1/4),y,y=-R..R],colour=cyan,view=ODE["view"]),
   plot([-sqrt(y^2+1/4),y,y=-R..R],colour=cyan,view=ODE["view"])
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([-R,0],[R,0],colour=green),
   line([0,-R],[0,R],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 ODE["contour_plot"] := 
  display(seq(circle([-1/2,0],i,colour=blue),i=0.2..2,0.2)):

 ODE["lyapunov_plot"] := display(
  all_flow_lines_plot(ODE),
  ODE["contour_plot"],
  view=[-2..1/2,-1.25..1.25]
 ):

 save_pdf(ODE["lyapunov_plot"],"complex_square_offset_ly"):
end:

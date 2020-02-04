read("phase.mpl"):

R := 1.0;
ODE := create_ode(9*y^2-1,9*x^2-1,
                  "conserved_quantity" = 3*x^3-3*y^3-x+y,
                  "view"=[-R..R,-R..R],
                  "key"="double_wheel",
		  "title" = "Double wheel",
		  "x_scale" = 200,
		  "y_scale" = 200,
		  "t_scale" = 0.5
):

ODE["make_plots"] := proc(ODE)
 local P,P_grey,i,j,R,rr,tt,r0,r1;

 R := ODE["view_x_max"];
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([-i,i,-1..1],i=0.3775..0.92,0.04),
  seq([i,-i,-1..1],i=0.3775..0.92,0.04),
  [1/3+0.1,1/3,-2..2],[1/3-0.1,1/3,-2..2],[1/3,1/3+0.1,-2..2],[1/3,1/3-0.1,-2..2],[0,0,-1..1],
  [0.5775,-0.5775,-2..2],[-0.5775,0.5775,-2..2]
 ]):

 for i from 2 to 28 by 2 do add_arrow_by_index(ODE,i,0); od:

 ODE["x_nullcline_plot"] :=
  display(
   line([-R, 1/3],[R, 1/3],colour=cyan),
   line([-R,-1/3],[R,-1/3],colour=cyan)
  ):

 ODE["y_nullcline_plot"] :=
  display(
   line([ 1/3,-R],[ 1/3, R],colour=green),
   line([-1/3,-R],[-1/3, R],colour=green)
  ):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 P_grey := decolour_curves(all_flow_lines_plot(ODE)):

 rr := [0.1,0.2]: 
 tt := [0.3,0.18]:

 ODE["lin_a_plot"] := display(P_grey,
  seq(seq(op([
   plot([1/3+i*rr[j]*cosh(6*t),1/3+i*rr[j]*sinh(6*t),t=-tt[j]..tt[j]],colour=red),
   plot([1/3+i*rr[j]*sinh(6*t),1/3+i*rr[j]*cosh(6*t),t=-tt[j]..tt[j]],colour=red)
  ]),i=-1..1,2),j=1..2)
 ):

 save_pdf(ODE["lin_a_plot"],"double_wheel_lin_a"):
 r0 := 0.07;
 r1 := sqrt(2.)*0.04;

 ODE["lin_b_plot"] := display(P_grey,
  seq(plot([-1/3+(r0+i*r1)*cos(t),1/3+(r0+i*r1)*sin(t),t=0..2*Pi],colour=red),i=0..5)
 ):

 save_pdf(ODE["lin_b_plot"],"double_wheel_lin_b"):
end:


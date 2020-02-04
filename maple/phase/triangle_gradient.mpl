read("phase.mpl"):

ODE := create_ode(-(3*x^5+6*x^3*y^2+3*x*y^4-3*x^2+3*y^2),
                  -(3*x^4*y+6*x^2*y^3+3*y^5+6*x*y),
                  "view"=[-2..2,-2..2],
                  "key"="triangle_gradient",
		  "title"="Triangle gradient",
                  "lyapunov_function" = x^6+3*x^4*y^2+3*x^2*y^4+y^6-2*x^3+6*x*y^2+1,
                  "x_scale" = 100,
                  "y_scale" = 100,
                  "t_scale" = 0.2
):

ODE["make_plots"] := proc(ODE)
 local P,i,n,u,m;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq(evalf([ 1.5*cos(Pi*i/12),1.5*sin(Pi*i/12),-5..5]),i=0..23),
  seq(evalf([ 0.5*cos(Pi*i/12),0.5*sin(Pi*i/12),-5..5]),i in [2,6,10,14,18,22])
 ]):

 n := nops(ODE["flow_line_points"]);

 for i from 1 to n do add_arrow_by_index(ODE,i,0.0); od:

 u := signum(1-m^2)*(abs(1-m^2)/(1+m^2)^2)^(1/3);
 ODE["x_nullcline_plot"] := 
  plot([u,m*u,m=-8.4..8.4],color=cyan);

 ODE["y_nullcline_plot"] := 
  display(
   plot([-m^4,m*sqrt(sqrt(2)-m^6),m=-2^(1/12)..2^(1/2)],color=green),
   line([-2,0],[2,0],color=green)
  );

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:


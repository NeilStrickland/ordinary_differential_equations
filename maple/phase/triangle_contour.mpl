read("phase.mpl"):

R := 1.8:

ODE := create_ode(3*x^4*y+6*x^2*y^3+3*y^5+6*x*y,
                  -3*x^5-6*x^3*y^2-3*x*y^4+3*x^2-3*y^2,
                  "conserved_quantity" = x^6+3*x^4*y^2+3*x^2*y^4+y^6-2*x^3+6*x*y^2+1,
                  "view"=[-R..R,-R..R],
                  "key"="triangle_contour",
		  "title"="Triangle contour",
                  "x_scale" = 100,
                  "y_scale" = 100,
                  "t_scale" = 0.2
):

ODE["make_plots"] := proc(ODE)
 local P,i,pi0,r0,z0,n,u,m;
 
 classify_equilibria(ODE);

 pi0 := evalf(Pi - 10.^(-5)):
 for r0 from 1.0599 to 1.85 by 0.05 do
  z0 := (1 + (r0^3-1)*exp(I*t))^(1/3);
  add_flow_line(ODE,Re(z0),Im(z0),-pi0..pi0);
  z0 := exp(2*Pi*I/3.) * z0;
  add_flow_line(ODE,Re(z0),Im(z0),-pi0..pi0);
  z0 := exp(2*Pi*I/3.) * z0;
  add_flow_line(ODE,Re(z0),Im(z0),-pi0..pi0);
 od:

 for i in [4,5,6,7,8,9,10,11,12,16,19,22] do
  add_arrow_by_index(ODE,i,3.14):
 od:

 ODE["x_nullcline_plot"] := 
  display(
   plot([-m^4,m*sqrt(sqrt(2)-m^6),m=-2^(1/12)..2^(1/2)],color=cyan),
   line([-2,0],[2,0],color=cyan)
  );

 u := signum(1-m^2)*(abs(1-m^2)/(1+m^2)^2)^(1/3);
 ODE["y_nullcline_plot"] := 
  plot([u,m*u,m=-8.4..8.4],color=green);

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:


read("phase.mpl"):

ODE := create_ode(
 y,2*x-x^3-0.1*y,
 "lyapunov_function" = 2*y^2+(x^2-2)^2,
 "view"=[-3..3,-3..3],
 "key"="damped_duffing"
):

find_flow_lines(
 ODE,
 [seq([0,y0,0..30],y0=1.25..2,0.25)]
):

ODE["x_nullcline_plot"] := 
 display(line([-2.9,0],[2.9,0],colour=cyan)):

ODE["y_nullcline_plot"] := 
 display(
  seq(plot([Re(s),y,y=-2.9..2.9],colour=green),s in solve(2*x-x^3-0.1*y,x))
 ):

ODE["arrows"] := table():
add_arrow_by_index(ODE,1, 3.60);
add_arrow_by_index(ODE,2, 3.18);
add_arrow_by_index(ODE,3, 2.85);
add_arrow_by_index(ODE,4, 2.64);
add_arrow_by_index(ODE,1, 7.70);
add_arrow_by_index(ODE,2, 7.50);
add_arrow_by_index(ODE,3, 6.40);
add_arrow_by_index(ODE,3,10.50);
add_arrow_by_index(ODE,4, 5.75);
add_arrow_by_index(ODE,4,10.00);

P := display(
 white_outline(ODE),
 all_flow_lines_plot(ODE)
):

save_pdf(P,"damped_duffing");

P1 := display(P,ODE["x_nullcline_plot"]):
save_pdf(P1,"damped_duffing_xn");

P2 := display(P1,ODE["y_nullcline_plot"]):
save_pdf(P2,"damped_duffing_xnyn");

P3 := display(P2,seq(blob([i*sqrt(2),0],0.02),i=-1..1)):
save_pdf(P3,"damped_duffing_xnynep");

P_grey := decolour_curves(all_flow_lines_plot(ODE)):

alpha0 := 0.5;

damped_duffing_lin_a := display(P_grey,
 plot([sqrt(2)+alpha0*exp(-0.05*t)*(cos(2*t)+0.025*sin(2*t)),
       exp(-0.05*t)*(-2*alpha0*sin(2*t)),t=0..6*Pi],
      colour=red)
):

save_pdf(damped_duffing_lin_a,"damped_duffing_lin_a"):

r0 := sqrt(3*cos(t)^2+sqrt(cos(t)^4*v+9*cos(t)^4-6*cos(t)^2+1)-1)/cos(t)^2:

damped_duffing_ly := 
 display(
  all_flow_lines_plot(ODE),
  seq(plot([r0*cos(t),r0*sin(t),t=-1.57..1.57],colour=blue),v=0..8),
  seq(plot([sqrt(2+cos(t)*j/4),sin(t)*j/4/sqrt(2),t=0..2*Pi],colour=blue),j=0..7),
  scaling=constrained,axes=none,
  view=[0..4,-2..2]
 ):

save_pdf(damped_duffing_ly,"damped_duffing_ly");

combine(ode_step_formula(ODE));

save_lines(ODE);

ODE["flow_line_points"];

V := unapply(ODE["lyapunov_function"],x,y);
L := eval(ODE["flow_lines"][0,1.75]):
xt := (t) -> L["x"](t+10);
yt := (t) -> L["y"](t+10);
Vt := (t) -> V(xt(t),yt(t));
F := map(t0 -> fsolve(yt(t) = 0,t=t0),[2.6,4.4,6.3,8.0,9.8]);

damped_duffing_stability_a := display(
 plot(xt(t),t=0..10,colour=red),
 plot(yt(t),t=0..10,colour=blue),
 plot(Vt(t),t=0..10,colour=green),
 seq(line([t,0],[t,Vt(t)],linestyle="dot"),t in F),
 seq(line([t-0.3,Vt(t)],[t+0.3,Vt(t)]),t in F)
):

save_pdf(damped_duffing_stability_a,"damped_duffing_stability_a");

damped_duffing_stability_b := display(
 plot(xt(t),t=0..50,colour=red),
 plot(yt(t),t=0..50,colour=blue),
 plot(Vt(t),t=0..50,colour=green)
):

save_pdf(damped_duffing_stability_b,"damped_duffing_stability_b",800,400);


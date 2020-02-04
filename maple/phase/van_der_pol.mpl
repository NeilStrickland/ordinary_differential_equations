read("phase.mpl"):

mu := 2;

ODE := create_ode(y,mu*(1-x^2)*y - x,
                  "view" = [-6..6,-6..6],
                  "key" = "van_der_pol"):

find_flow_lines(
 ODE,
 [seq([i, 6,0..20],i=-6..-2.8,0.4),
  seq([i, 6,0..20],i= 2.. 5.6,0.4),
  seq([i,-6,0..20],i=-5.6..-2,0.4),
  seq([i,-6,0..20],i= 2.8..6,0.4),
  seq([i,-2*i,-5..5],i=-0.6..0.6,0.1),
  seq([(-sqrt(1+16*y^2)-1)/4/y,y,-1..2],y=1..5,1),
  seq([(-sqrt(1+16*y^2)-1)/4/y,y,-1..2],y=-5..-1,1),
  NULL
 ]
):

ODE["x_nullcline_plot"] :=
 display(line([-6,0],[6,0],colour=cyan)):

ODE["y_nullcline_plot"] := display(
 plot([( sqrt(1+16*y^2)-1)/4/y,y,y=-6..6],view=ODE["view"],colour=green),
 plot([(-sqrt(1+16*y^2)-1)/4/y,y,y=-6..-0.0857],view=ODE["view"],colour=green),
 plot([(-sqrt(1+16*y^2)-1)/4/y,y,y=0.0857..6],view=ODE["view"],colour=green)
):

ODE["arrows"] := table();

add_arrow_by_index(ODE, 2,0.010);
add_arrow_by_index(ODE, 5,0.016);
add_arrow_by_index(ODE, 8,0.032);
add_arrow_by_index(ODE,12,0.036);
add_arrow_by_index(ODE,15,0.018);
add_arrow_by_index(ODE,18,0.011);
add_arrow_by_index(ODE,21,0.010);
add_arrow_by_index(ODE,24,0.016);
add_arrow_by_index(ODE,27,0.032);
add_arrow_by_index(ODE,31,0.029);
add_arrow_by_index(ODE,34,0.015);
add_arrow_by_index(ODE,37,0.009);
add_arrow_by_index(ODE,41,0.100);
add_arrow_by_index(ODE,44,1.700);
add_arrow_by_index(ODE,48,0.100);

P := all_flow_lines_plot(ODE):
save_pdf(P,"van_der_pol");

xt := sin(t)+cos(t)/sqrt(3);
yt := sin(t)-cos(t)/sqrt(3);
V := x^2-x*y+y^2;

simplify(subs({x=xt,y=yt},V));
expand(ODE["g"]);
V_dot := expand(diff(V,x) * ODE["f"] + diff(V,y) * ODE["g"]);
GT := 3-4*x^2;
RT := ((3-4*x^2)*y+(x^3-x));
BT := 3-(1+x^2)^2;
factor(expand((RT^2+x^2*BT)/GT - V_dot));

x0 := evalf(sqrt(sqrt(3)-1));
r0 := 0.75;

van_der_pol_ly := display(
 fade_curves(P),
 line([-x0,-6],[-x0,6],colour="Purple"),
 line([ x0,-6],[ x0,6],colour="Purple"),
 seq(plot([xt*(r0-i),yt*(r0-i),t=0..2*Pi],colour=blue),i=0..0.7,0.2),
 seq(plot((x+sqrt(4*(r0+i)^2-3*x^2))/2,x=-x0..x0,colour=blue),i=0.2..1.2,0.2),
 seq(plot((x-sqrt(4*(r0+i)^2-3*x^2))/2,x=-x0..x0,colour=blue),i=0.2..1.2,0.2),
 view=[-2..2,-2..2]
):

save_pdf(van_der_pol_ly,"van_der_pol_ly"):

x0 := -2.01989175748697;
find_flow_line(ODE,[x0,0],0..10):
L := eval(ODE["flow_lines"][x0,0]):

ODE["limit_cycle_x"] := L["x"]:
ODE["limit_cycle_y"] := L["y"]:
ODE["limit_cycle_period"] := fsolve(L["y"](t)=0,t=7.629875428):

ODE["limit_cycle_plot"] :=
plot([ODE["limit_cycle_x"](t),
      ODE["limit_cycle_y"](t),
      t = 0 .. ODE["limit_cycle_period"]],
      thickness=4,colour=blue,scaling=constrained,axes=none):

P1 := display(P,ODE["x_nullcline_plot"]):
save_pdf(P1,"van_der_pol_xn");

P2 := display(P1,ODE["y_nullcline_plot"]):
save_pdf(P2,"van_der_pol_xnyn");

P3 := display(P2,blob([0,0],0.02),ODE["limit_cycle_plot"]):
save_pdf(P3,"van_der_pol_xnynep");

ode_step_formula(ODE);

save_lines(ODE);

lc := (V0,t) -> sqrt(V0) *~ [cos(t) + sin(t)/sqrt(3),cos(t) - sin(t)/sqrt(3)];

ODE["contours"] := display(
 seq(plot([op(lc(i,t)),t=0..2*Pi],colour=blue),i=0.0 .. 20.0,0.5),
 view=[-3..3,-3..3]
):

fn := cat(web_dir,"/lyapunov/",ODE["key"],"_lines.json"):
fd := fopen(fn,WRITE):
fprintf(fd,"{"):
fprintf(fd,cat("\"flow\":",curves_to_json(all_flow_lines_plot(ODE)))):
fprintf(fd,cat(",\"contour\":",curves_to_json(ODE["contours"]))):
fprintf(fd,"}"):
fclose(fd):



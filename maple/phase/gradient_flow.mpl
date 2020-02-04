read("phase.mpl"):

key := "gradient_flow";

ODE := create_ode(x-x^3,y-y^3,
                  "x" = (1+(1/x1^2-1)*exp(-2*t))^(-1/2),
                  "y" = (1+(1/y1^2-1)*exp(-2*t))^(-1/2),
                  "lyapunov_function" = (x^2-1)^2+(y^2-1)^2,
                  "view"=[-3..3,-3..3]):

II := {seq(i,i=0..47)} minus {0,12,24,36}:
JJ := select(i -> i < 24, II):

find_flow_lines(
 ODE,
 [seq(evalf([3*cos(i*Pi/24),3*sin(i*Pi/24),0..5]),i in II),
  seq(evalf([cos(i*Pi/12)/2,sin(i*Pi/12)/2,-5..5]),i in JJ)]
):

ODE["x_nullcline_plot"] := display(
 line([-1,-sqrt(8)],[-1,sqrt(8)],colour=cyan),
 line([ 1,-sqrt(8)],[ 1,sqrt(8)],colour=cyan),
 line([ 0,-3],[0,3],colour=cyan)
):

ODE["y_nullcline_plot"] := display(
 line([-sqrt(8),-1],[sqrt(8),-1],colour=green),
 line([-sqrt(8), 1],[sqrt(8), 1],colour=green),
 line([-3,0],[3,0],colour=green)
):

ODE["arrows"] := table():

for i in {1,6,11,12,17,22,23,28,33,34,39,44} do
 add_arrow_by_index(ODE,i,0.1);
od;
for i in {45,49,51,55,56,60,62,66} do
 add_arrow_by_index(ODE,i,1.1);
od;

P := display(
 all_flow_lines_plot(ODE),
 line([-3,0],[3,0],colour=red),
 line([0,-3],[0,3],colour=red),
# ODE["x_nullcline_plot"],
# ODE["y_nullcline_plot"],
 NULL
):

gradient_flow_ly0 := display(P,
 seq(plot([r*cos(t),r*sin(t),t=0..2*Pi],colour=blue),r=0.1..0.9,0.1),
 view=[-1..1,-1..1]
):

save_pdf(gradient_flow_ly0,"gradient_flow_ly0"):


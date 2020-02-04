read("phase.mpl"):

key := "lotka_volterra";

unprotect('gamma');

alpha := 10^(-2):
beta  := 10^(-4):
gamma := 10^(-1):
delta := 10^(-5):
x_factor := 40;
t_factor := 30;
x_max := 17000:
y_max := 400:

ODE := create_ode((alpha*x-beta*x*y)*t_factor,
                  (-gamma*y+delta*x*x_factor*y)*t_factor,
                  "view"=[0..x_max/x_factor,0..y_max]):

assign(convert(key,name),eval(ODE)):

classify_equilibria(ODE);

find_flow_lines(ODE,[
 seq([gamma/delta/x_factor,i],i=10..90,10)
]):

for i from 1 to 9 do
 add_arrow_by_index(ODE,i,4);
od:

ODE["x_nullcline_plot"] :=
 display(
  line([0,0],[0,y_max],colour=cyan),
  line([0,alpha/beta],[x_max/x_factor,alpha/beta],colour=cyan)
):

ODE["y_nullcline_plot"] :=
 display(
  line([0,0],[x_max/x_factor,0],colour=green),
  line([gamma/delta/x_factor,0],[gamma/delta/x_factor,y_max],colour=green)
 ):

P := full_plot(ODE):



read("phase.mpl"):

key := "pendulum";

ODE := create_ode(y,-sin(x),
 "conserved_quantity" = y^2/2 - cos(x),
 "view"=[-3*evalf(Pi)..3*evalf(Pi),-4..4]
):

assign(convert(key,name),eval(ODE)):

#classify_equilibria(ODE);

for i from 0 to 1 do
 for omega from 2.3 to 3.8 by 0.3 do
  add_flow_line(ODE,t,(-1)^i*sqrt(omega^2-2+2*cos(t)),-3*Pi..3*Pi);
 od:
od:

for i from -1 to 1 do
 for omega from 0.2 to 1.7 by 0.3 do
  add_flow_line(ODE,2*Pi*i+2*arcsin(omega*sin(t)/2),omega*cos(t),0..2*Pi)
 od:
od:

for i from -1 to 1 do 
 add_flow_line(ODE,2*Pi*i+2*arcsin(sin(t)),2*cos(t),0..2*Pi):
od:

for i from 2 to 30 by 2 do
 add_arrow_by_index(ODE,i,0);
od:

ODE["x_nullcline_plot"] :=
 display(line([-3*Pi,0],[3*Pi,0],colour=cyan)):

ODE["y_nullcline_plot"] :=
 display(
  seq(line([Pi*i,-4],[Pi*i,4],colour=green),i=-3..3)
):

P := full_plot(ODE):

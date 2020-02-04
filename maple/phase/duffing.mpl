read("phase.mpl"):

key := "duffing";

ODE := create_ode(y,2*x-x^3,
                      "conserved_quantity"=2*y^2+x^4-4*x^2,
                      "view"=[-3..3,-3..3]
                      ):

assign(convert(key,name),eval(ODE)):

#find_flow_lines(
# ODE,
# [seq([i,0,-20..20],i=-2..2,0.2)]
#);

for v from 0 to 8 do
 r0 := sqrt(3*cos(t)^2+sqrt(cos(t)^4*v+9*cos(t)^4-6*cos(t)^2+1)-1)/cos(t)^2:
 add_flow_line(ODE,r0*cos(t),r0*sin(t),0..2*Pi)
od:

unassign('v');

for i from 0 to 1 do
 for j from 0 to 7 do
  v := 4 * (-1 + j^2/64);
  add_flow_line(ODE,(-1)^i*sqrt(2+cos(t)*sqrt(4+v)),sin(t)*sqrt((4+v)/2),0..2*Pi);
 od:
od:

unassign('i','j','v');
ODE["arrows"] := table():
for i from 2 to 8 by 2 do
 add_arrow_by_index(ODE,i, 1.55);
 add_arrow_by_index(ODE,i,-1.55);
od:
add_arrow_by_index(ODE,1, 0.94);
add_arrow_by_index(ODE,1, 4.08);
add_arrow_by_index(ODE,1,-0.94);
add_arrow_by_index(ODE,1,-4.087);
add_arrow_by_index(ODE,14,Pi);
add_arrow_by_index(ODE,16,Pi);
add_arrow_by_index(ODE,22,Pi);
add_arrow_by_index(ODE,24,Pi);
P := display(white_outline(ODE),all_flow_lines_plot(ODE)):

ODE["x_nullcline_plot"] := 
 display(line([-3,0],[3,0],colour=cyan)):

ODE["y_nullcline_plot"] := 
 display(
  line([0,-3],[0,3],colour=green),
  line([-sqrt(2),-3],[-sqrt(2),3],colour=green),
  line([ sqrt(2),-3],[ sqrt(2),3],colour=green)
 ):

P1 := display(P,ODE["x_nullcline_plot"]):
save_pdf(P1,"duffing_xn");

P2 := display(P1,ODE["y_nullcline_plot"]):
save_pdf(P2,"duffing_xnyn");

P3 := display(P2,seq(blob([i*sqrt(2),0],0.02),i=-1..1)):
save_pdf(P3,"duffing_xnynep");

save_lines(ODE,cat(web_dir,"/phase/",key,"_lines.json"));



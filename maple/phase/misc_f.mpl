read("phase.mpl"):

ODE := create_ode(y,
                  -x-y-x^2,
		  "view"=[-1..1,-1..1],
		  "key" = "misc_f"):

ODE["make_plots"] := proc(ODE)
 local P,i;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ i, 1, 0..8],i=-0.95..0.95,0.1),
  seq([-1, i, 0..8],i= 0.05..0.95,0.1),
  seq([ i,-1,-2..8],i=-0.95..0.45,0.1),
  NULL
 ]):

 for i in {1,3,5,7,9,10,11,13,15,17,19,36,38,40,42,44} do
  add_arrow_by_index(ODE,i,0.4);
 od:

 #for i in {25,28,32,35} do add_arrow_by_index(ODE,i,-0.2); od:
 #for i from 33 to 50 by 3 do add_arrow_by_index(ODE,i,-0.5); od:

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


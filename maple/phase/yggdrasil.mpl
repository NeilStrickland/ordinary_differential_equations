read("phase.mpl"):

ODE := create_ode(x,x^2+y^2,
                  "view"=[-1..1,-1..1],
                  "key" = "yggdrasil",
		  "title" = "Yggdrasil"):

ODE["make_plots"] := proc(ODE)
 local P,i;

 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([i,1,-5..0],i=-0.9..0.9,0.2),
  seq([-1,i,-5..0],i=-0.95..0.95,0.1),
  seq([ 1,i,-5..0],i=-0.95..0.95,0.1),
  NULL
 ]):

 for i in {1,3,8,10} do add_arrow_by_index(ODE,i,-0.5); od:
 for i from 12 to 30 by 3 do add_arrow_by_index(ODE,i,-0.5); od:
 for i from 33 to 50 by 3 do add_arrow_by_index(ODE,i,-0.5); od:

 ODE["x_nullcline_plot"] :=
  display(line([0,-1],[0,1],colour=cyan)):
 P := full_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(all_flow_lines_plot(ODE),cat(ODE["key"],"_0"));

end:

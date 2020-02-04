read("phase.mpl"):

ODE := create_ode(x^2-y^2,2*x*y,
                  "x" = (x0 - t * (x0^2+y0^2))/((1-t*x0)^2 + t^2*y0^2),
                  "y" = y0/((1-t*x0)^2 + t^2*y0^2),
                  "conserved_quantity" = y/(x^2+y^2),
                  "view"=[-1..1,-1..1],
                  "key"="complex_square",
		  "title"="Complex square"
):

ODE["make_plots"] := proc(ODE)
 local P,i;
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ 0,i,-10..10],i=-1..1,0.1),
  seq([0.7*cos(i*Pi/24),0.7*sin(i*Pi/24),-10..10],i=-5..5)
 ]):

 for i from 1 to 4 do add_arrow_by_index(ODE,2*i,0.3); od:
 for i from 1 to 4 do add_arrow_by_index(ODE,2*i+12,-0.3); od:
 for i from 21 to 31 by 2 do add_arrow_by_index(ODE,i,-0.3); od:

 ODE["x_nullcline_plot"] :=
  display(line([-1,-1],[1,1],colour=cyan),line([-1,1],[1,-1],colour=cyan)):

 ODE["y_nullcline_plot"] :=
  display(line([-1,0],[1,0],colour=green),line([0,1],[0,-1],colour=green)):

 P := full_plot(ODE):
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

 save_pdf(all_flow_lines_plot(ODE),cat(ODE["key"],"_0"));
end:


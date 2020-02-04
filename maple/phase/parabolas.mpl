read("phase.mpl"):

key := "parabolas";
R := 4.0;
S := 8.0;
ODE := create_ode(5*y+12-12*x^2,
                  2*y-12+12*x^2,
                  "view"=[-R..R,-S..S],
		  "key"="parabolas",
		  "title"="Parabolas",
		  "x_scale"=50,
		  "y_scale"=25,
		  "t_scale"=0.1
		  ):

ODE["make_plots"] := proc(ODE)
 local P,i,R,S;

 R := ODE["view_x_max"];
 S := ODE["view_y_max"];
 
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([-R,i,-2..0],i=-3.5..S,0.5),
  seq([ R,i, 0..2],i=-9..S,0.5),
  seq([ 0,i,-2..2],i=-0.5..S,0.5),
  seq([ i,S,-2..2],i=-4..-1,0.5)
 ]);

 for i from 1 to 11 do
  add_arrow_by_index(ODE,2*i,-0.02);
 od:
 for i from 15 to 26 do
  add_arrow_by_index(ODE,2*i, 0.02);
 od:
 for i from 30 to 40 do
  add_arrow_by_index(ODE,2*i, 0.0);
 od:
 
 ODE["x_nullcline_plot"] :=
  display(
   plot(12/5*(x^2-1),x=-R..R,colour=cyan,view=[-R..R,-S..S])
  ):
  
 ODE["y_nullcline_plot"] :=
  display(
   plot(-6*(x^2-1),x=-R..R,colour=green,view=[-R..R,-S..S])
  ):
  
 P := full_plot(ODE);
 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);

end:


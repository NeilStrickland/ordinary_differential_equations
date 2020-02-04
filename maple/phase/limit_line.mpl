read("phase.mpl"):

R := 6.0;

ODE := create_ode(-x+(x^2-y^2)/4,
                   y-(x^2-y^2)/4,
                  "view"=[-R..R,-R..R],
                  "key"="limit_line",
		  "title"="Limit line",
		  "x_scale" = 40,
		  "y_scale" = 40,
		  "t_scale" = 0.5		  
):

ODE["make_plots"] := proc(ODE)
 local P,P0,P1,i,j,R;

 R := ODE["view_x_max"];
 classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq([ i*R, i*R,-3..3],i=0.11..1,0.1),
  seq([-i*R,-i*R,-3..3],i=0.11..1,0.1),
  [ 0.01*R, 0.01*R,-10..10],
  [-0.01*R,-0.01*R,-10..10],
  seq([-i,i,-3..3],i=0.5..5.5,0.5),
  seq([i,-i,-3..3],i=0.05..6,0.5)
 ]):

 ODE["x_nullcline_plot"] :=
  display(
   plot([2+sqrt(y^2+4),y,y=-R..R],colour=cyan,view=ODE["view"]),
   plot([2-sqrt(y^2+4),y,y=-R..R],colour=cyan,view=ODE["view"])
 ):

 ODE["y_nullcline_plot"] :=
  display(
   plot([x,-2+sqrt(x^2+4),x=-R..R],colour=green,view=ODE["view"]),
   plot([x,-2-sqrt(x^2+4),x=-R..R],colour=green,view=ODE["view"])
  ):

 P := full_plot(ODE):

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
 
 P0 := all_flow_lines_plot(ODE):

 save_pdf(P0,cat(ODE["key"],"_0"));

 for i from  2 to  8 by 2 do add_arrow_by_index(ODE,i,0); od:
 for i from 11 to 17 by 2 do add_arrow_by_index(ODE,i,0); od:
 for i from 24 to 30 by 2 do add_arrow_by_index(ODE,i,0); od:
 for i from 34 to 42 by 2 do add_arrow_by_index(ODE,i,0); od:

 P1 := display(
   all_flow_lines_plot(ODE),
   line([-4,-6],[6,4],colour=blue,thickness=4)
  ):

 save_pdf(P1,cat(ODE["key"],"_1"));

 check_solution(ODE,1-t,-1-t);

end:

read("phase.mpl"):

R := 2.0;
ODE := create_ode(sin(Pi*y),sin(Pi*x),
                  "conserved_quantity" = cos(Pi*x) - cos(Pi*y),
                  "view"=[-R..R,-R..R],
                  "key"="doubly_periodic",
		  "title" = "Doubly periodic",
		  "x_scale" = 100,
		  "y_scale" = 100,
		  "t_scale" = 1
):

ODE["make_plots"] := proc(ODE)
 local P,i,j,R,extra_lines;

 R := ODE["view_x_max"];
 #classify_equilibria(ODE);

 find_flow_lines(ODE,[
  seq(seq(seq([-2+i+2*j,1+i-2*k,0..5],i=0.05..0.95,0.05),j=0..2),k=0..2)
 ]):

 for i from 1 to 9 do
  add_arrow_by_index(ODE,19*i- 5,0);
  add_arrow_by_index(ODE,19*i-14,0);
 od:

 ODE["x_nullcline_plot"] :=
  display(seq(line([-R,i],[R,i],colour=cyan),i=-2..2)):

 ODE["y_nullcline_plot"] :=
  display(seq(line([i,-R],[i, R],colour=green),i=-2..2)):

 full_plot(ODE):

 extra_lines := 
  display(
   line([-2, 0],[ 0,-2],colour=red),
   line([-2, 2],[ 2,-2],colour=red),
   line([ 0, 2],[ 2, 0],colour=red),
   line([-2, 0],[ 0, 2],colour=red),
   line([-2,-2],[ 2, 2],colour=red),
   line([ 0,-2],[ 2, 0],colour=red)  
  ):

 ODE["flow_plot"] := display(ODE["flow_plot"],extra_lines):
 ODE["full_plot"] := display(ODE["full_plot"],extra_lines):
 P := ODE["full_plot"]:

 save_pdf(P,ODE["key"]);
 save_png(P,ODE["key"],thumbs_dir);
 save_lines(ODE);
end:

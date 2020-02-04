read("phase.mpl"):

conj_line := proc(s,xy,col := red,m := 5,v := 1)
 plot([exp(-t)*xy[1]+sinh(t)*xy[2]+s*(exp(t)*xy[2])^2,exp(t)*xy[2],t=-m..m],
      colour=col,view=[-v..v,-v..v],axes=none); 
end:

conj_plot := proc(s)
 local u;
 u := 0.7; 
 display(
  seq(conj_line(s,[ i, 0.6*i]),i=0.1..1.9,0.1),
  seq(conj_line(s,[-i,-0.6*i]),i=0.1..1.9,0.1),
  seq(conj_line(s,[-0.6*i, i]),i=0.1..1.9,0.1),
  seq(conj_line(s,[ 0.6*i,-i]),i=0.1..1.9,0.1),
  conj_line(s,[-1,0],magenta),
  conj_line(s,[ 1,0],magenta),
  conj_line(s,[-0.5,-1],blue),
  conj_line(s,[0.5,1],blue)
 );
end:

conj_plot_zoom := proc(s)
 local u,v,m;
 u := 0.7; 
 v := 0.1;
 m := 5;

 display(
  seq(conj_line(s,[ i, 0.6*i],red,m,v),i=0.01..0.19,0.01),
  seq(conj_line(s,[-i,-0.6*i],red,m,v),i=0.01..0.19,0.01),
  seq(conj_line(s,[-0.6*i, i],red,m,v),i=0.01..0.19,0.01),
  seq(conj_line(s,[ 0.6*i,-i]),i=0.01..0.19,0.01),
  conj_line(s,[-v,0],magenta,m,v),
  conj_line(s,[ v,0],magenta,m,v),
  conj_line(s,[-v/2,-v],blue,m,v),
  conj_line(s,[ v/2, v],blue,m,v),
  view = [-v..v,-v..v]
 );
end:

make_conj_plots := proc()
 global conjugacy_animation,P;
 local bg,i;

 conjugacy_animation[0] := conj_plot(0):

 save_pdf(conjugacy_animation[0],"conjugacy_animation_00"):

 bg := fade_curves(decolour_curves(conjugacy_animation[0])):

 for i from 0 to 10 do 
  conjugacy_animation[i] := display(bg,conj_plot(0.1*i));
  save_pdf(conjugacy_animation[i],sprintf("conjugacy_animation_%02d",i));
 od: 

 P := display(seq(conjugacy_animation[i],i=0..10),insequence=true):
end:

make_conj_plots_zoom := proc()
 global conjugacy_animation_zoom,P;
 local bg,i;

 conjugacy_animation_zoom[0] := conj_plot_zoom(0):

 save_pdf(conjugacy_animation_zoom[0],"conjugacy_animation_zoom_00"):

 bg := fade_curves(decolour_curves(conjugacy_animation_zoom[0])):

 for i from 0 to 10 do 
  conjugacy_animation_zoom[i] := display(bg,conj_plot_zoom(0.1*i));
  save_pdf(conjugacy_animation_zoom[i],sprintf("conjugacy_animation_zoom_%02d",i));
 od: 

 P := display(seq(conjugacy_animation_zoom[i],i=0..10),insequence=true):
end:

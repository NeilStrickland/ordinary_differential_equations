with(plots):
with(plottools):
image_dir := "C:/Users/Neil Strickland/Google Drive/Teach/MAS290/lectures/images/":
video_dir := "C:/Users/Neil Strickland/Google Drive/Teach/MAS290/lectures/video/":
drum_frame := display(
 plot3d([(1+0.6*(z-z^2))*cos(theta),(1+0.6*(z-z^2))*sin(theta),-1.5*z],theta=0..2*Pi,z=0.1..1,colour="Firebrick",style=patchnogrid),
 plot3d([(1+0.6*(z-z^2))*cos(theta),(1+0.6*(z-z^2))*sin(theta),-1.5*z],theta=0..2*Pi,z=0..0.1,colour="Wheat",style=patchnogrid),
 axes=none,scaling=constrained
):


make_bessel_movie := proc(nu,k)
 global bessel_movie,fn;

 bessel_movie[nu,k] := display(
  seq(
   display(drum_frame,
	   plot3d([r*cos(theta),r*sin(theta),
	   0.3*sin(2*Pi*t)*cos(nu*theta)*BesselJ(nu,BesselJZeros(nu,k)*r)],
	   r=0..1,theta=0..2*Pi,colour="Wheat",
	   axes=none,scaling=constrained)),
   t=0..1,0.01),
  insequence=true):

 bessel_movie[nu,k] :=
  display(bessel_movie[nu,k],orientation=[0,70],insequence=true);

 fn := cat(video_dir,sprintf("bessel_movie_%d_%d.gif",nu,k));

 plotsetup(gif,plotoutput=fn);
 print(bessel_movie[nu,k]);
 plotsetup(default);

 return bessel_movie[nu,k];
end:


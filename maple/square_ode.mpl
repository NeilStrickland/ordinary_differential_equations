# This code sets up autonomous planar first order ode's for which
# the associated vector field is an inhomogeneous quadratic in
# x and y, which vanishes at (1,1), (-1,1), (1,-1) and (-1,-1).

create_square_ode := proc(m,n,p,q)
 local f,g,ode;

 f := x^2*(m*p^2+2*m*p*q-m*q^2+n*p^2-2*n*p*q-n*q^2)+
      y^2*(-m*p^2+2*m*p*q-m*q^2+n*p^2-n*q^2)+
      (2*n*q^2-4*m*p*q+2*m*q^2-2*n*p^2+2*n*p*q);

 g := x^2*(m*p^2+2*m*p*q+m*q^2+n*p^2-n*q^2)+
      y^2*(-m*p^2+2*m*p*q+m*q^2+n*p^2+2*n*p*q-n*q^2)+
      (-4*m*p*q-2*m*q^2-2*n*p^2-2*n*p*q+2*n*q^2);

 ode := create_ode(f,g,args[5..-1]);

 if not(assigned(ode["view"])) or ode["view"] = NULL then
  ode["view"] := [-2..2,-2..2];
  ode["x_scale"] := 100;
  ode["y_scale"] := 100;
 fi;

 # Nullcline parameters
 ode["axx"] := evalf((2*(2*m*p*q-m*q^2+n*p^2-n*p*q-n*q^2))/(m*p^2+2*m*p*q-m*q^2+n*p^2-2*n*p*q-n*q^2));
 ode["axy"] := evalf(-(2*(2*m*p*q-m*q^2+n*p^2-n*p*q-n*q^2))/((p-q)*(m*p-m*q-n*p-n*q)));
 ode["ayx"] := evalf((2*(2*m*p*q+m*q^2+n*p^2+n*p*q-n*q^2))/((p+q)*(m*p+m*q+n*p-n*q)));
 ode["ayy"] := evalf(-(2*(2*m*p*q+m*q^2+n*p^2+n*p*q-n*q^2))/(m*p^2-2*m*p*q-m*q^2-n*p^2-2*n*p*q+n*q^2));

 ode["rxx"] := sqrt(abs(ode["axx"]));
 ode["rxy"] := sqrt(abs(ode["axy"]));
 ode["ryx"] := sqrt(abs(ode["ayx"]));
 ode["ryy"] := sqrt(abs(ode["ayy"]));

 if ode["axx"] >0 then
  if ode["axy"] >0 then
   ode["x_nullcline_plot"] :=
    plot([ode["rxx"]*cos(t),ode["rxy"]*sin(t),t=0..2*Pi],colour=cyan);
  else
   ode["x_nullcline_plot"] :=
    display(
     plot([ ode["rxx"]*cosh(t),ode["rxy"]*sinh(t),t=-5..5],colour=cyan),
     plot([-ode["rxx"]*cosh(t),ode["rxy"]*sinh(t),t=-5..5],colour=cyan),
     view=ode["view"]
    );   
  fi;
 else
   ode["x_nullcline_plot"] :=
    display(
     plot([ode["rxx"]*sinh(t), ode["rxy"]*cosh(t),t=-5..5],colour=cyan),
     plot([ode["rxx"]*sinh(t),-ode["rxy"]*cosh(t),t=-5..5],colour=cyan),
     view=ode["view"]
    );   
 fi;

 if ode["ayx"] >0 then
  if ode["ayy"] >0 then
   ode["y_nullcline_plot"] :=
    plot([ode["ryx"]*cos(t),ode["ryy"]*sin(t),t=0..2*Pi],colour=green);
  else
   ode["y_nullcline_plot"] :=
    display(
     plot([ ode["ryx"]*cosh(t),ode["ryy"]*sinh(t),t=-5..5],colour=green),
     plot([-ode["ryx"]*cosh(t),ode["ryy"]*sinh(t),t=-5..5],colour=green),
     view=ode["view"]
    );
  fi;
 else
   ode["y_nullcline_plot"] :=
    display(
     plot([ode["ryx"]*sinh(t), ode["ryy"]*cosh(t),t=-5..5],colour=green),
     plot([ode["ryx"]*sinh(t),-ode["ryy"]*cosh(t),t=-5..5],colour=green),
     view=ode["view"]
    );
 fi;

 return eval(ode);
end:

######################################################################

create_square_ode_trig := proc(alpha,beta)
 return create_square_ode(
  cos(beta-alpha),sin(beta-alpha),cos(alpha/2),sin(alpha/2)
 );
end:

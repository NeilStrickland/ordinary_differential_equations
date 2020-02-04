with(plots):
with(plottools):

pendulum_eqn := D(theta)(t) = omega(t),
                D(omega)(t) = -sin(theta(t)):

pendulum_period := (omega) ->
 `if`(abs(omega) < 2,
      Re(4*EllipticF(1,abs(omega)/2)),
      Re(4*EllipticK(2/abs(omega))/abs(omega))):

pendulum_lines := "":
comma := "":

pendulum_plot := display(
 seq(seq(plot((-1)^i*sqrt(omega^2-2+2*cos(t)),t=-3*Pi..3*Pi),omega=2.3..3.8,0.3),i=0..1),
 seq(seq(plot([2*Pi*i+2*arcsin(omega*sin(u)/2),omega*cos(u),u=0..2*Pi]),omega=0.35..1.85,0.3),i=-1..1),
 plot( 2*cos(t/2),t=-3*Pi..3*Pi,colour=blue),
 plot(-2*cos(t/2),t=-3*Pi..3*Pi,colour=blue),
 scaling=constrained,axes=none
):

add_line := proc(P)
 global pendulum_lines,comma;
 local L,p;

 L := convert(op(1,op(1,P)),listlist);
 L := map(p -> map(round,100 *~ p),L);
 pendulum_lines := cat(
  pendulum_lines,comma,
  sprintf("new paper.Path(%Q)",op(L))
 );

 comma := ",\n";
end:

for i from 0 to 1 do
 for omega from 2.3 to 3.8 by 0.3 do
  add_line(plot((-1)^i*sqrt(omega^2-2+2*cos(t)),t=-3*Pi..3*Pi));
 od:
od:

for i from -1 to 1 do
 for omega from 0.2 to 1.7 by 0.3 do
  add_line(plot([2*Pi*i+2*arcsin(omega*sin(u)/2),omega*cos(u),u=0..2*Pi]));
 od:
od:

add_line(plot( 2*cos(t/2),t=-3*Pi..3*Pi)):
add_line(plot(-2*cos(t/2),t=-3*Pi..3*Pi)):

fd := fopen("D:/wamp/www/pm1nps/courses/MAS290/pendulum/lines.js",WRITE):
fprintf(fd,"var pendulum_lines = [\n%s\n];",pendulum_lines):
fclose(fd):

pendulum_plot;

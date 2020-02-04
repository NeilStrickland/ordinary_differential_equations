with(plots):
with(plottools):

unprotect('gamma');

alpha := 10^(-2);
beta  := 10^(-4);
gamma := 10^(-1);
delta := 10^(-5);

lotka_volterra_eqn :=
 D(F)(t) = alpha*F(t) - beta*S(t)*F(t),
 D(S)(t) = -gamma*S(t) + delta*S(t)*F(t);

lotka_volterra_lines := "";
comma := "";

for S0 from 10 to 90 by 10 do
 sol := dsolve([lotka_volterra_eqn,F(0)=10000,S(0)=S0],numeric,output=listprocedure);
 FF := subs(sol,F(t));
 SS := subs(sol,S(t));
 t0 := fsolve(FF(t)=10000,t=10..infinity);
 t1 := fsolve(FF(t)=10000,t=t0+10..infinity);
 t1 := fsolve(FF(t)=10000,t=t1);
 PP := plot([FF(t),SS(t),t=0..t1],numpoints=200);
 lotka_volterra_plot[10000,S0] := PP;
 L := convert(op(1,op(1,PP)),listlist);
 L := map(p -> map(round,p),L);
 lotka_volterra_lines := cat(
  lotka_volterra_lines,comma,
  sprintf("new paper.Path(%Q)",op(L))
 );
 comma := ",\n";
od:

fd := fopen("D:/wamp/www/pm1nps/courses/MAS290/lotka_volterra/lines.js",WRITE);
fprintf(fd,"var lotka_volterra_lines = [\n%s\n];",lotka_volterra_lines);
fclose(fd);

lotka_volterra_plot_all := 
 display(
  seq(lotka_volterra_plot[op(ii)],ii in indices(lotka_volterra_plot))
 ); 



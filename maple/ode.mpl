with(plots):
with(plottools):
with(LinearAlgebra):

image_dir := "../lectures/images/";

protect('x','y','t','x0','y0');

######################################################################

create_ode := proc(f,g)
 local ode,a,err;
 global ode_table;

 ode["f"] := f;
 ode["g"] := g;
 ode["J"] := map(simplify,
  <<diff(f,x)|diff(f,y)>,<diff(g,x)|diff(g,y)>>);
 ode["tau"] := simplify(Trace(ode["J"]));
 ode["delta"] := simplify(expand(Determinant(ode["J"])));
 ode["Delta"] := simplify(expand(ode["tau"]^2 - 4*ode["delta"]));
 ode["x_equation"] := (D(x)(t) - subs({x=x(t),y=y(t)},f));
 ode["y_equation"] := (D(y)(t) - subs({x=x(t),y=y(t)},g));
 ode["flow_line_points"] := [];
 ode["arrows"] := table();
 ode["key"]  := NULL;
 ode["view"] := NULL;
 ode["x"]    := NULL;
 ode["y"]    := NULL;
 ode["conserved_quantity"] := NULL;
 ode["lyapunov_function"] := NULL;
 ode["lyapunov_derivative"] := NULL;
 ode["x_nullcline"] := NULL;
 ode["y_nullcline"] := NULL;
 ode["show_trace"]  := false;
 
 for a in args[3..-1] do
  if type(a,`=`) and
     member(lhs(a),["x","y",
                    "key",
                    "title",
                    "view",
                    "conserved_quantity",                    
                    "lyapunov_function",
                    "lyapunov_derivative",
                    "x_nullcline",
                    "y_nullcline",
		    "x_scale",
		    "y_scale",
		    "t_scale",
		    "canvas_width",
		    "canvas_height",
		    "show_trace"]) then
   ode[lhs(a)] := rhs(a);
  fi;
 od:

 if ode["view"] <> NULL then
  ode["view_x_min"] := op(1,op(1,ode["view"]));
  ode["view_x_max"] := op(2,op(1,ode["view"]));
  ode["view_y_min"] := op(1,op(2,ode["view"]));
  ode["view_y_max"] := op(2,op(2,ode["view"]));
 fi;

 if ode["conserved_quantity"] <> NULL then
  if check_conserved_quantity(ode) <> 0 then
   error "Conserved quantity is not conserved";
  fi;
 fi;

 if ode["x"] <> NULL and ode["y"] <> NULL then
  if has(ode["x"],x0) and has(ode["y"],y0) then
   if check_solution_ic(ode) <>  [0,0,0,0] then
    error "Given solution is invalid";
   fi;
  else 
   if check_solution(ode) <>  [0,0] then
    error "Given solution is invalid";
   fi;
  fi;
 fi;

 if ode["lyapunov_function"] <> NULL then
  if ode["lyapunov_derivative"] <> NULL then
   err := simplify(expand(
    ode["lyapunov_derivative"] - 
    time_derivative(ode,ode["lyapunov_function"])));
   if err <> 0 then
    error "lyapunov_derivative does not match lyapunov_function";
   fi;
  else
   ode["lyapunov_derivative"] := 
    time_derivative(ode,ode["lyapunov_function"]);
  fi;
 fi;

 if ode["x_nullcline"] <> NULL then
  if not(type(ode["x_nullcline"],list)) then
   ode["x_nullcline"] := [ode["x_nullcline"]];
  fi;

  if {op(check_x_nullcline(ode,ode["x_nullcline"])),0} <> {0} then
   error "Given x-nullcline parametrisation is invalid";
  fi;
 fi;

 if ode["y_nullcline"] <> NULL then
  if not(type(ode["y_nullcline"],list)) then
   ode["y_nullcline"] := [ode["y_nullcline"]];
  fi;

  if {op(check_y_nullcline(ode,ode["y_nullcline"])),0} <> {0} then
   error "Given y-nullcline parametrisation is invalid";
  fi;
 fi;

 if ode["key"] <> NULL then
  ode_table[ode["key"]] := eval(ode);
 fi:

 return eval(ode);
end:

######################################################################

time_derivative := proc(ode,U)
 simplify(expand(diff(U,x) * ode["f"] + diff(U,y) * ode["g"]));
end:

######################################################################

check_conserved_quantity := proc(ode,U_)
 local U,U_dot,err;

 if nargs > 1 then 
  U := U_;
 elif ode["conserved_quantity"] <> NULL then
  U := ode["conserved_quantity"];
 else 
  error "No conserved quantity to check";
 fi;

 U_dot := time_derivative(ode,U);

 return U_dot;
end:

######################################################################

check_solution := proc(ode,xt_,yt_)
 local xt,yt;

 if nargs >= 3 then
  xt := xt_;
  yt := yt_;
 elif ode["x"] <> NULL and ode["y"] <> NULL then
  xt := ode["x"];
  yt := ode["y"];
 else
  error "No solution to check";
 fi;

 simplify(expand(
  [diff(xt,t) - subs({x = xt,y = yt},ode["f"]),
   diff(yt,t) - subs({x = xt,y = yt},ode["g"])
  ]
 ));
end:

######################################################################

check_solution_ic := proc(ode,xt_,yt_)
 local xt,yt;

 if nargs >= 3 then
  xt := xt_;
  yt := yt_;
 elif ode["x"] <> NULL and ode["y"] <> NULL then
  xt := ode["x"];
  yt := ode["y"];
 else
  error "No solution to check";
 fi;

 simplify(expand(
  [diff(xt,t) - subs({x = xt,y = yt},ode["f"]),
   diff(yt,t) - subs({x = xt,y = yt},ode["g"]),
   subs(t = 0,xt) - x0,
   subs(t = 0,yt) - y0
  ]
 ));
end:

######################################################################

check_x_nullcline := proc(ode,L_)
 local L;

 if nargs > 1 then
  L := L_;
 elif ode["x_nullcline"] <> NULL then
  L := ode["x_nullcline"];
 else
  error "No x-nullcline parametrisation to check";
 fi;
  
 map(xy -> factor(simplify(expand(subs({x=xy[1],y=xy[2]},ode["f"])))),L);
end:

######################################################################

check_y_nullcline := proc(ode,L_)
 local L;

 if nargs > 1 then
  L := L_;
 elif ode["y_nullcline"] <> NULL then
  L := ode["y_nullcline"];
 else
  error "No y-nullcline parametrisation to check";
 fi;
  
 map(xy -> factor(simplify(expand(subs({x=xy[1],y=xy[2]},ode["g"])))),L);
end:

######################################################################

ode_step_formula := proc(ode)
 local a,b,c,d,x0,y0;

 a := subs({x=x0,y=y0},ode["f"]);
 c := subs({x=x0,y=y0},ode["g"]);
 b := expand((a * diff(a,x0) + c * diff(a,y0))/2);
 d := expand((a * diff(c,x0) + c * diff(c,y0))/2);

 return [a * dt + b * dt^2,c * dt + d * dt^2];
end:

######################################################################

line_types := table([
 "flow" = "red",
 "x_nullcline" = "cyan",
 "y_nullcline" = "green",
 "contour" = "blue",
 "first_eigenline" = "magenta",
 "second_eigenline" = "orange"
]);

######################################################################

find_flow_line := proc(ode,xy0,t_range_)
 local x0,y0,L,sol,tt,t1,extra_args;

 x0,y0 := op(xy0);

 if nargs > 3 then
  extra_args := args[4..-1];
 else
  extra_args := NULL;
 fi;

 L := table();
 L["x0"] := x0;
 L["y0"] := y0;
 sol := dsolve({ode["x_equation"],
                ode["y_equation"],
                x(0)=x0,y(0)=y0},
                type='numeric',output='listprocedure');
 L["x"] := rhs(sol[2]);
 L["y"] := rhs(sol[3]);

 L["t_range"] := 0..10;
 if nargs > 2 then
  tt := t_range_;
  if type(tt,`..`) then
  L["t_range"] := tt;
  elif type(tt,numeric) then
   t1 := fsolve(L["y"](t)=y0,t=tt);
   L["t_range"] := 0 .. t1;
  fi;
 fi;

 L["plot"] := 
   plot([L["x"](t),L["y"](t),t=L["t_range"]],
        colour=red,scaling=constrained,axes=none,view=ode["view"],
        extra_args);

 ode["flow_lines"][x0,y0] := eval(L);
 ode["flow_line_points"] := [op(ode["flow_line_points"]),xy0];
 return eval(L);
end:

######################################################################

add_flow_line := proc(ode,xt,yt,t_range)
 local L;

 L := table();
 L["x0"] := evalf(subs(t=0,xt));
 L["y0"] := evalf(subs(t=0,yt));
 L["x"] := unapply(xt,t);
 L["y"] := unapply(yt,t);
 L["t_range"] := t_range;

 L["plot"] := 
   plot([L["x"](t),L["y"](t),t=L["t_range"]],
        colour=red,scaling=constrained,axes=none,view=ode["view"]);

 ode["flow_lines"][L["x0"],L["y0"]] := eval(L);
 ode["flow_line_points"] := [op(ode["flow_line_points"]),[L["x0"],L["y0"]]];
end:

######################################################################

add_arrow := proc(ode,x0,y0,t1)
 local L,x1,y1,u,v,r,s,V,a;

 if assigned(ode["flow_lines"][x0,y0]) then
  L := eval(ode["flow_lines"][x0,y0]);
 else
  L := find_flow_line(ode,[x0,y0]);
 fi;
 x1 := L["x"](t1);
 y1 := L["y"](t1);
 u := evalf(subs({x=x1,y=y1},ode["f"]));
 v := evalf(subs({x=x1,y=y1},ode["g"]));
 r := sqrt(u^2+v^2);
 if r = 0. then return NULL; fi;
 u := u/r;
 v := v/r;
 V := ode["view"];
 s := max(op(2,op(1,V)) - op(1,op(1,V)),op(2,op(2,V)) - op(1,op(2,V))) * 0.02;
 u := s*u;
 v := s*v;
 a := curve([[x1-u-v/2,y1-v+u/2],[x1,y1],[x1-u+v/2,y1-v-u/2]],colour=red);
 ode["arrows"][x0,y0,t1] := a;
 NULL;
end:

######################################################################

add_arrow_by_index := proc(ode,i,t1_)
 local x0,y0,t1,xy0;

 t1 := `if`(nargs > 2, t1_, 0);

 xy0 := ode["flow_line_points"][i];
 x0,y0 := op(xy0);
 add_arrow(ode,x0,y0,t1);
end:

######################################################################

find_flow_lines := proc(ode,ics)
 local ic;

 for ic in ics do
  find_flow_line(ode,[ic[1],ic[2]],op(3..-1,ic));
 od:
 NULL;
end:

######################################################################

classify_equilibria := proc(ode)
 local sols,P,Q,PP,xy;

 _EnvExplicit := true;
 sols := map(s -> subs(s,[x,y]),evalf([solve({ode["f"],ode["g"]},{x,y})]));
 sols := select(u -> abs(Im(u[1])) < 10.^(-8) and
                     abs(Im(u[2])) < 10.^(-8),sols);

 sols := map(u -> map(Re,u),sols);

 PP := [];

 for xy in sols do
  P := table():
  P["x"] := xy[1];
  P["y"] := xy[2];
  P["J"] := Matrix(subs({x=xy[1],y=xy[2]},
                    [[diff(ode["f"],x),diff(ode["f"],y)],
                     [diff(ode["g"],x),diff(ode["g"],y)]]));
  Q := create_linear_ode(evalf(P["J"]));
  P["linearization"] := eval(Q);
  P["type"] := Q["type"];

  PP := [op(PP),eval(P)];
 od:

 ode["equilibria"] := PP;
 ode["equilibria_summary"] := map(P -> [P["x"],P["y"],P["type"]],PP);
end:

######################################################################

equilibria_table := proc(ode)
 Matrix(map(e -> [[e["x"],e["y"]],
                   op(e["linearization"]["info_row"])],
            ODE["equilibria"]));
end:

######################################################################

classify_quadratic := proc(Q)
 local a,b,c,Delta,t;
 a := coeff(expand(Q),x,2);
 b := coeff(coeff(expand(Q),x,1),y,1)/2;
 c := coeff(expand(Q),y,2);
 Delta := a*c - b^2;
 t := NULL;
 if Delta > 0 then
  if a > 0 then
   t := "positive definite";
  else
   t := "negative definite";
  fi;
 elif Delta = 0 then
  if a > 0 or c > 0 then
   t := "positive semidefinite";
  elif a < 0 or c < 0 then
   t := "negative semidefinite";
  else
   t := "zero";
  fi;
 else
  t := "strictly indefinite";
 fi;

 return [a,b,c,Delta,t];
end:

######################################################################

all_flow_lines_plot := proc(ode)
 local P;

 P := 
  display(seq(ode["flow_lines"][op(xy0)]["plot"],
              xy0 in indices(ode["flow_lines"])),
          seq(ode["arrows"][op(xyt0)],
              xyt0 in indices(ode["arrows"])),
          scaling=constrained,axes=none,view=ode["view"]);

 ode["flow_plot"] := P;

 return(P);
end:

######################################################################

make_lyapunov_spacecurve := proc(ode,line,scale_)
 local scale,xt,yt,V,Vt,light_red;

 scale := `if`(nargs > 2,scale_,1);
 light_red := ColorTools:-Color("RGB",[1,0.5,0.5]);

 xt := line["x"](t);
 yt := line["y"](t);
 V := unapply(ode["lyapunov_function"],x,y);
 Vt := V(xt,yt);
 line["lyapunov_spacecurve"] :=
  spacecurve([xt,yt,Vt/scale],t = line["t_range"],colour=light_red);
 line["plane_spacecurve"] :=
  spacecurve([xt,yt,0],t = line["t_range"],colour=red);

 return line["lyapunov_spacecurve"];
end:

######################################################################

make_lyapunov_spacecurves := proc(ode,scale_)
 local scale,xy0,line;

 scale := `if`(nargs > 1,scale_,1);
 for xy0 in indices(ode["flow_lines"]) do
  line := eval(ode["flow_lines"][op(xy0)]);
  make_lyapunov_spacecurve(ode,line,scale);
 od:

 ode["lyapunov_spacecurves"] := 
  display(seq(ode["flow_lines"][op(xy0)]["lyapunov_spacecurve"],
           xy0 in indices(ode["flow_lines"])));

 ode["plane_spacecurves"] := 
  display(seq(ode["flow_lines"][op(xy0)]["plane_spacecurve"],
           xy0 in indices(ode["flow_lines"])));

 return ode["lyapunov_spacecurves"];
end:
 
######################################################################

white_outline := proc(ode)
 local x0,x1,y0,y1;
 
 x0 := ode["view_x_min"];
 x1 := ode["view_x_max"];
 y0 := ode["view_y_min"];
 y1 := ode["view_y_max"];

 curve([[x0,y0],[x1,y0],[x1,y1],[x0,y1],[x0,y0]],colour=white);
end:

######################################################################
# This function generates a black point, drawn as a thick circular
# line.  This is necessary because Maple always draws lines in front
# of filled regions, so if we want a point visible in front of the
# flow lines etc then we need to draw it using lines instead of
# regions.

blob := proc(xy,r)
 display(plot([xy[1]+r*cos(t),xy[2]+r*sin(t),t=0..2*Pi],colour=black,thickness=4));
end:

######################################################################

fade_curve := proc(C,f_)
 local f,A;
 f := `if`(nargs > 1,f_,0.7);

 if type(C,function) and op(0,C) = CURVES and nops(C) = 2 then
  A := op(2,C);
  if type(A,function) and op(0,A) = COLOUR and nops(A) = 4 and op(1,A) = RGB then
   return CURVES(op(1,C),COLOUR(RGB,f+(1-f)*op(2,A),f+(1-f)*op(3,A),f+(1-f)*op(4,A)));
  else
   return C;
  fi;
 else
  return C;
 fi;
end:

fade_curves := proc(P,f_)
 local f;
 f := `if`(nargs > 1,f_,0.7);
 map(fade_curve,P,f);
end:

######################################################################

decolour_curve := proc(C)
 local A,g;
 if type(C,function) and op(0,C) = CURVES and nops(C) = 2 then
  A := op(2,C);
  if type(A,function) and op(0,A) = COLOUR and nops(A) = 4 and op(1,A) = RGB then
   g := (op(2,A) + op(3,A) + op(4,A))/3;
   return CURVES(op(1,C),COLOUR(RGB,g,g,g));
  else
   return C;
  fi;
 else
  return C;
 fi;
end:

decolour_curves := proc(P)
 map(decolour_curve,P);
end:

######################################################################

full_plot := proc(ode)
 local P,k;

 P := all_flow_lines_plot(ode);
 for k in ["x_nullcline_plot",
           "y_nullcline_plot"] do
  if assigned(ode[k]) then
   P := P,ode[k];
  fi;
 od;

 P := display(P);
 ode["full_plot"] := P;

 return P;
end:

######################################################################

condense_curve := proc(C,V::[`..`,`..`])
 local x_min,x_max,y_min,y_max,L,L0,n,LL,i,a;

 x_min := op(1,op(1,V));
 x_max := op(2,op(1,V));
 y_min := op(1,op(2,V));
 y_max := op(2,op(2,V));

 L := op(1,C);
 if type(L,Matrix) then
  L := convert(L,listlist);
 fi;
 L := evalf[3](L);
 n := nops(L);
 if n = 0 then return []; fi;
 L0 := L;
 L := [L[1]];
 for i from 2 to n do
  if L0[i] <> L[-1] then
   L := [op(L),L0[i]];
  fi;
 od;

 LL := NULL;
 L0 := [];
 for a in L do
  if x_min <= a[1] and a[1] <= x_max and
     y_min <= a[2] and a[2] <= y_max then
   L0 := [op(L0),a];
  else
   if L0 <> [] then LL := LL,L0; fi;
   L0 := [];
  fi;
 od;

 if L0 <> [] then LL := LL,L0; fi;

 return([LL]);
end;

######################################################################

curve_to_json := proc(C)
 local L,s,t,comma,xy;

 L := op(1,C);
 if type(L,Matrix) then
  L := convert(L,listlist);
 fi;

 s := "[";
 comma := "";
 for xy in L do
  t := sprintf("[%0.4f,%0.4f]",xy[1],xy[2]);
  if StringTools[Search]("#IND",t) = 0 and
     StringTools[Search]("#QNB",t) = 0 then
   s := cat(s,comma,t);
   comma := ",";
  fi;
 od;
 s := cat(s,"]");

 return(s);
end:

######################################################################

curves_to_json := proc(P)
 local s,comma,C;

 s := "[";
 comma := "";
 for C in [op(P)] do
  if type(C,function) and op(0,C) = CURVES then
   s := cat(s,comma,curve_to_json(C));
   comma := ",";
  fi;
 od:
 s := cat(s,"]");
 return s;
end:

######################################################################

curve_to_tikz := proc(C,V::[`..`,`..`])
 local L,LL,s;

 LL := condense_curve(C,V);

 s := "";

 for L in LL do
  s := 
  cat(s,"\\draw[smooth] ",
     substring(cat(op(map(xy -> sprintf(" -- (%.3f,%.3f)",op(xy)),
                 L))),4..-1),";\n"
  );
 od;

 return(s);
end:

######################################################################

curves_to_tikz := proc(P,V::[`..`,`..`])
 local s,C;

 s := "";
 for C in [op(P)] do
  if type(C,function) and op(0,C) = CURVES then
   s := cat(s,curve_to_tikz(C,V));
  fi;
 od:
 return s;
end:

######################################################################

save_lines := proc(ode,fn_)
 local fn,fd,comma,k,P;

 if nargs > 1 then
  fn := fn_;
 else
  if ode["key"] <> NULL then
   fn := cat(web_dir,"/phase/",ode["key"],"_lines.json")
  else
   error("Missing file name");
  fi;
 fi;

 fd := fopen(fn,WRITE):
 fprintf(fd,"{"):
 comma := "";

 for k in map(op,[indices(line_types)]) do
  if assigned(ode[cat(k,"_plot")]) then
   P := ode[cat(k,"_plot")];
   fprintf(fd,
           cat(comma,"\"",k,"\":",curves_to_json(P))):
   comma := ",";
  fi;
 od;

 fprintf(fd,"}"):
 fclose(fd):
end:

######################################################################

all_lines_tikz := proc(ode)
 local fd,comma,k,s,P;

 s := "";

 for k in map(op,[indices(line_types)]) do
  if assigned(ode[cat(k,"_plot")]) then
   P := ode[cat(k,"_plot")];
   s := cat(s,
            sprintf("\\begin{scope}[draw=%s] %% %s\n", line_types[k], k),
            curves_to_tikz(P,ode["view"]),"\\end{scope}\n");
  fi;
 od;

 return(s);
end:

######################################################################

save_png := proc(P,fn,dir := image_dir)
 plotsetup(png,plotoutput=cat(dir,fn,".png"),
           plotoptions="width=500,height=500");
 print(P);
 plotsetup(default);
end:

######################################################################

save_jpg := proc(P,fn,dir := image_dir)
 plotsetup(jpeg,plotoutput=cat(dir,fn,".jpg"),
           plotoptions="width=500,height=500");
 print(P);
 plotsetup(default);
end:

######################################################################

save_pdf := proc(P,fn,w_,h_,dir := image_dir)
 local old_dir,cmd,w,h,o;

 w := `if`(nargs > 2,w_,500);
 h := `if`(nargs > 3,h_,500);
 o := sprintf("noborder,width=%d,height=%d",w,h);

 plotsetup(eps,plotoutput=cat(dir,fn,".eps"),
           plotoptions=o);
 print(P);
 plotsetup(default);
 old_dir := currentdir(dir);
 cmd := sprintf("ps2pdf.bat -dEPSCrop %s.eps %s.pdf",fn,fn);
 ssystem(cmd);
 currentdir(old_dir);
 NULL;
end:

######################################################################

to_javascript := proc(e,result_name)
 local s;
 s := CodeGeneration[Java](e,output=string,resultname = result_name);
 s := StringTools[SubstituteAll](s,"(double)","");
 s := StringTools[SubstituteAll](s,"(int)","");
 return s;
end:

######################################################################

save_html := proc(ode)
 local html,vals,ix,k,k0,k1,fn,fd,x0,y0,dx,dy,dt;

 html := FileTools[Text][ReadFile]("../phase_template.html"):

 vals := table();
 vals["_KEY_"]           := "";
 vals["_TITLE_"]         := "";
 vals["_X_MIN_"]         := "-1.0";
 vals["_X_MAX_"]         := "1.0";
 vals["_Y_MIN_"]         := "-1.0";
 vals["_Y_MAX_"]         := "1.0";
 vals["_X_SCALE_"]       := "200";
 vals["_Y_SCALE_"]       := "200";
 vals["_T_SCALE_"]       := "1";
 vals["_UPDATE_WALKER_"] := "";
 vals["_TRACE_TD_"]      := "";
 vals["_CANVAS_WIDTH_"]  := "500";
 vals["_CANVAS_HEIGHT_"] := "500";
 vals["_EQUATIONS_"]     := "";
 vals["_DISPLAY_TABLE_"] := "";
 vals["_EXPLANATION_"]   := "";
 vals["_EXTRA_OPTS_"]    := "";

 ix := [indices(ode)];
 vals["_KEY_"] := ode["key"];

 if member(["title"],ix) then
  vals["_TITLE_"] := ode["title"];
 else
  vals["_TITLE_"] := ode["key"];
 fi;

 for k in ["x_min","x_max","y_min","y_max"] do
  k0 := cat("view_",k);
  k1 := cat("_",StringTools[UpperCase](k),"_");
  if member([k0],ix) then
   vals[k1] := sprintf("%A",ode[k0]);
  fi;
 od;

 for k in ["x_scale","y_scale","t_scale",
           "canvas_width","canvas_height"] do
  k1 := cat("_",StringTools[UpperCase](k),"_");
  if member([k],ix) then
   vals[k1] := sprintf("%A",ode[k]);
  fi;
 od;

 if ode["show_trace"] = true then
  if member(["trace_td"],ix) then
   vals["_TRACE_TD_"] := ode["trace_td"];
  else 
   vals["_TRACE_TD_"] := sprintf(
    "<td class=\"command\" width=\"100\" onclick=\"location='%s_trace.html'\">Graph against <em>t</em></td>",
    ode["key"]);
  fi;
 fi;

 if member(["equations"],ix) then
  vals["_EQUATIONS_"] := ode["equations"];
 else
  vals["_EQUATIONS_"] := cat(
   "\\begin{align*}\n",
   sprintf(" \\dot{x} &= %s \\\\\n",mylatex(ode["f"])),
   sprintf(" \\dot{y} &= %s \n",mylatex(ode["g"])),
   "\\end{align*}\n"
  );
 fi;

 if member(["update_walker"],ix) then
  vals["_UPDATE_WALKER_"] := ode["update_walker"];
 else
  dx := ode["f"] * dt +
        ode["f"] * diff(ode["f"],x) * dt^2/2 +
        ode["g"] * diff(ode["f"],y) * dt^2/2;
  dy := ode["g"] * dt +
        ode["g"] * diff(ode["g"],y) * dt^2/2 +
	ode["f"] * diff(ode["g"],x) * dt^2/2;

  vals["_UPDATE_WALKER_"] := cat(
   "var x0 = w.x;\n",
   "var y0 = w.y;\n",
   to_javascript(subs({x=x0,y=y0},dx),"var dx"),
   to_javascript(subs({x=x0,y=y0},dy),"var dy"),
   "this.translate_walker(w,dx,dy,dt);"
  );
 fi;

 if member(["display_table"],ix) then
  vals["_DISPLAY_TABLE_"] := ode["display_table"];
 else
  vals["_DISPLAY_TABLE_"] := cat(
"   <table>\n",
"    <tr>\n",
"     <td>$x=$</td>\n",
"     <td align=\"right\"><span id=\"display_x\"></span></td>\n",
"    </tr>\n",
"    <tr>\n",
"     <td>$y=$</td>\n",
"     <td align=\"right\"><span id=\"display_y\"></span></td>\n",
"    </tr>\n",
"    <tr>\n",
"     <td>$\\dot{x}=$</td>\n",
"     <td align=\"right\"><span id=\"display_x_dot\"></span></td>\n",
"    </tr>\n",
"    <tr>\n",
"     <td>$\\dot{y}=$</td>\n",
"     <td align=\"right\"><span id=\"display_y_dot\"></span></td>\n",
"    </tr>\n",
"   </table>\n"
);
 fi;

 fn := cat(ode["key"],".explain.html");
 
 if member(["explanation"],ix) then
  vals["_EXPLANATION_"] := ode["explanation"];
 elif FileTools[Exists](fn) then
  vals["_EXPLANATION_"] := FileTools[Text][ReadFile](fn);
  ode["explanation"] := vals["_EXPLANATION_"];
 fi;

 if member(["extra_opts"],ix) then
  vals["_EXTRA_OPTS_"] := ode["extra_opts"];
 fi;

 for k in [indices(vals)] do
  html := StringTools[SubstituteAll](html,op(k),vals[op(k)]);
 od;

 fn := cat(web_dir,"/phase/",ode["key"],".html");
 fd := fopen(fn,WRITE):
 fprintf(fd,html):
 fclose(fd);
end:

######################################################################

make_plots := proc(o)
 local ODE;

 if type(o,string) then
  ODE := eval(ode_table[o]);
 else
  ODE := eval(o);
 fi;
 
 ODE["make_plots"](ODE);
end:


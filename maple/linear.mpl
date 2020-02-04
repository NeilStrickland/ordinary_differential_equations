######################################################################
# We do this as a separate function to work around an annoying 
# issue about local/global interpretation of the names U and S.

singular_values := proc(A)
 return SingularValues(A,output=['S','U']);
end:

######################################################################

create_linear_ode := proc(A)
 local ode,a,L,V,i,lambda,omega,d;

 ode := create_ode(A[1,1] * x + A[1,2] * y,A[2,1] * x + A[2,2] * y);
 ode["view"] := [-1..1,-1..1];
 ode["view_type"] := "disc";
 ode["view_radius"] := 1;

 ode["A"] := A;
 L,V := Eigenvectors(A);
 L := map(simplify,map(rationalize,L));
 V := map(simplify,map(rationalize,V));

 if type(convert(V,listlist),[[rational,rational],[rational,rational]]) then
  d[1] := ilcm(denom(V[1,1]),denom(V[2,1]));
  d[2] := ilcm(denom(V[1,2]),denom(V[2,2]));
  V := V . <<d[1]|0>,<0|d[2]>>;
 fi;

 if is(Re(L[1]) > Re(L[2])) or
    (is(Re(L[1])=Re(L[2])) and is(Im(L[1]) > Im(L[2]))) then
  L := <L[2],L[1]>;
  V := <Column(V,2)|Column(V,1)>;
 fi;

 ode["has_real_eigenvalues"] := is(L[1],'real');
 ode["has_distinct_eigenvalues"] := not(is(L[1]-L[2]=0));

 if ode["has_real_eigenvalues"] then
  if ode["has_distinct_eigenvalues"] then
   ode["lambda_eq"] := [lambda[1]=L[1],lambda[2]=L[2]];
  else
   ode["lambda_eq"] := [lambda=L[1]];
  fi;
 else
  ode["lambda_eq"] := [lambda=Re(L[2]),omega=Im(L[2])];
 fi;

 for i from 1 to 2 do 
  ode["v",i] := Column(V,i);
  if ode["has_real_eigenvalues"] then
   if Norm(ode["v",i]) <> 0 then
    ode["v_hat",i] := evalf(ode["v",i]/Norm(ode["v",i],2));
    if ode["v_hat",i][2] < 0 then
     ode["v_hat",i] := - ode["v_hat",i];
    fi;
    ode["v_theta",i] := evalf(arctan(ode["v_hat",i][2],ode["v_hat",i][1]));
   fi;
  fi;
 od;

 ode["A"] := A;
 ode["tau"] := simplify(Trace(A));
 ode["delta"] := simplify(Determinant(A));
 ode["Delta"] := simplify(Trace(A)^2 - 4 * Determinant(A));
 ode["chi"] := CharacteristicPolynomial(A,t);
 ode["lambda"] := L;
 ode["V"] := V;
 ode["is_diagonalizable"] := evalb(Determinant(V) <> 0);
 ode["D"] := DiagonalMatrix(L);
 ode["E"] := MatrixExponential(t * ode["D"]);
 ode["P"] := MatrixExponential(t * A);

 ode["mu"],ode["W"] := singular_values(A);
 ode["w",1] := Column(ode["W"],1);
 ode["w",2] := Column(ode["W"],2);

 if ode["is_diagonalizable"] then
  ode["lyapunov_function"] := expand(Transpose((1/V).<x,y>) . (1/V) . <x,y>);
 fi;

 linear_classify(ode);

 ode["info_row"] := [
  convert(A,listlist) ,
  ode["tau"]          ,
  ode["delta"]        ,
  ode["Delta"]        ,
  ode["lambda_eq"]    ,
  ode["type"]
 ];

 return eval(ode);
end:

######################################################################

create_linear_ode_eqs := proc(f,g)
 local A,fg;

 A := <<coeff(f,x,1)|coeff(f,y,1)>,
       <coeff(g,x,1)|coeff(g,y,1)>>;
 fg := A . <x,y>;
 if not(f = fg[1] and g = fg[2]) then
  error "Equations are not linear";
 fi;

 return eval(create_linear_ode(A));
end:

######################################################################

linear_eval := proc(ode,a0,t0)
 local P0,a1;
 P0 := evalf(map2(subs,t=t0,ode["P"]));
 a1 := Vector(evalf([a0[1],a0[2]]));
 P0 . a1;
end:

######################################################################

linear_types := [
 "constant",
 "improper stable node",
 "stable node",
 "semistable node",
 "improper unstable node",
 "unstable node",
 "semiunstable node",
 "saddle",
 "clockwise centre",
 "anticlockwise centre",
 "clockwise stable focus",
 "anticlockwise stable focus",
 "clockwise unstable focus",
 "anticlockwise unstable focus",
 "degenerate stable node",
 "shear flow",
 "degenerate unstable node"
]:

######################################################################

linear_type_simple_matrix := table([
 "constant"                     = << 0| 0>,< 0| 0>>,
 "improper stable node"         = <<-1| 0>,< 0|-1>>,
 "stable node"                  = <<-2| 0>,< 0|-1>>,
 "semistable node"              = <<-1| 0>,< 0| 0>>,
 "improper unstable node"       = << 1| 0>,< 0| 1>>,
 "unstable node"                = << 1| 0>,< 0| 2>>,
 "semiunstable node"            = << 0| 0>,< 0| 1>>,
 "saddle"                       = <<-1| 0>,< 0| 1>>,
 "clockwise centre"             = << 0| 1>,<-1| 0>>,
 "anticlockwise centre"         = << 0|-1>,< 1| 0>>,
 "clockwise stable focus"       = <<-1/2| 1>,<-1|-1/2>>,
 "anticlockwise stable focus"   = <<-1/2|-1>,< 1|-1/2>>,
 "clockwise unstable focus"     = << 1/2| 1>,<-1| 1/2>>,
 "anticlockwise unstable focus" = << 1/2|-1>,< 1| 1/2>>,
 "degenerate stable node"       = <<-1|1>,<0|-1>>,
 "shear flow"                   = <<0|1>,<0|0>>,
 "degenerate unstable node"     = <<1|1>,<0|1>>
]):

######################################################################

simple_arrow_spec["improper stable node"] := [seq([i,0.3],i=1..24)]:
simple_arrow_spec["stable node"] := [seq([i,0.3],i=1..24)]:
simple_arrow_spec["semistable node"] := [seq([i,0.3],i=1..24)]:
simple_arrow_spec["improper unstable node"] := [seq([i,-0.3],i=1..24)]:
simple_arrow_spec["unstable node"] := [seq([i,-0.3],i=1..24)]:
simple_arrow_spec["semiunstable node"] := [seq([i,0.3],i=1..24)]:
simple_arrow_spec["saddle"] := [seq([i,0.2],i=1..5),
                                seq([i,0.2],i=8..12),
                                seq([i,0.2],i=13..17),
                                seq([i,0.2],i=20..24)]:
simple_arrow_spec["clockwise centre"] := [seq(seq([i,1.57*j],i=1..5),j=0..3)]:
simple_arrow_spec["anticlockwise centre"] := [seq(seq([i,1.57*j],i=1..5),j=0..3)]:
simple_arrow_spec["clockwise stable focus"] := [seq([i,0.7],i=1..12)]:
simple_arrow_spec["anticlockwise stable focus"] := [seq([i,0.2],i=1..12)]:
simple_arrow_spec["clockwise unstable focus"] := [seq([i,-0.7],i=1..12)]:
simple_arrow_spec["anticlockwise unstable focus"] := [seq([i,-0.2],i=1..12)]:
simple_arrow_spec["degenerate stable node"] := [seq([i,0.3],i=1..24)]:
simple_arrow_spec["shear flow"] := [seq([i,0.3],i=1..20)]:
simple_arrow_spec["degenerate unstable node"] := [seq([i,-0.3],i=1..24)]:

######################################################################

linear_type_typical_matrix := table([
 "constant"                     = << 0| 0>,< 0| 0>>,
 "improper stable node"         = <<-1| 0>,< 0|-1>>,
 "stable node"                  = <<-37/21|-8/21>,<-10/21|-26/21>>,
 "semistable node"              = <<-5/8|15/8>,<1/8|-3/8>>,
 "improper unstable node"       = << 1| 0>,< 0| 1>>,
 "unstable node"                = <<14/17|4/17>,<-15/17|37/17>>,
 "semiunstable node"            = <<-9/79|24/79>,<-33/79|88/79>>,
 "saddle"                       = <<29/25|-24/25>,<9/25|-29/25>>,
 "clockwise centre"             = <<-10/11|13/11>,<-17/11|10/11>>,
 "anticlockwise centre"         = <<1/22|-10/11>,<97/88|-1/22>>,
 "clockwise stable focus"       = <<-3/23|37/46>,<-65/46|-20/23>>,
 "anticlockwise stable focus"   = <<-76/67|-149/134>,<169/134|9/67>>,
 "clockwise unstable focus"     = <<55/218|130/109>,<-97/109|163/218>>,
 "anticlockwise unstable focus" = <<5/46|-61/46>,<20/23|41/46>>,
 "degenerate stable node"       = <<-41/31|4/31>,<-25/31|-21/31>>,
 "shear flow"                   = <<40/119|25/119>,<-64/119|-40/119>>,
 "degenerate unstable node"     = <<7/3|4/3>,<-4/3|-1/3>>
]):

######################################################################

linear_classify := proc(ode)
 local xy,L;

 L := ode["lambda"];

 if ode["is_diagonalizable"] then
  if is(L[1],'real') and is(L[2],'real') then
   if is(L[2] <0) then
    if is(L[1] = L[2]) then
     ode["type"] := "improper stable node";
    else
     ode["type"] := "stable node";
    fi;
   elif is(L[2] = 0) then
    if is(L[1] < 0) then
     ode["type"] := "semistable node";
    else # L[1] = L[2] = 0
     ode["type"] := "constant";
    fi;
   else # L[1] <= L[2],  L[2] > 0
    if is(L[1] < 0) then
     ode["type"] := "saddle";
    elif is(L[1] = 0) then
     ode["type"] := "semiunstable node";
    elif is(L[1] = L[2]) then
     ode["type"] := "improper unstable node";
    else # 0 < L[1] < [2]
     ode["type"] := "unstable node";
    fi;
   fi;
  else # non-real eigenvalues
   ode["direction"] := `if`(is(ode["A"][2,1] < 0),"clockwise","anticlockwise");
   if is(Re(L[1]) < 0) then
    ode["type"] := cat(ode["direction"]," stable focus");
   elif is(Re(L[1]) = 0) then
    ode["type"] := cat(ode["direction"]," centre");
   else # Re(L[1]) > 0
    ode["type"] := cat(ode["direction"]," unstable focus");
   fi;
  fi;
 else # not diagonalizable 
  if is(L[1] < 0) then
   ode["type"] := "degenerate stable node";
  elif is(L[1] = 0) then
   ode["type"] := "shear flow";
  else # L[1] > 0 
   ode["type"] := "degenerate unstable node";
  fi;
 fi;
 NULL;
end:

######################################################################

# a0 is assumed to be a point inside the unit circle.
# linear_flow_line_limits(ode,a0) returns a parameter range t0 .. t1
# such that the flow line passing through a0 at t = 0 stays within
# the unit disc for t0 <= t <= t1.

linear_flow_line_limits := proc(ode,a0)
 local a,aa,aas,aa0,aa1,aa2,aa3,aa4,opts,t0,t1,t2,u,i,cp,ab,c;

 a := ode["P"] . <a0[1],a0[2]>;
 aa := evalf(simplify(combine(expand(a[1]^2 + a[2]^2))));

 if type(aa,constant) then
  return (0..2*Pi); # Ugly hack
 fi;

 return find_limits(aa);
end:

find_limits := proc(f)
 local fs,tt,tt0,tt1,t0,t1,err,trig_args,omega,old_digits;

 if evalf(subs(t=0,f)) >= 1 then
  return 0..0;
 fi;

 if f = 0. then
  return 0 .. 0;
 fi;

 old_digits := Digits;
 Digits := 100;

 fs := convert(series(evalf(f),t=0,40),polynom,t);
 fs := add(Re(coeff(fs,t,i))*t^i,i=0..39);
 tt := select(u -> Im(u) = 0., [fsolve(fs-1)]);
 tt0 := select(u -> u < 0,tt);
 tt1 := select(u -> u > 0,tt);

 if degree(fs,t) <= 2 and tt0 <> [] and tt1 <> [] then
  return max(tt0) .. min(tt1);
 fi;

 if tt0 = [] then
  t0 := -infinity;
 else
  t0 := max(op(tt0));
  err := abs(evalf(subs(t=t0,f-1)));
  if err < 0.01 then
   t0 := fsolve(f = 1,t=t0,maxsols=1);
  else
   t0 := -infinity;
  fi;
 fi;
 if tt1 = [] then
  t1 :=  infinity;
 else
  t1 := min(op(tt1));
  err := abs(evalf(subs(t=t1,f-1)));
  if err < 0.01 then
   t1 := fsolve(f = 1,t=t1,maxsols=1);
  else
   t1 := infinity;
  fi;
 fi;

 Digits := old_digits;

 if not(has(f,exp)) then
  if (has(f,sin) or has(f,cos)) then
   if ((t0 = -infinity) or (t1 = infinity)) then
    trig_args := 
     map(u -> op(1,u),select(u -> (op(0,u) = sin or op(0,u) = cos),indets(f,function)));
    if nops(trig_args) <> 1 then 
     return FAIL;
    fi;
    omega := subs(t=1,op(trig_args));
    return -evalf(Pi/omega) .. evalf(Pi/omega);
   fi;
  fi;
 fi;

 return t0 .. t1;
end:

######################################################################

linear_find_flow_line := proc(ode,a0)
 local a,t01,t0,t1,u,opts;

 t01 := linear_flow_line_limits(ode,a0);
 t0,t1 := op(t01);

 opts := NULL;

 for u in args[3..-1] do
  if type(u,`=`) and lhs(u) = 't_min' then
   t0 := rhs(u);
  elif type(u,`=`) and lhs(u) = 't_max' then
   t1 := rhs(u);
  else
   opts := opts,u;
  fi;
 od;

 a := convert(ode["P"] . Vector([a0[1],a0[2]]),list);

 add_flow_line(ode,op(a),t0..t1);
end:

######################################################################

linear_sample_points := proc(ode)
 local c,p,q,r,a,u1,u2,s,s0,SP,w1,w2,w3,cd;
 if ode["type"] = "constant" then
  return [];
 elif ode["type"] = "semistable node" or 
      ode["type"] = "semiunstable node" then
  if ode["type"] = "semistable node" then
   w1 := ode["v_hat",1];
   w2 := ode["v_hat",2];
  else
   w1 := ode["v_hat",2];
   w2 := ode["v_hat",1];
  fi;
  w3 := <w1[2],-w1[1]>;
  cd := (w1[1]*w2[1] + w1[2]*w2[2])/(w3[1]*w2[1] + w3[2]*w2[2]);
  SP := NULL;
  for p from -11/12 to 11/12 by 1/6 do
   if p^2 * (1 + cd^2) < 1 then
    SP := SP,
          evalf(p * w3 + (p*cd+sqrt(1-p^2))/2*w1),
          evalf(p * w3 + (p*cd-sqrt(1-p^2))/2*w1);
   else
    SP := SP, evalf(p * w3);
   fi;
  od; 
  return [SP];
 elif ode["type"] = "saddle" then
  s0 := fsolve(<cos(s)|sin(s)> . ode["A"] . <cos(s),sin(s)>);
  u1 := <cos(s0),sin(s0)>;
  u2 := <u1[2],-u1[1]>;
  return [ seq(p*u1,p=-11/12 .. 11/12,1/6), 
           seq(p*u2,p=-11/12 .. 11/12,1/6) ];
 elif ode["type"] = "clockwise stable focus" or 
      ode["type"] = "anticlockwise stable focus" or 
      ode["type"] = "clockwise unstable focus" or 
      ode["type"] = "anticlockwise unstable focus" or 
      ode["type"] = "clockwise centre" or 
      ode["type"] = "anticlockwise centre" then
  if ode["mu"][1] < ode["mu"][2] then
   return [ seq(p*ode["w",1],p=-11/12 .. 11/12,1/6)]; 
  else  
   return [ seq(p*ode["w",2],p=-11/12 .. 11/12,1/6)]; 
  fi;
 elif ode["type"] = "shear flow" then
  return [seq([p * ode["v_hat",1][2], - p * ode["v_hat",1][1]],
              p=-0.95 .. 0.95,0.1)];
 else 
  return evalf([seq([0.99*cos(m*Pi/12),0.99*sin(m*Pi/12)],m=0..23)]);
 fi;
end:

######################################################################

linear_find_flow_lines := proc(ode)
 local SP,a;

 SP := linear_sample_points(ode);

 for a in SP do linear_find_flow_line(ode,a); od;

 NULL;
end:
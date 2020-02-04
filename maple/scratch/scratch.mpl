linear_2d_flow_line_limits := proc(S,a0)
 local a,aa,aas,aa0,aa1,aa2,aa3,aa4,opts,t0,t1,t2,u,i,cp,ab,c;

 a := S["E"] . <a0[1],a0[2]>;
 aa := simplify(expand(a[1]^2 + a[2]^2));
 cp := sort(select(u -> Im(u) = 0,evalf([solve(diff(aa,t))])));
 ab[-infinity] := limit(evalf(aa),t=-infinity);
 ab[ infinity] := limit(evalf(aa),t= infinity);
 for c in cp do ab[c] := evalf(subs(t=c,aa)); od;

 if nops(cp) = 0 or 
    (nops(cp) = 1 and (ab[-infinity] < 1 or ab[infinity] < 1)) then
  if ab[-infinity] < 1 then
   return(-infinity .. 0);
  else
   return(0 .. infinity);
  fi;
 elif nops(cp) = 1 then
  if cp[1] < 0 then
   t0 := fsolve(aa = 1,t=-infinity .. cp[1]);
   if not(type(t1,numeric)) then t1 := cp[1]; fi;
   return(t0 .. 0);
  elif cp[1] = 0 then
   return(0 .. 0);
  else
   t1 := fsolve(aa = 1,t = cp[1] .. infinity);
    if not(type(t1,numeric)) then t1 := cp[1]; fi;
   return(0 .. t1)
  fi;
 else # nops(cp) = 2
  if ab[-infinity] = 0. then
   if cp[1] >= 0 then
    return(-infinity .. 0);
   elif cp[2] >= 0 then
    t1 := fsolve(aa = 1,t = cp[2] .. infinity);
    if not(type(t1,numeric)) then t1 := cp[2]; fi;
    return(0 .. t1);
   else 
    if ab[cp[1]] > 1 then 
     t0 := fsolve(aa = 1,t = cp[1] .. cp[2]);
    else 
     t0 := -infinity;
    fi;
    return(t0 .. 0);
   fi;
  else 
   if cp[2] <= 0 then
    return(0 .. infinity);
   elif cp[1] <= 0 then
    t1 := fsolve(aa = 1,t = -infinity .. cp[1]);
    if not(type(t1,numeric)) then t1 := cp[1]; fi;
    return(0 .. t1);
   else 
    if ab[cp[2]] > 1 then 
     t1 := fsolve(aa = 1,t = cp[1] .. cp[2]);
    else
     t1 := infinity;
    fi;
    return(0 .. t1);
   fi;
  fi;
 fi;
end:


old_find_limits := proc(f)
 local t0,t1;
 t0 := - find_right_limit(subs(t = -t,f));
 t1 := find_right_limit(f);
 return t0 .. t1;
end:

old_find_right_limit := proc(f)
 local trig_args,omega;

 if has(f,sin) or has(f,cos) then
  trig_args := map(u -> op(1,u),select(u -> (op(0,u)=sin or op(0,u)=cos),indets(f,function)))/~t;
  if nops(trig_args) <> 1 then return FAIL; fi;
  omega := evalf(trig_args[1]);
  if not(type(omega,numeric)) then return FAIL; fi;
  return find_right_limit_trig(f,omega);
 else
  return find_right_limit_exp(f);
 fi;
end:

# If f contains only real exponentials then it works out that there
# are at most three critical points and Maple will find them explicitly
# using solve() rather than fsolve().

find_right_limit_exp := proc(f)
 local critical_points,c,s,i,v;

 critical_points := 
  sort(select(s -> (Im(s) = 0. and Re(s) > 0.), evalf([solve(diff(f,t)=0)])));
 critical_points := [op(critical_points),infinity];

 for c in critical_points do
  if c = infinity then 
   v := limit(f,t=infinity);
  else
   v := evalf(subs(t=c,f));
  fi;
  if v > 1 then
   return fsolve(f=1,t=0..c);
  fi;
 od;
 return infinity;
end:

# If f contains any trigonometric functions then it will have the
# form A * exp(lambda*t) * sin(omega*t + phi).  The critical points
# form a single coset of 2*Pi/omega * Z.

find_right_limit_trig := proc(f,omega)
 local t0,period,critical_points,c,fdot;

 fdot := combine(expand(diff(f,t)));
 t0 := fsolve(f - 1=0,t=0..infinity);
 if not(type([t0],[numeric])) then
  return infinity;
 fi;

 c0 := fsolve(fdot = 0,t=0..t0);
 if not(type([c0],[numeric])) then
  return t0;
 fi;
 if evalf(subs(t=c0,f)) > 1 then
  t0 := fsolve(f = 1,t = 0 .. c0);
 fi;


 period := evalf(2*Pi/abs(omega));

 fdot := combine(expand(diff(f,t)));
 critical_points := 
  sort(select(s -> (Im(s) = 0. and Re(s) > 0.), evalf([solve(fdot=0)])));

 if critical_points = [] then
  print([f,omega]);
  return FAIL;
 fi;
 c := critical_points[1]; 
 c := evalf(c/period);
 c := c - floor(c);
 c := evalf(c * period);
 
 while c < t0 and evalf(subs(t=c,f)) < 1 do 
  c := c + period;
 od;
 if c >= t0 then
  return t0;
 else
  return(fsolve(f - 1,t=0..c));
 fi;
end:


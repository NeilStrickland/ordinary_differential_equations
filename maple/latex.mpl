`latex/latex/symbol` := proc(QQ)
 local texlist, `{`, `}`, `\\_`, QQtmp, QQchars;
 option system, remember;
    if StringTools:-IsSpace(QQ) then
        texlist := convert(QQ, string);
    elif assigned(`latex/special_names`[`` || QQ]) then
        texlist := `latex/special_names`[evaln(`` || QQ)]
    elif member(QQ, eval(`latex/greek`, 1)) then
        texlist := `latex/latex/copy`(`\\` || QQ)
    elif has(`latex/mathops`, QQ) then
        texlist := `latex/latex/copy`(`\\` || QQ)
    elif 0 < length(QQ) and has({"A", "B", "C", "D", "E", "F", "G", "H",
    "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
    "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
    "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
    "y", "z", "'"}, convert(substring(QQ, 1 .. 1), string)) and {} =
    convert(`latex/latex/chars_in_string`(QQ), 'set') minus ({"A", "B",
    "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d",
    "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
    "s", "t", "u", "v", "w", "x", "y", "z", "'"} union
    {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}) then
        if length(QQ) = 1 then texlist := `latex/latex/copy`(QQ)
        else texlist :=
            `{`, `latex/csname_font`, `latex/latex/copy`(QQ), `}`
        fi
    elif 0 < length(QQ) and has({"A", "B", "C", "D", "E", "F", "G", "H",
    "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
    "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
    "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
    "y", "z", "'"} union {"_"}, convert(substring(QQ, 1 .. 1), string))
     and {"_"} = convert(`latex/latex/chars_in_string`(QQ), 'set') minus (
    {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b",
    "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
    "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "'"} union
    {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}) then texlist :=
        `{`, `latex/csname_font`,
        cat(op(subs("_" = "\\_", `latex/latex/chars_in_string`(QQ)))), `}`
    elif is(QQ, BottomProp) <> FAIL and substring(QQ, -1 .. -1) = "~" and
    0 < length(QQ) and has({"A", "B", "C", "D", "E", "F", "G", "H", "I",
    "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
    "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
    "z", "'"}, convert(substring(QQ, 1 .. 1), string)) and {"~"} =
    convert(`latex/latex/chars_in_string`(QQ), 'set') minus ({"A", "B",
    "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d",
    "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
    "s", "t", "u", "v", "w", "x", "y", "z", "'"} union
    {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}) then
        QQtmp := substring(QQ, 1 .. -2);
        if length(QQtmp) = 1 then texlist := `latex/latex/copy`(QQtmp)
        else texlist :=
            `{`, `latex/csname_font`, `latex/latex/copy`(QQtmp), `}`
        fi
    elif is(QQ, BottomProp) <> FAIL and substring(QQ, -1 .. -1) = "~" and
    0 < length(QQ) and has({"A", "B", "C", "D", "E", "F", "G", "H", "I",
    "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
    "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
    "z", "'"} union {"_"}, convert(substring(QQ, 1 .. 1), string)) and
    {"_", "~"} = convert(`latex/latex/chars_in_string`(QQ), 'set') minus (
    {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b",
    "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
    "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "'"} union
    {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}) then texlist :=
        `{`, `latex/csname_font`, cat(op(subs("_" = "\\_",
        `latex/latex/chars_in_string`(substring(QQ, 1 .. -2))))), `}`
    else 
        QQchars := `latex/latex/chars_in_string`(QQ);
        texlist := subs("#" = "\\#", "$" = "\\$", "%" = "\\%",
                        "&" = "\\&", "_" = "\\_", "{" = "\\{", "}" = "\\}",
                        "~" = "\\~{}",  "^" = "\\^{}", "\\" = "$\\backslash$",
                        "<" = "$<$", ">" = "$>$", "|" = "$|$", QQchars);
        if QQchars <> texlist then
            texlist := `\\mbox `, `{` $ 2, `latex/verbatim_font`,
                       cat(op(texlist)), `}` $ 2
        else
            texlist := cat(op(texlist));
        fi;
    fi;
    return texlist
end:

`latex/latex/**` := 
 proc(e)
  local texlist, `[`, `\\frac `, `\\sqrt `, `]`, `{`, `}`;
  option
  `Copyright (c) 1992 by the University of Waterloo. All rights reserved.`;
      texlist := NULL;
     if type(op(2, e),fraction) and op(2,e)=1/2 and  
        type(op(1,e),integer) and 0<=op(1,e) and op(1,e)<10 then
        texlist := texlist, `\\sqrt `, `{`, `latex/print`(op(1, e)), `}`
     else
        if type(op(1, e), {
          'function', '`+`', '`*`', 'fraction', '`^`', 'series', 'negative'})
          and not op(1,e)=exp(1)
          then texlist := texlist, `latex/latex/prinpar`(op(1, e))
        elif type(op(1, e), 'nonreal') and not type(op(1, e), 'imaginary')
          then texlist := texlist, `latex/latex/prinpar`(op(1, e))
        else texlist := texlist, `{`, `latex/print`(op(1, e)), `}`
        fi;
        texlist := texlist, `^`, `{`, `latex/print`(op(2, e)), `}`
     fi;
     texlist
end:
 
`latex/exp` := 
  proc()
     local e, `{`, `}`;
       if nargs=1 and args[1]=1 then
        `{`, `\\it `, e,`}`; 
       else
        `{`, `{`, `\\it `, e,`}`, `^`, `{`, `latex/print`(args), `}`,`}`; 
       fi;
end:

`latex/latex/matrix` := proc(e)
 local i, j, m, n, texlist, `&`, `\\\\`, `\\mbox `, `?`, `\\end `,
 `\\right `, `]`, `[`, `\\begin `, `\\left `, c;
 option
 `Copyright (c) 1992 by the University of Waterloo. All rights reserved.`;
     m := linalg['rowdim'](e);
     n := linalg['coldim'](e);
     texlist := `\\left `, `[`,
  `latex/latex/copy`(cat(`\\begin `, `{`, 'array', `}`)),
  `{`,(`latex/latex/copy`(cat(c $ n))),`} `;
     for i to m do
  if not has(e[i, 1], e) then
      texlist := texlist, `latex/print`(e[i, 1])
  else texlist := texlist, `latex/latex/undefined_entry`(e, i, j)
  fi;
  for j from 2 to n do
      if not has(e[i, j], e) then
   texlist := texlist, `&`, `latex/print`(e[i, j])
      else texlist :=
   texlist, `&`, `latex/latex/undefined_entry`(e, i, j)
      fi
  od;
  if i <> m then texlist := texlist, `\\\\` fi
     od;
     texlist := texlist,
  `latex/latex/copy`(cat(`\\end `, `{`, 'array', `}`)), `\\right `,
  `]`
 end:

`latex/` := 
 proc()
  local `(`,`)`;
  `latex/latex/commalist`([args], `,`, `(`, `)`);
 end:

`latex/latex/*` := 
 proc(e)
  local subexp, den, ee, ff, subee, i, k, num, texlist, `\\,`, `\\frac `,
  `\\sqrt `, `{`, `}`;
  global _LatexSmallFractionConstant;
  if type(op(1, e), 'numeric') and op(1, e) < 0 then
      return `latex/latex/copy`('`-`'), `latex/print`(-e)
  fi;
  if type(op(1, e), 'numeric') then
      texlist := `latex/print`(op(1, e)), `\\,`,
          `latex/print`(subsop(1 = 1, e));
      return texlist
  fi;
  texlist := NULL;
  num := 1;
  den := 1;
  ee := e;
  for subee in [op(ee)] do
      if type(subee, 'fraction') then
          num := num*op(1, subee); den := den*op(2, subee)
      elif type(subee, '`^`') and type(op(2, subee), 'rational') and
      op(2, subee) < 0 then den := den/subee
      else num := num*subee
      fi
  end do;
  if den <> 1 then
      if type(num, '`latex/istall`') or type(den, '`latex/istall`') then
          if num <> 1 then
              texlist := `latex/print`(num);
              if type(num, '`+`') then
                  texlist := ` \\left( `, texlist, ` \\right) `
              fi
          else texlist := NULL
          fi;
          if type(den, '`*`') then den := [op(den)]
          else den := [den]
          fi;
          for subexp in den do
              texlist := texlist, `latex/print`(1/subexp)
          end do;
          texlist
      else texlist := texlist, `{`, '`\\frac `', '`{`',
          `latex/print`(num), '`}`', '`{`', `latex/print`(den), '`}`',
          `}`
      fi
  else
      i := 1;
      ff := [op(ee)];
      for k to nops(ff) do
          if type(ff[k], {'`+`', 'series'}) then
              texlist := texlist, `latex/latex/prinpar`(ff[k])
          elif type(ff[k], 'complex'('numeric')) and nops(ff[k]) = 2
          then texlist := texlist, `latex/latex/prinpar`(ff[k])
          elif i < nops(ee) and type(ff[k], 'function') and
          member(op(0, ff[k]), {diff, Diff}) then
              texlist := texlist, `latex/latex/prinpar`(ff[k])
          elif
          type(ff[k], 'function') and member(op(0, ff[k]), {`@`, `@@`})
          then texlist := texlist, `latex/latex/prinpar`(ff[k])
          elif type(ff[k], procedure) then
              texlist := texlist, `latex/latex/prinpar`(ff[k])
          else texlist := texlist, `latex/print`(ff[k])
          fi;
          if i < nops(ee) and (
          i = 1 and type(op(1, ee), 'integer') or type(ff[k], '`!`') or
          type(ff[k], {'symbol', 'string'}) and 1 < length(ff[k]) or
          has([`latex/print`(ff[k])], '`\\sqrt `')) then
              texlist := texlist, `\\,`
          fi;
          i := i + 1
      end do
  fi;
  texlist
end:

LaTeXDigits := 7:

`latex/latex/float` := 
  proc (x::float) 
     global LaTeXDigits;
     local sign, fracpart, filler, mantissa, ipart, exponent, ` `, `-`, `.0`, `\\times `, `{`, `}`, m1, m2, 
        d,n,t,sf,shift;
     option `Copyright (c) 1992 by Waterloo Maple Inc.  All rights reserved.`; 

     if abs(op(1,x))=0 then
        "0.0"
     else
        t:=evalf(x):
        while (op(1,t) mod 10) = 0 do
          t:=Float(iquo(op(1,t),10),op(2,t)+1);
        od:

        mantissa:=abs(op(1,t)): 
        sign := `if`(op(1,t) < 0,"-",""); 
        exponent:=op(2,t): 
        sf:=length(mantissa):

        # convert to scientific notation for numbers with abs
        # outside of 10^(-10) to 10^10
        if exponent < 10 and -10 < sf+exponent then
          # for positive exponents, we ignore the significant figures setting
          # and just use treat it as an integer
          if exponent>=0 then
            return cat(sign,mantissa*10^exponent);
          # if exponent is -1, don't worry about significant figures either
          # but keep the tenths digit
          elif exponent=-1 then
            ipart:=(mantissa-(mantissa mod 10))/10;
            fracpart:=mantissa mod 10;
            return cat(sign,ipart,".",fracpart);
          # exponent is less than -1
          else
            # reduce the number of significant digits to LaTeXDigits
            if sf>LaTeXDigits then 
              shift:=min(sf-LaTeXDigits,-1-exponent);
              mantissa:=round(mantissa/10^shift); 
              exponent:=exponent+shift;
            fi:
            # if its greater than or equal to one, we're all set
            if mantissa>=10^(-exponent) then
              ipart:=(mantissa-(mantissa mod 10^(-exponent)))/10^(-exponent);
              fracpart:=mantissa mod 10^(-exponent);
              # pad zeros on the left if needed
              filler:=-exponent-length(fracpart);
              if fracpart=0 then
                return cat(sign,ipart)
              else
                return cat(sign,ipart,".","0"$filler,fracpart)
              fi:
            # otherwise we need the leading zero and the other zeros
            else
              filler:=-exponent-length(mantissa);
              return cat(sign,"0.","0"$filler,mantissa);              
            fi:
          fi:

        # sci notation
        else
          if sf > LaTeXDigits then 
            shift:=sf-LaTeXDigits;
            mantissa:=round(mantissa/10^shift); 
            exponent:=exponent+shift;
          fi:
          sf:=length(mantissa);
          ipart:=(mantissa-(mantissa mod 10^(sf-1)))/10^(sf-1);
          fracpart:=mantissa mod 10^(sf-1);
          return cat(sign,ipart,".",fracpart,"\\times 10^{",exponent+sf-1,"}");
        fi:
     fi
  end:

`LaTeX/trim` :=
 proc(s)
  local t;
  t := convert(s,string);
  if t = "\\left " then
   t := "\\left";
  elif t = "\\right " then
   t := "\\right";
  elif substring(t,1..8) = "\\begin {" then
   t := cat("\\begin{",substring(t,9..-1));
  elif substring(t,1..6) = "\\end {" then
   t := cat("\\end{",substring(t,7..-1));
  fi;
  t;
 end:

mylatex := proc(e::anything)
 local texlist,err;

 if nargs = 0 then 
  RETURN("NULL");
 elif nargs > 1 then
  RETURN(`Util/CommaJoin`(op(map(mylatex,[args]))));
 else
   texlist := traperror([`latex/print`(eval(e))]);
   if texlist = lasterror then
    err := sprintf("%A",e);
    if (length(err) > 200) then
     err := cat(substring(err,1..200),"...");
    fi;
    err := cat("Maple to LaTeX error: ",err);
    RETURN(err);
   fi;
   texlist := map(`LaTeX/trim`,texlist);
   cat(op(texlist));
  fi;
 end:



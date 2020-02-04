@ECHO OFF
SETLOCAL
IF EXIST D:\wamp\www\pm1nps\courses\MAS290 (
 SET WEBDIR=D:\wamp\www\pm1nps\courses\MAS290
) ELSE (
IF EXIST C:\wamp\www\courses\MAS290 (
 SET WEBDIR=C:\wamp\www\courses\MAS290
) ELSE (
 SET WEBDIR=C:\wamp\www\pm1nps\courses\MAS290
))

echo "WEBDIR="
echo %WEBDIR%

pdflatex all_lectures
pdflatex -job-name=all_handouts \def\HO{1} \input{all_lectures}
pdflatex -job-name=all_static \def\HO{1} \def\ST{1} \input{all_lectures}

copy all_lectures.pdf %WEBDIR%\notes\all_lectures.pdf
copy all_handouts.pdf %WEBDIR%\notes\all_handouts.pdf
copy all_static.pdf   %WEBDIR%\notes\all_static.pdf


read("../ode.mpl"):
read("../square_ode.mpl"):
read("../linear.mpl"):
read("../latex.mpl"):

olddir := currentdir();
currentdir("../../lectures/images");
image_dir := cat(currentdir(),"/");
currentdir("../../aim/images");
aim_image_dir := cat(currentdir(),"/");
currentdir(olddir);

web_dirs := [
 "C:/wamp/www/courses/MAS290/",
 "D:/wamp/www/courses/MAS290/",
 "C:/wamp/www/pm1nps/courses/MAS290/",
 "D:/wamp/www/pm1nps/courses/MAS290/"
];

web_dir := NULL;

for w in web_dirs do 
 if isdir(w) then
  web_dir := w;
 fi;
od:

thumbs_dir := cat(web_dir,"phase/thumbs/");



<?php

$files = scandir('./images');
$images = array();

foreach($files as $f) {
 if (strlen($f) >= 4) {
  $e = substr($f,-4);
  if (($e == '.png' || $e == '.pdf') &&
      $f != 'all_images.pdf') {
   $images[] = $f; 
  }
 }
} 

$tex = <<<TEX
\documentclass[a4paper]{amsart}
\usepackage{fullpage}
\usepackage{verbatim}
\usepackage{tikz}

\begin{document}

TEX;

foreach($images as $f) {
 $tex .=
  "\includegraphics[width=6cm]{" . $f . 
  "}\\verb+ " . $f . "+\\\\\r\n";
}

$tex .= <<<TEX

\\end{document}

TEX;

file_put_contents("./images/all_images.tex",$tex);

?>

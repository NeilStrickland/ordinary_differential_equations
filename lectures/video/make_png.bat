convert bessel_movie_0_1.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_0_1.gif
convert bessel_movie_0_2.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_0_2.gif
convert bessel_movie_0_3.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_0_3.gif
convert bessel_movie_1_1.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_1_1.gif
convert bessel_movie_1_2.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_1_2.gif
convert bessel_movie_1_3.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_1_3.gif
convert bessel_movie_2_1.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_2_1.gif
convert bessel_movie_2_2.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_2_2.gif
convert bessel_movie_2_3.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_2_3.gif
convert bessel_movie_3_1.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_3_1.gif
convert bessel_movie_3_2.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_3_2.gif
convert bessel_movie_3_3.gif -crop 360x324+71+94 +repage -set delay 5 -loop 0 bm_3_3.gif

convert -coalesce bm_0_1.gif bm_0_1/b%d.png
convert -coalesce bm_0_2.gif bm_0_2/b%d.png
convert -coalesce bm_0_3.gif bm_0_3/b%d.png
convert -coalesce bm_1_1.gif bm_1_1/b%d.png
convert -coalesce bm_1_2.gif bm_1_2/b%d.png
convert -coalesce bm_1_3.gif bm_1_3/b%d.png
convert -coalesce bm_2_1.gif bm_2_1/b%d.png
convert -coalesce bm_2_2.gif bm_2_2/b%d.png
convert -coalesce bm_2_3.gif bm_2_3/b%d.png
convert -coalesce bm_3_1.gif bm_3_1/b%d.png
convert -coalesce bm_3_2.gif bm_3_2/b%d.png
convert -coalesce bm_3_3.gif bm_3_3/b%d.png

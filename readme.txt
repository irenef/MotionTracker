1.1 
	mots = 
	-13.0000  -10.5000   -0.0826  206.3767  121.1370 
	 13.0000   10.5000    0.0900  193.3767  110.6370

1.2 
	mots = 
	 13.0000   10.5000    0.0900  193.3767  110.6370 
	-13.0000  -10.5000   -0.0826  206.3767  121.1370

2.3.1
Not so far at all. A single-scale LK is very sensitive to
different s values. If s scales the feature in the current image too big
or too small comparing to the previous image, the error will be
significant. [20 20 0.2 0 0] already produces bad outputs. 

	More results (data/girl): 
	[20 20 0.2 0 0] error: 0.078715
	[30 30 0 0 0]   error: 0.0109
	[0 0 0.2 0 0]   error: 0.0310 

2.3.2
The results are consistent if the starting motion has relatively small u,v,s
values. If the s value scales the current image so that it's in a
similar scale as the previous image, accuracy increases (error drops).
It doesn't change with prect center values.

	max_iter: defines the maximum number of tracking iteration. Larger
	number in max_iter allows better accuracy in tracking bigger change
	in position (so if the feature in curr image moved significantly
	comparing to the prev image).

	uvs_min_significant: terminates tracking if change in motion is
	insignificant (below this threshold). By lowering this threshold,
	the tracker will keep running even if the motion change is subtle,
	which achieves better accuracy.

	err_change_thr: error increased (local minimum found). By increasing
	this threshold, the search for local minimum in gradient descent
	will allow bigger local error increases, which improves accuracy.

	Made the params the following for better results: cparams.max_iter =
	100; cparams.uvs_min_significant = [0.000001 0.000001 0.000001];
	cparams.err_change_thr = 0.1;

3.3 
The multi-scale LK can handle init_motion that is quite different
from the ground truth because gradient descent accounts for and
therefore updates the s value in the direction of smaller errors, and
pyramid takes care of larger changes in motion. The same motion model
in 2.3.1 works for 3.3 ([20 20 0.2 0 0]), and even [30 30 -0.5 100 100]
still produces great outputs. 

	More results (data/girl):
	[30 30 -0.5 0 0] error: 0.006702 
	[30 30 -0.5 0 0] error: 0.006702

4 
It can theoretically track for an infinite amount of time if we assume
the change in motion is small, brightness is consistent, motion is
spatially consistent. It can break if the motion becomes too complex
(e.g. affine) because our motion model only accounts for translation and
scale. It can break if the brightness is not consistent, because noise
is introduced in the process of error calculation. It can also break if
there's occlusion over the feature.

sample output: 
Tracking 1  to image img00001 motion <0.41 -0.23 0.001 (180,109)> rect 127.87 231.94  45.22 172.31 
Tracking 2  to image img00002 motion <1.33 0.40 -0.003 (180,109)> rect 129.36 233.11  45.82 172.52 
Tracking 3  to image img00003 motion <1.33 0.40 -0.003 (181,109)> rect 130.85 234.28  46.41 172.72 
Tracking 4  to image img00004 motion <3.74 0.35 0.011 (183,110)> rect 134.03 238.59  46.07 173.76 
Tracking 5  to image img00005 motion <5.79 -2.81 0.018 (186,110)> rect 138.87 245.32  42.11 172.10 
Tracking 6  to image img00006 motion <8.56 -3.24 0.010 (192,107)> rect 146.89 254.43  38.21 169.52 
Tracking 7  to image img00007 motion <5.71 -3.46 0.018 (201,104)> rect 151.62 261.11  33.55 167.26 
Tracking 8  to image img00008 motion <9.48 -0.12 0.019 (206,100)> rect 160.09 271.61  32.19 168.37 
Tracking 9  to image img00009 motion <8.03 1.97 0.025 (216,100)> rect 166.70 281.06  32.43 172.08 
Tracking 10  to image img00010 motion <8.03 1.97 0.025 (224,102)> rect 173.28 290.54  32.63 175.83 


Images Descriptions 

outputs/girl1_* 
	results for 3.3. The second number denotes the level. 
	For example girl1_1 is the result for level 1. 
	curpyr reads image 43, and prevpyr reads image 41.

outputs/david1_* 
	same as girl1_* but for data/david

outputs/girl2_* 
	results for 4.4. The second number denotes the frame number.

outputs/girl3_1
	results for 3.3 with the following params: 
	cparams.max_iter = 50;
    cparams.uvs_min_significant = [0.00001 0.00001 0.00001];
    cparams.err_change_thr = 0.1;
	
outputs/david2_* 
	same as girl2_* but for data/david
	
outputs/girl_error_1 
	sample error for 2.3 
outputs/girl_error_2
	sample error for 3.3 

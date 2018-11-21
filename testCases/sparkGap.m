

showFlag='showImage';

meshCount=0;

edgeNums=1:6;

edgePoints=[
    2    2    3.5 3.5 4.25  5  5  7  7  6  6  1  1  0  0
    1 -2.75 -2.75  -2 -2.75 -2  1  1 -4 -4 -3 -3 -4 -4  1
    ];

[ u,E,pos,points_E,EE,max_absE,point_max,maxE ] = electrostaticPDE( edgePoints,edgeNums,meshCount,showFlag );


showFlag='showImage';

meshCount=1;

% edgeNums=1:6;

% edgePoints=[
%     2    2    3.5 3.5 4.25  5  5  7  7  6  6  1  1  0  0
%     1 -2.75 -2.75  -2 -2.75 -2  1  1 -4 -4 -3 -3 -4 -4  1
%     ];

% edgePoints=[
%     2    2    3.5 3.5 4.25  5  5  7  7  6  6  1  1  0  0
%     1 -2.75 -2.75  -2 -2.75 -2  1  1 -4 -4 -2.8 -2.8 -4 -4  1
%     ];

edgeNums=1:3;
edgePoints=[
1 0
1 -2.45
2 -2.45
2 0
3 0
3 -3.5
2.5 -3.5
2.5 -2.5
0.5 -2.5
0.5 -3.5
0 -3.5
0 0
    ]';
% angleC = 5;
% originC = [1 0]; %����������������start_toolΪԭ�㣬��ת���������꣨���ǵ缫�ˣ�
% [ edgePoints ] = rotateC( edgePoints,[edgeNums,edgeNums(end)+1], angleC, originC );%����tool��3���ߣ�����3+1=4��������Ҫ��ת


[ u,E,pos,points_E,EE,max_absE,point_max,maxE ] = electrostaticPDE( edgePoints,edgeNums,meshCount,showFlag );



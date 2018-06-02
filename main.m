%main 入口程序

%grid：微米；
grid=25; 
%假设放电间隙100微米
sparkDist=100;
%体积损耗比与蚀坑半径(假设精加工放电坑100um、300um直径)
rw=300/2/grid;
wearRatio=1/9;
rt=rw*sqrt(wearRatio);
%矩阵大小相关系数
gridRatio=1/grid;
%击穿场强大小
% breakE=

disp('model');
tic,
%单位：微米
%tool
tl=zeros(25000*gridRatio,12000*gridRatio);
tt=ones(25000*gridRatio,6000*gridRatio);
tr=zeros(25000*gridRatio,12000*gridRatio);
t=[tl tt tr];
%workpiece
wl=zeros(5000*gridRatio,5000*gridRatio);
ww=ones(5000*gridRatio,20000*gridRatio);
wr=zeros(5000*gridRatio,5000*gridRatio);
w=[wl ww wr];
%whole
h1=ones(1,30000*gridRatio);% 此处1写死了
spark=zeros(sparkDist*gridRatio,30000*gridRatio);% 放电间隙sparkDist至少3个网格
matrix=[h1; t; spark; w; h1];
matrix(:,1)=1;
matrix(:,size(matrix,2))=1;
toc

geom_dl = [2,2,2,2,2,2,2,2,2,2,2,2;
    100, -30, 150, -150, 100,-100, 30, -30, -150, 100, 150, -30;
    -100, 30, 150, -150, 100,-100, 30, -30, -100, 150,  30,-150;
    50,   51,   0,  300,   0,  50, 51, 300,    0,   0, 300, 300;
    50,   51, 300,    0,  50,   0,300,  51,    0,   0, 300, 300;
    0,     0,   1,    1,   0,   0,  0,   0,    1,   1,   1,   1;
    1,     1,   0,    0,   1,   1,  1,   1,    0,   0,   0,   0];

showFlag='';
showFlag='showImage';
%--------------------------------------------------------------------------


% 边界跟踪（输入：代表正负电极形状的矩阵；输出：正负电极边界点行列）
disp('boundary trace:');
tic,[wm,wn,tm,tn] = boundaryTrace(matrix, showFlag);toc

% 1.矩阵点连接成边，相同斜率的边是同一个边
% 2.构建 geom 矩阵
%（输入：boundary points；输出：连接好的edge组成的geom_dl矩阵）
%（注：二维图形的pde_geom矩阵，暂时不会三维矩阵的构造）
disp('generate pde Geometry:');
% tic,[geom_dl] = pdeEdgeGeom(boundaryPoints);toc

% 电场计算（输入：电极形状，边界条件；输出：~,矢量E，E的起点坐标，E的大小）
disp('calculate E');
tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(geom_dl);toc
% tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE;toc

% 获取放电点对（输入：边界点行列，E，grid边长，左上顶点实际坐标；输出：放点电行列）
disp('spark point:');
tic,
origin_left_up=[...
    -size(matrix,2)/2, ...
    size(matrix,1)-size(h1,1)...
    ]*grid/1000*10; % 仍需修改，尤其是横坐标，/10是转化成了厘米
[sparkpoint_tool] = sparkPoint(tm,tn,maxPoint',maxE,maxAbsE,grid/1000*10,origin_left_up);% 仍需修改，尤其是横坐标，/10是转化成了厘米
[sparkpoint_workp] = sparkPoint(wm,wn,maxPoint',maxE,maxAbsE,grid/1000*10,origin_left_up);
toc

% 蚀除（输入：完整矩阵，两放点电，两蚀坑半径；输出：完整矩阵）
disp('erode:');
tic,[matrix] = erode(matrix,rt,rw,sparkpoint_tool,sparkpoint_workp);toc

% 以下用于测试：
% matrix(sparkpoint_tool(1),sparkpoint_tool(2))%1
% matrix(sparkpoint_tool(1)+1,sparkpoint_tool(2))%0
% matrix(sparkpoint_tool(1),sparkpoint_tool(2)+1)%0
% matrix(sparkpoint_workp(1),sparkpoint_workp(2))%1
% matrix(sparkpoint_workp(1)-1,sparkpoint_workp(2))%0
% matrix(sparkpoint_workp(1)+1,sparkpoint_workp(2))%1
% size(matrix)
%--------------------------------------------------------------------------

tic,
disp('result pic:');
toc
tic,
figure(4);
imshow(matrix);
title('蚀除结果');
toc



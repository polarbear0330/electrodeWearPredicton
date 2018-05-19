%grid：微米；假设精加工放电坑100um、300um直径
grid=25; 
rw=300/grid;
wearRatio=1/9;
rt=rw*sqrt(wearRatio);

% %假设放电间隙100微米
% sparkDist=100/1000;
%矩阵大小相关系数
gridRatio=1/grid;
% gridRatio=1;

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
h1=zeros(10,30000*gridRatio);% 此处10写死了
spark=zeros(100*gridRatio,30000*gridRatio);% 放电间隙100微米，后续写成变量
matrix=[h1; t; spark; w; h1];


% 边界跟踪（输入：代表正负电极形状的矩阵；输出：正负电极边界点行列）
[wm,wn,tm,tn]=boundaryTrace_Main(matrix);

% 电场计算（输入：电极形状，边界条件；输出：~,矢量E，E的起点坐标，E的大小）
[~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE;

% 获取放电点对（输入：边界点行列，E，grid边长，左上顶点实际坐标；输出：放点电行列）
origin_left_up=[...
    -size(matrix,2)/2, ...
    size(matrix,1)-size(h1,1)...
    ]*grid/1000/10; % 仍需修改，尤其是横坐标，/10是转化成了厘米
[sparkpoint_tool] = sparkPoint(tm,tn,maxPoint',maxE,maxAbsE,grid,origin_left_up);
[sparkpoint_workp] = sparkPoint(wm,wn,maxPoint',maxE,maxAbsE,grid,origin_left_up);

% 蚀除（输入：完整矩阵，两放点电，两蚀坑半径；输出：完整矩阵）
[matrix] = erode(matrix,rt,rw,sparkpoint_tool,sparkpoint_workp);


figure(4);
imshow(matrix);
title('蚀除结果');








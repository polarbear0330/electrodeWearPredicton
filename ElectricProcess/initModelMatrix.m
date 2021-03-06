function [ vertexes4,matrixPair,xyOriginPair ] = initModelMatrix( matrix_t,matrix_w,conf )
%INITMODELMATRIX 均匀网格，几何建模，矩阵matrix
%   此处显示详细说明

% matrix_t=ones(8,4);
% matrix_w=ones(4,10);
% % gap=3;
% % wideRatio=1.5;

grid = conf.grid;
gap=conf.sparkDist/grid;
% gap=158
% gap=1
wideRatio=conf.wideRatio;

[matrix_t] = surroundBy0(matrix_t);
[matrix_w] = surroundBy0(matrix_w);

[height_t,wide_t]=size(matrix_t);
[height_w,wide_w]=size(matrix_w);

if(wide_t>=wide_w)
    disp("Error: wide_tool >= wide_workpiece");
end
wideMax=max(wide_t,wide_w);

wide=wideMax*wideRatio;
height=height_t+gap+height_w;
vertexes4 = [
wide*grid 0
wide*grid -height*grid
0 -height*grid
0 0
]';%注意这个转置咯！

% workp -- xyc
wide_left_w=floor((wideRatio-1)*wide_w/2);
start_workp=[gap+height_t+1,wide_left_w+1];  %左上角的0
start_workp=[(start_workp(2)-1), -(start_workp(1)-1)]*grid;
start_workp=[start_workp,0];

% tool -- xyc
startRow=1;
startCol=floor((wide-size(matrix_t,2))/2)+1;
start_tool=[startRow,startCol];  %左上角的0
start_tool=[(start_tool(2)-1), -(start_tool(1)-1)]*grid;
start_tool=[start_tool,0];

%写入结构体。输入输出参数分类。
matrixPair.matrix_t=matrix_t;
matrixPair.matrix_w=matrix_w;
xyOriginPair.start_tool=start_tool;
xyOriginPair.start_workp=start_workp;

% 以下用于图形化展示总matrix
% gapAndTool=zeros(gap+height_t, wide);
% left_w=zeros(height_w, wide_left_w);
% right_w=zeros(height_w, wide - wide_w - wide_left_w);
% workp=[left_w, matrix_w, right_w];
% matrix=[gapAndTool; workp];
% matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;
% matrix(:,[1,end])=1;
% matrix([1,end],:)=1
end

function [matrix] = surroundBy0(matrix)
[~,wide]=size(matrix);
row0s=zeros(1,wide);
matrix=[row0s;matrix;row0s];
[height,~]=size(matrix);
col0s=zeros(height,1);
matrix=[col0s,matrix,col0s];
end

% % 测试model
% disp('model');
% tic,
% %单位：微米
% %矩阵大小相关系数
% gridRatio=1/grid;
% %tool
% tl=zeros(25000*gridRatio,12000*gridRatio);
% tt=ones(25000*gridRatio,6000*gridRatio);
% tr=zeros(25000*gridRatio,12000*gridRatio);
% t=[tl tt tr];
% %workpiece
% wl=zeros(5000*gridRatio,5000*gridRatio);
% ww=ones(5000*gridRatio,20000*gridRatio);
% wr=zeros(5000*gridRatio,5000*gridRatio);
% w=[wl ww wr];
% %whole
% h1=ones(1,30000*gridRatio);% 此处1写死了
% spark=zeros(sparkDist*gridRatio,30000*gridRatio);% 放电间隙sparkDist至少3个网格
% matrix=[h1; t; spark; w; h1];
% matrix(:,1)=1;
% matrix(:,size(matrix,2))=1;
% toc


function [ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,gap,wideRatio )
%INITMODELMATRIX 均匀网格，几何建模，矩阵matrix
%   此处显示详细说明

% matrix_t=ones(8,4);
% matrix_w=ones(4,10);
% gap=4;
% wideRatio=1.5;

[height_t,wide_t]=size(matrix_t);
[height_w,wide_w]=size(matrix_w);

if(wide_t>=wide_w)
    disp("Error: wide_tool >= wide_workpiece");
end
wideMax=max(wide_t,wide_w);
wide=wideMax*wideRatio;

wide_left_w=floor((wideRatio-1)*wide_w/2);
left_w=zeros(height_w, wide_left_w);
right_w=zeros(height_w, wide - wide_w - wide_left_w);

workp=[left_w, matrix_w, right_w];
gapAndTool=zeros(gap+height_t, wide);
% height=height_t+gap+height_w;
% matrix=zeros(height,wide);
matrix=[gapAndTool; workp];
matrix(:,[1,end])=1;
matrix([1,end],:)=1;

%tool给matrix赋值1
startRow=1;
startCol=floor((wide-size(matrix_t,2))/2)+1;

matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;
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


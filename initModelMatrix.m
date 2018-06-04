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


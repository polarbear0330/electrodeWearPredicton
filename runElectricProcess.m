function [ matrix,startRow,c,errCode ] = runElectricProcess( matrix,matrix_t,startRow,startCol,c )
%RUNPROCESS One Cycle
%   all process simulation


% 【边界跟踪】
% （输入：形状矩阵；输出：边界点集-行列，且最先追踪输出tool的首边）
% 【真实edges合并处理】 + pde的boundaryCondition预处理
% （输入：boundary points；输出：edges顶点序列、边界条件）
% （注：二维图形的pde_geom矩阵，暂时不会三维矩阵的构造）
% 【电场计算】
% （输入：电极形状，边界条件；输出：~,矢量E，E的起点坐标，E的大小）
%  [~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE; %一个pde toolbox的GUI示例，优点是网格好
% 【获取放电点对】
% （输入：边界点行列，E，grid边长，左上顶点实际坐标；输出：放点电行列）
% 【蚀除】
% （输入：完整矩阵，两放点电，两蚀坑半径；输出：完整矩阵）
% 【直线进给】
% （输入：matrix_tool、matrix；输出：matrix）

disp('boundary trace:');
tic,[m,n] = boundaryTrace(matrix, c.showFlag);toc
disp('combine pts to edge:');
tic,[ edgePoints,edgeNums ] = pdeEdgeGeom( m,n,c.origin_left_up,c.grid );toc
disp('calculate E');
tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,c.showFlag);toc
disp('spark point:');
tic,[sparkpoint_tool,sparkpoint_workp,errCode_sparkPts] = sparkPoint(m,n,maxPoint',maxE,maxAbsE,c.grid,c.origin_left_up,c.sparkDist);toc
disp('erode:');
tic,[matrix] = erode(matrix,c.rt,c.rw,sparkpoint_tool,sparkpoint_workp);toc
disp('feed:');
tic,
if(maxAbsE < c.breakE)
    maxAbsE
    c.processDepth=c.processDepth-c.grid;
    [height_t,wide_t]=size(matrix_t);
    matrix_t=matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));
    startRow=startRow+1;
    matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;
end
toc

%展示结果
if (c.showFlag == 'showImage' | c.showFlag=='stepReslt')
    tic,
    disp('result pic:');
    toc
    tic,
    figure(5);
    imshow(matrix,'InitialMagnification','fit')
    title('蚀除结果');
    toc
end

errCode=0|errCode_sparkPts;
end


% 以下用于测试 testCase：
% matrix(sparkpoint_tool(1),sparkpoint_tool(2))%1
% matrix(sparkpoint_tool(1)+1,sparkpoint_tool(2))%0
% matrix(sparkpoint_tool(1),sparkpoint_tool(2)+1)%0
% matrix(sparkpoint_workp(1),sparkpoint_workp(2))%1
% matrix(sparkpoint_workp(1)-1,sparkpoint_workp(2))%0
% matrix(sparkpoint_workp(1)+1,sparkpoint_workp(2))%1
% size(matrix)
%--------------------------------------------------------------------------
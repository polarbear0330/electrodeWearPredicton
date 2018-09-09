function [ matrix_t,start_tool,matrix_w,start_workp,c,errCode ] = runElectricProcess( vertexes4,matrix_t,start_tool,matrix_w,start_workp,c )
%RUNPROCESS One Cycle
%   all process simulation
errCode=0;
errorCount=3;%允许错误次数
showFlag=c.showFlag;

% 【边界跟踪】
% （输入：形状矩阵；输出：边界点集-行列，且最先追踪输出tool的首边）
% 【真实edges合并处理】 + pde的boundaryCondition预处理
% （输入：boundary points；输出：edges顶点序列、边界条件）
% （注：二维图形的pde_geom矩阵，暂时不会三维矩阵的构造）
% 【电场计算】
% （输入：电极形状，边界条件；输出：~,矢量E，E的起点坐标，E的大小）
% 【直线进给】 + 提前结束此函数 【return】
% （输入：matrix_tool、matrix；输出：matrix）
%  [~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE; %一个pde toolbox的GUI示例，优点是网格好
% 【获取放电点对】
% （输入：边界点行列，E，grid边长，左上顶点实际坐标；输出：放点电行列）
% 【蚀除】
% （输入：完整矩阵，两放点电，两蚀坑半径；输出：完整矩阵）

% -------------------------------------------------------------------------
disp('boundary trace:');
tic,
[mnPoints_t] = boundaryTrace(matrix_t, showFlag, "tool");
[mnPoints_w] = boundaryTrace(matrix_w, showFlag, "workpiece");
toc
% -------------------------------------------------------------------------
disp('model transform:');
tic,
[ edgePoints,edgeNums ] = erodeModel2ElectricModel( vertexes4,mnPoints_t,mnPoints_w,start_tool,start_workp,c.origin_left_up,c.grid );
toc
% -------------------------------------------------------------------------
angleC = 0.5;
originC = [0, 0];
[ edgePoints ] = rotateC( edgePoints,edgeNums, angleC, originC );
while 1    
% -------------------------------------------------------------------------
    fprintf(2,'calculate E: \n');
    tic,
    % [~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,3-errorCount,showFlag);
    [maxAbsE,maxPoint,maxE] = electrostaticPDEmodel(edgePoints,edgeNums,3-errorCount,showFlag);
    toc
% -------------------------------------------------------------------------
    disp('feed:');
    tic,
    if(maxAbsE < c.breakE)
        maxAbsE
        if(maxAbsE < 0.3)
            fprintf(2,'场强过小(<0.3)，疑似tool与workpiece发生接触，等势了\n');
            fprintf(2,'请结合下方“未定义函数或变量 sparkpoint_tool”判断\n');
            errCode_feed = 1;
            errCode=errCode|errCode_feed;
            break % 此处可替换成return
        end
        c.processDepth=c.processDepth-c.grid;
        newline=ones(1,size(matrix_t,2));
        matrix_t=[newline;matrix_t];
%         [ matrix ] = refreshModelMatrix( matrix,matrix_t,matrix_w,start_tool,start_workp );
        return
    end
    toc
% -------------------------------------------------------------------------
    disp('spark point:');
    tic,
    [sparkpoint_workp,errCode_sparkPts1] = sparkPoint(mnPoints_w,start_workp,maxPoint',maxE,maxAbsE,c);
    % 工具电极在“电场模型”中发生了旋转，此处反向旋转场强矢量E，使得E与“蚀除模型”的工具电极处在同一坐标系下
    [ maxPoint_t ] = rotateC( maxPoint,[1], -angleC, originC );
    [ maxE_t ] = rotateC( maxE,[1], -angleC, originC );
    [sparkpoint_tool,errCode_sparkPts2] = sparkPoint(mnPoints_t,start_tool,maxPoint_t',maxE_t,maxAbsE,c);
    errCode_sparkPts = errCode_sparkPts1 & errCode_sparkPts2;
    toc
% -------------------------------------------------------------------------
    % 放电点无误 或 达到允许的错误次数上限，则break
    if(errCode_sparkPts==0 || errorCount<=0)
    % errorCount
        break;
    elseif(errorCount==1)
        errorCount
        showFlag = 'showImage';
    end
    
    errorCount=errorCount-1;
end
% -------------------------------------------------------------------------
disp('erode:');
tic,
[matrix_t,matrix_w] = erode(matrix_t,matrix_w,c.rt,c.rw,sparkpoint_tool,sparkpoint_workp,start_tool,start_workp);
[ matrix_t ] = debrisRemove( matrix_t );
[ matrix_w ] = debrisRemove( matrix_w );
toc
% -------------------------------------------------------------------------


%展示单步结果
if (showFlag == 'showImage' | showFlag=='stepReslt')
    tic,
    disp('result pic:');
    toc
    tic,
    figure(5);
    imshow(matrix,'InitialMagnification','fit')
    title('蚀除结果');
    toc
end

errCode=errCode|errCode_sparkPts;
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
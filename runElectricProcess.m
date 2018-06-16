function [ matrix,matrix_t,startRow,c,errCode ] = runElectricProcess( matrix,matrix_t,startRow,startCol,c )
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


disp('boundary trace:');
tic,[m,n] = boundaryTrace(matrix, showFlag);toc

disp('combine pts to edge:');
tic,[edgePoints,edgeNums] = pdeEdgeGeom( m,n,c.origin_left_up,c.grid );toc


while 1    
    fprintf(2,'calculate E: \n');
    tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,3-errorCount,showFlag);
    toc
    
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
        [height_t,wide_t]=size(matrix_t);%待修正
        matrix_t=matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));%待修正
        startRow=startRow+1;
        matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;%待修正
        return
    end
    toc
    
    disp('spark point:');
    tic,[sparkpoint_tool,sparkpoint_workp,errCode_sparkPts] = sparkPoint(m,n,maxPoint',maxE,maxAbsE,c.grid,c.origin_left_up,c.sparkDist);toc
    
    % 放电点无误 或 达到允许的错误次数上限，则break
    if(errCode_sparkPts==0 || errorCount<=0)
%         errorCount
        break;
    elseif(errorCount==1)
        errorCount
        showFlag = 'showImage';
    end
    
    errorCount=errorCount-1;
end

disp('erode:');
tic,[matrix,matrix_t] = erode(matrix,c.rt,c.rw,sparkpoint_tool,sparkpoint_workp,matrix_t,startRow,startCol);toc



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
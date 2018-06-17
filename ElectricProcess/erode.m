function [ matrix,matrix_t,matrix_w ] = erode( matrix,matrix_t,matrix_w,rt,rw,toolSparkP,workSparkP,start_tool,start_workp )
%ERODE 放电蚀除
%   输入：
% matrix - 完整矩阵，
% rt，tw - 蚀坑半径/grid，即网格宽度的倍数
% toolP,workP - 两放电矩阵点；
%   输出：
% matrix - 完整矩阵

%模拟输入，用于测试
% toolP=sparkpoint_tool;
% workP=sparkpoint_workp;

% toolSparkP
% workSparkP

%工件蚀除, 并防止先交于workp后交于一个错误的不在tool上的点
if(workSparkP(1)~=-1)
    r=round(rw);
    workSparkP=workSparkP-start_workp+[1,1];
    [ matrix_w ] = partErode( matrix_w,r,workSparkP );
end
if(toolSparkP(1)~=-1)
    r=round(rw);
    workSparkP=toolSparkP-start_workp+[1,1];
    [ matrix_w ] = partErode( matrix_w,r,workSparkP );
end

%石墨电极蚀除
if(toolSparkP(1)~=-1)
    r=round(rt);
    toolSparkP=toolSparkP-start_tool+[1,1];
    [ matrix_t ] = partErode( matrix_t,r,toolSparkP );
end

if(toolSparkP(1)~=-1 || workSparkP(1)~=-1)
    [ matrix ] = refreshModelMatrix( matrix,matrix_t,matrix_w,start_tool,start_workp );
end
end


function [ matrix ] = partErode( matrix,r,sparkPoint )
%以startP为原点，sparkPoint的相对坐标为relativeCenter

relativeCenter=[r,r];
startP=sparkPoint-relativeCenter; %左上角的点（r要不要减1？）
for row=0:2*r
    for col=0:2*r
        vector=[row,col]-relativeCenter;
        lengthV=normest(vector);
        if lengthV <= r && isInside(startP+[row,col], matrix)
%             disp('测试工件erode')
            matrix(startP(1)+row,startP(2)+col)=0;
        end
    end
end
end

function [inside] = isInside (point, matrix)

inside = 0;
[row, column]=size(matrix);
if point(1)>=1 && point(1)<=row && point(2)>=1 && point(2)<=column
    inside=1;
end
end

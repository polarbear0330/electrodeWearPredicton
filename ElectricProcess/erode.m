function [ matrix ] = erode( matrix,rt,rw,toolSparkP,workSparkP )
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

%石墨电极蚀除
if(toolSparkP(1)~=-1)
    r=round(rt);
    relativeCenter=[r,r];
    [ matrix ] = partErode( matrix,r,toolSparkP,relativeCenter );
end

%工件蚀除
if(workSparkP(1)~=-1)
    r=round(rw);
    relativeCenter=[0,r];
    [ matrix ] = partErode( matrix,r,workSparkP,relativeCenter );
end
end


function [ matrix ] = partErode( matrix,r,sparkPoint,relativeCenter )
%以startP为原点，sparkPoint的相对坐标为relativeCenter

startP=sparkPoint-relativeCenter; %左上角的点（r要不要减1？）
for row=0:r
    for col=0:2*r
        vector=[row,col]-relativeCenter;
        lengthV=normest(vector);
        if lengthV <= r
            matrix(startP(1)+row,startP(2)+col)=0;
        end
    end
end
end

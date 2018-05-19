function [ matrix ] = erode( matrix,rt,rw,toolP,workP )
%ERODE 放电蚀除
%   输入：
% matrix - 完整矩阵，
% rt，tw - 蚀坑半径/grid，即网格宽度的倍数
% toolP,workP - 两放电矩阵点；
%   输出：
% matrix - 完整矩阵

% toolP=sparkpoint_tool;
% workP=sparkpoint_workp;

r=round(rt);%四舍五入
startP=toolP-[r,r];%左上角的点（r要不要减1？）
for row=0:r
    for col=0:2*r
        vector=[row,col]-[r,r];
        lengthV=normest(vector)
        if lengthV <= r
            matrix(startP(1)+row,startP(2)+col)=0;
        end
    end
end

r=round(rw);%四舍五入
startP=workP-[0,r];%（r要不要减1？）
for row=0:r
    for col=0:2*r
        vector=[row,col]-[0,r];
        lengthV=normest(vector)
        if lengthV <= r
            matrix(startP(1)+row,startP(2)+col)=0;
        end
    end
end


end


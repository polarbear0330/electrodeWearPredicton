function [ edgePoints,edgeNums ] = pdeEdgeGeom( mnPoints,start,origin_left_up,grid )
%PDEEDGEGEOM edges生成、pde的boundary condition预处理
% 1.矩阵点连接成边，相同斜率的边是同一个边
% 2.所有边内缩
% 3.输出：带有边界条件的边edges的编号序列、edges顶点

m=mnPoints(:,1);
n=mnPoints(:,2);

%坐标系变换
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid + start(1) + origin(1);
y=(m-1)*grid*(-1) + start(2) + origin(2);

[prePoints,edgeNums] = boundaryPts2Edges (x,y);
[edgePoints] = insideOffsetProcess (prePoints,grid);

end

function [prePoints,edgeNums] = boundaryPts2Edges (x,y)
%点连接成边，相同斜率的边是同一个边

oldPoint=[x(1);y(1)];
prePoints=oldPoint;
edgeNums=[];%与边界跟踪起始位置存在耦合
curEdgeNum=0;%与边界跟踪起始位置存在耦合
count=1;%与边界跟踪方向存在耦合
for i=2:length(x)
    if(x(i)~=oldPoint(1) && y(i)~=oldPoint(2))%斜率只为0、竖直两种
        curEdgeNum=curEdgeNum+1;
        oldPoint=[x(i-1);y(i-1)];
        prePoints=[prePoints, oldPoint];
        %count==1时，curEdge是tool的边
        if(count)
            if(y(i-1)==y(1))
                count=0;
            end
            edgeNums=[edgeNums,curEdgeNum];
        end
    end
end
% prePoints=[1 2 3 4
%     5 6 7 8];
end

function [points] = insideOffsetProcess (points,grid)
%向内缩小0.5grid
%适用：相邻两边都互相垂直

for i=1:size(points,2)
    j=i+1;
    if(j>size(points,2))
        j=1;
    end
    dx=points(1,j)-points(1,i);
    dy=points(2,j)-points(2,i);
    if(dx==0)
        dp=[dy/abs(dy);0]*grid/2;
    else
        dp=[0;-dx/abs(dx)]*grid/2;
    end
    points(:,i)=points(:,i)+dp;
    points(:,j)=points(:,j)+dp;
end
end
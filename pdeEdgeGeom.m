function [ geom_dl,edgeNums ] = pdeEdgeGeom( m,n,origin_left_up,grid )
%PDEEDGEGEOM edges生成、pde预处理
% 1.矩阵点连接成边，相同斜率的边是同一个边 
% 2.构建 geom（edges） 矩阵
% 3.输出带有边界条件的边edges的编号序列
%   此处显示详细说明


%坐标系变换
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid+origin(1);
y=(m-1)*grid*(-1)+origin(2);

[prePoints,edgeNums] = boundaryPts2Edges (x,y);
[points] = insideOffsetProcess (prePoints);


%可以输出points，放到pde里面
startPts=points; % 列：1 ~ end-1
endPts=[points(:,2:end), points(:,1)]; % 列：2 ~ end
n=size(points,2); % 点数 - 列数
geom_dl=[2*ones(1,n);startPts(1,:);endPts(1,:);startPts(2,:);endPts(2,:);ones(1,n);zeros(1,n)];
end

function [prePoints,edgeNums] = boundaryPts2Edges (x,y)
%点连接成边，相同斜率的边是同一个边

oldPoint=[x(1);y(1)];
prePoints=oldPoint;
for i=2:length(x)
    if()
        prePoints=[prePoints, oldPoint];
        oldPoint=[x(i);y(i)];
    end
end

prePoints=[1 2 3 4
    5 6 7 8];
end

function [points] = insideOffsetProcess (prePoints)
%向内缩小0.5grid


end
function [ edgePoints,edgeNums ] = erodeModel2ElectricModel( vertexes4,mnPoints_t,mnPoints_w,start_tool,start_workp,origin_left_up,grid )
%ERODEMODEL2ELECTRICMODEL 此处显示有关此函数的摘要
%   此处显示详细说明

% [edgePoints,edgeNums] = pdeEdgeGeom( m,n,origin_left_up,grid );
[edgePoints_t,~] = pdeEdgeGeom( mnPoints_t,start_tool,origin_left_up,grid );
[edgePoints_w,~] = pdeEdgeGeom( mnPoints_w,start_workp,origin_left_up,grid );

edgePoints=[edgePoints_t,vertexes4(:,[1,2]),edgePoints_w,vertexes4(:,[3,4])];

edgeNums=1:size(edgePoints_t,2)-1;
end



function [ edgePoints,empty ] = pdeEdgeGeom( mnPoints,start,origin_left_up,grid )
%PDEEDGEGEOM edges生成
% 1.矩阵点连接成边，相同斜率的边是同一个边
% 3.输出：edges顶点
empty = 0;
disp('简化边界 - 斜率修正');

m=mnPoints(:,1);
n=mnPoints(:,2);

%坐标系变换
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid + start(1) + origin(1);
y=(m-1)*grid*(-1) + start(2) + origin(2);

oldAngle=atan2(y(2) - y(1), x(2) - x(1));%初始值
oldPoint=[x(1);y(1)];
edgePoints=oldPoint;
% temp=[];
for i=2:length(x)
    deltax = x(i) - x(i - 1);
    deltay = y(i) - y(i - 1);
    angle = atan2(deltay, deltax);
    if(angle ~= oldAngle)
%         temp=[temp;oldAngle];
        oldPoint=[x(i-1);y(i-1)];
        edgePoints=[edgePoints, oldPoint];
        oldAngle = angle;
    end
end
% temp
hasOverlap=1;
while hasOverlap
    [ edgePoints,hasOverlap ] = rmOverlapLines(edgePoints);
%     disp("rm overlap lines");
end

[edgePoints] = fixSubGraph(edgePoints);

% prePoints=[1 2 3 4
%     5 6 7 8];
end


function [ edgePointsProcessed,hasOverlap ] = rmOverlapLines(edgePoints)
hasOverlap=0;

x=edgePoints(1,:);
y=edgePoints(2,:);

oldAngle=atan2(y(2) - y(1), x(2) - x(1));%初始值
edgePointsProcessed=[x(1);y(1)];
% angles=[];
for i=3:length(x)
    deltax = x(i) - x(i - 1);
    deltay = y(i) - y(i - 1);
    angle = atan2(deltay, deltax);
    if(angle + pi == oldAngle || oldAngle + pi == angle)
        hasOverlap=1;
    else
        prevPoint=[x(i-1);y(i-1)];
        if(isSamePoint(prevPoint,edgePointsProcessed(:,end)))
%             disp("overlap point");
        else
            edgePointsProcessed=[edgePointsProcessed,prevPoint];
        end
    end
    oldAngle=angle;
end
edgePointsProcessed=[edgePointsProcessed,[x(end);y(end)]];
end


function [edgePointsProcessed] = fixSubGraph(edgePoints)

% [edgePointsProcessed] = rmRepeatedPoints(edgePoints);
% [edgePointsProcessed] = rmSubGraph(edgePoints);
[edgePointsProcessed] = rmPointsOnPolygon(edgePoints);

end

function [edgePointsProcessed] = rmRepeatedPoints(edgePoints)
% 方法一：去除重复点。尝试结果：仍然会有相交点，交于内部。因此，此段代码仅留作备用
[sortedEdgePoints,location] = unique(edgePoints','rows','first');
res = sortrows([location,sortedEdgePoints]);
edgePointsProcessed=(res(:,2:size(res,2)))';
end

function [edgePointsProcessed] = rmSubGraph(edgePoints)
% 方法二：直接去除重复点之间的线段，即，去除闭合的subgraph
length=size(edgePoints,2);
edgePoints=edgePoints';
edgePointsProcessed=edgePoints(1,:);
for i=2:length
    row=edgePoints(i,:);
    [~,lib]=ismember(row,edgePointsProcessed,'rows');
    if lib
        edgePointsProcessed(lib+1:end,:)=[];
    else
        edgePointsProcessed=[edgePointsProcessed;row];
    end
end
edgePointsProcessed=edgePointsProcessed';
end

function [edgePointsProcessed] = rmPointsOnPolygon(edgePoints)
% 判断点是否在多边形上，若在，则删除此点

% 多边形最后一条线段会造成一些误差

disp('rm Points On Polygon');
xv=edgePoints(1,1:3);
xv=xv';
yv=edgePoints(2,1:3);
yv=yv';

length=size(edgePoints,2);
for i=4:length
    xi=edgePoints(1,i);
    yi=edgePoints(2,i);
    [~,on] = inpolygon(xi,yi,xv,yv);
    if on
        disp('on polygon');
    else
        xv=[xv;xi];
        yv=[yv;yi];
    end
end
edgePointsProcessed=[xv';yv'];

end





















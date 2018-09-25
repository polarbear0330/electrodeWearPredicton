function [ edgePoints,edgeNums ] = erodeModel2ElectricModel( vertexes4,mnPoints_t,mnPoints_w,start_tool,start_workp,origin_left_up,grid )
%ERODEMODEL2ELECTRICMODEL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% [edgePoints,edgeNums] = pdeEdgeGeom( m,n,origin_left_up,grid );
[edgePoints_t,~] = pdeEdgeGeom( mnPoints_t,start_tool,origin_left_up,grid );
[edgePoints_w,~] = pdeEdgeGeom( mnPoints_w,start_workp,origin_left_up,grid );

edgePoints=[edgePoints_t,vertexes4(:,[1,2]),edgePoints_w,vertexes4(:,[3,4])];

edgeNums=1:size(edgePoints_t,2)-1;
end



function [ edgePoints,empty ] = pdeEdgeGeom( mnPoints,start,origin_left_up,grid )
%PDEEDGEGEOM edges����
% 1.��������ӳɱߣ���ͬб�ʵı���ͬһ����
% 3.�����edges����
empty = 0;
disp('�򻯱߽� - б������');

m=mnPoints(:,1);
n=mnPoints(:,2);

%����ϵ�任
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid + start(1) + origin(1);
y=(m-1)*grid*(-1) + start(2) + origin(2);

oldAngle=atan2(y(2) - y(1), x(2) - x(1));%��ʼֵ
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
    [ edgePoints,hasOverlap ] = rmOverlap(edgePoints);
    disp("rm overlap lines");
end

% prePoints=[1 2 3 4
%     5 6 7 8];
end


function [ edgePointsProcessed,hasOverlap ] = rmOverlap(edgePoints)
hasOverlap=0;

x=edgePoints(1,:);
y=edgePoints(2,:);

oldAngle=atan2(y(2) - y(1), x(2) - x(1));%��ʼֵ
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
            disp("overlap point");
        else
            edgePointsProcessed=[edgePointsProcessed,prevPoint];
        end
    end
    oldAngle=angle;
end
edgePointsProcessed=[edgePointsProcessed,[x(end);y(end)]];
end






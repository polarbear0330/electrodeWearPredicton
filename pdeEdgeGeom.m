function [ geom_dl,edgeNums ] = pdeEdgeGeom( m,n,origin_left_up,grid )
%PDEEDGEGEOM edges���ɡ�pdeԤ����
% 1.��������ӳɱߣ���ͬб�ʵı���ͬһ���� 
% 2.���� geom��edges�� ����
% 3.������б߽������ı�edges�ı������
%   �˴���ʾ��ϸ˵��


%����ϵ�任
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid+origin(1);
y=(m-1)*grid*(-1)+origin(2);

[prePoints,edgeNums] = boundaryPts2Edges (x,y);
[points] = insideOffsetProcess (prePoints);


%�������points���ŵ�pde����
startPts=points; % �У�1 ~ end-1
endPts=[points(:,2:end), points(:,1)]; % �У�2 ~ end
n=size(points,2); % ���� - ����
geom_dl=[2*ones(1,n);startPts(1,:);endPts(1,:);startPts(2,:);endPts(2,:);ones(1,n);zeros(1,n)];
end

function [prePoints,edgeNums] = boundaryPts2Edges (x,y)
%�����ӳɱߣ���ͬб�ʵı���ͬһ����

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
%������С0.5grid


end
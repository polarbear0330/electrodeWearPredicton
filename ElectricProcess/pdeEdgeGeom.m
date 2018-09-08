function [ edgePoints,edgeNums ] = pdeEdgeGeom( mnPoints,start,origin_left_up,grid )
%PDEEDGEGEOM edges���ɡ�pde��boundary conditionԤ����
% 1.��������ӳɱߣ���ͬб�ʵı���ͬһ����
% 2.���б�����
% 3.��������б߽������ı�edges�ı�����С�edges����

m=mnPoints(:,1);
n=mnPoints(:,2);

%����ϵ�任
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid + start(1) + origin(1);
y=(m-1)*grid*(-1) + start(2) + origin(2);

[prePoints,edgeNums] = boundaryPts2Edges (x,y);
[edgePoints] = insideOffsetProcess (prePoints,grid);

end

function [prePoints,edgeNums] = boundaryPts2Edges (x,y)
%�����ӳɱߣ���ͬб�ʵı���ͬһ����

oldPoint=[x(1);y(1)];
prePoints=oldPoint;
edgeNums=[];%��߽������ʼλ�ô������
curEdgeNum=0;%��߽������ʼλ�ô������
count=1;%��߽���ٷ���������
for i=2:length(x)
    if(x(i)~=oldPoint(1) && y(i)~=oldPoint(2))%б��ֻΪ0����ֱ����
        curEdgeNum=curEdgeNum+1;
        oldPoint=[x(i-1);y(i-1)];
        prePoints=[prePoints, oldPoint];
        %count==1ʱ��curEdge��tool�ı�
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
%������С0.5grid
%���ã��������߶����ഹֱ

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
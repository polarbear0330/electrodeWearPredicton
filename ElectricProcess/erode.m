function [ matrix,matrix_t,matrix_w ] = erode( matrix,matrix_t,matrix_w,rt,rw,toolSparkP,workSparkP,start_tool,start_workp )
%ERODE �ŵ�ʴ��
%   ���룺
% matrix - ��������
% rt��tw - ʴ�Ӱ뾶/grid���������ȵı���
% toolP,workP - ���ŵ����㣻
%   �����
% matrix - ��������

%ģ�����룬���ڲ���
% toolP=sparkpoint_tool;
% workP=sparkpoint_workp;

% toolSparkP
% workSparkP

%����ʴ��, ����ֹ�Ƚ���workp����һ������Ĳ���tool�ϵĵ�
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

%ʯī�缫ʴ��
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
%��startPΪԭ�㣬sparkPoint���������ΪrelativeCenter

relativeCenter=[r,r];
startP=sparkPoint-relativeCenter; %���Ͻǵĵ㣨rҪ��Ҫ��1����
for row=0:2*r
    for col=0:2*r
        vector=[row,col]-relativeCenter;
        lengthV=normest(vector);
        if lengthV <= r && isInside(startP+[row,col], matrix)
%             disp('���Թ���erode')
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

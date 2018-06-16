function [ matrix,matrix_t ] = erode( matrix,rt,rw,toolSparkP,workSparkP,matrix_t,startRow,startCol )
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
    [ matrix ] = partErode( matrix,r,workSparkP );
end
if(toolSparkP(1)~=-1)
    r=round(rw);
    [ matrix ] = partErode( matrix,r,toolSparkP );
end

%ʯī�缫ʴ��
if(toolSparkP(1)~=-1)
    r=round(rt);
    [height_t,wide_t]=size(matrix_t);%������
    toolSparkP=toolSparkP-[startRow,startCol]+[1,1];
    [ matrix_t ] = partErode( matrix_t,r,toolSparkP );
    
%     size(matrix_t)
%     test=matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));
%     [test1,test2]=size(test)
    
    matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;%������
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

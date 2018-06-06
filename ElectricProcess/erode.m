function [ matrix ] = erode( matrix,rt,rw,toolSparkP,workSparkP )
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

%ʯī�缫ʴ��
if(toolSparkP(1)~=-1)
    r=round(rt);
    relativeCenter=[r,r];
    [ matrix ] = partErode( matrix,r,toolSparkP,relativeCenter );
end

%����ʴ��
if(workSparkP(1)~=-1)
    r=round(rw);
    relativeCenter=[0,r];
    [ matrix ] = partErode( matrix,r,workSparkP,relativeCenter );
end
end


function [ matrix ] = partErode( matrix,r,sparkPoint,relativeCenter )
%��startPΪԭ�㣬sparkPoint���������ΪrelativeCenter

startP=sparkPoint-relativeCenter; %���Ͻǵĵ㣨rҪ��Ҫ��1����
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

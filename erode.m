function [ matrix ] = erode( matrix,rt,rw,toolP,workP )
%ERODE �ŵ�ʴ��
%   ���룺
% matrix - ��������
% rt��tw - ʴ�Ӱ뾶/grid���������ȵı���
% toolP,workP - ���ŵ����㣻
%   �����
% matrix - ��������

% toolP=sparkpoint_tool;
% workP=sparkpoint_workp;

r=round(rt);%��������
startP=toolP-[r,r];%���Ͻǵĵ㣨rҪ��Ҫ��1����
for row=0:r
    for col=0:2*r
        vector=[row,col]-[r,r];
        lengthV=normest(vector)
        if lengthV <= r
            matrix(startP(1)+row,startP(2)+col)=0;
        end
    end
end

r=round(rw);%��������
startP=workP-[0,r];%��rҪ��Ҫ��1����
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


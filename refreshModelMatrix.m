function [ whole ] = refreshModelMatrix( whole,part,origin_start )
%REFRESHMODELMATRIX ����ģ��
%   ��ʴ������matrix_tool��part�����½���matrix��whole����

% origin_start=[m,n]
startRow=origin_start(1);
startCol=origin_start(2);
[height_t,wide_t]=size(part);

% �ĳ�ֻ=1ʱ����ֵ�����򲻸�ֵ����ֹ0��ֵ����
whole(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=part;

end


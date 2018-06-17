function [ whole ] = refreshModelMatrix( whole,tool,workp,start_tool,start_workp )
%REFRESHMODELMATRIX ����ģ��
%   ��ʴ������matrix_tool��part�����½���matrix��whole����

whole(:,:)=0;
whole(:,[1,end])=1;
whole([1,end],:)=1;

[ whole ] = refreshPart( whole,tool,start_tool );
[ whole ] = refreshPart( whole,workp,start_workp );

end

function [ whole ] = refreshPart( whole,part,origin_start )

% whole=[zeros(5,10);ones(1,10)]
% part=[ones(5,3);zeros(1,3)]
% origin_start=[1,3];

% origin_start=[m,n]
startRow=origin_start(1);
startCol=origin_start(2);
[height_t,wide_t]=size(part);

% �ĳ�ֻ=1ʱ����ֵ�����򲻸�ֵ����ֹ0��ֵ����
whole(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=part;
% pos= find(part==1);
% pos
% prevPart=whole(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));
end
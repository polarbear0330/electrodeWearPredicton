function [ whole ] = refreshModelMatrix( whole,part,origin_start )
%REFRESHMODELMATRIX 更新模型
%   将蚀除过的matrix_tool（part）更新进总matrix（whole）中

% origin_start=[m,n]
startRow=origin_start(1);
startCol=origin_start(2);
[height_t,wide_t]=size(part);

% 改成只=1时，赋值，否则不赋值，防止0赋值错误
whole(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=part;

end


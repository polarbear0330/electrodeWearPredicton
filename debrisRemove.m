function [ matrix_x ] = debrisRemove( matrix_x )
%DEBRISREMOVE 清除仿真蚀除后产生的残渣
%   目的：防止短路
%   算法：判断方式：上下左右皆为0，则为残渣
%   搜索[*0*;010;*0*]

% matrix_x = matrix_t
left = zeros(size(matrix_x, 1), 1);
B = [left matrix_x];
bottom = zeros(2, size(B, 2));
B = [B; bottom];

index = find(B(1:end-2,2:end-1)==0 & B(2:end-1,2:end-1) == 1 & B(3:end,2:end-1) == 0 ...
& B(2:end-1,1:end-2)==0 & B(2:end-1,2:end-1) == 1 & B(2:end-1,3:end) == 0);

matrix_x(index + 1)=0;
end


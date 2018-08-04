function [ matrix_x ] = debrisRemove( matrix_x )
%DEBRISREMOVE �������ʴ��������Ĳ���
%   Ŀ�ģ���ֹ��·
%   �㷨���жϷ�ʽ���������ҽ�Ϊ0����Ϊ����
%   ����[*0*;010;*0*]

% matrix_x = matrix_t
left = zeros(size(matrix_x, 1), 1);
B = [left matrix_x];
bottom = zeros(2, size(B, 2));
B = [B; bottom];

index = find(B(1:end-2,2:end-1)==0 & B(2:end-1,2:end-1) == 1 & B(3:end,2:end-1) == 0 ...
& B(2:end-1,1:end-2)==0 & B(2:end-1,2:end-1) == 1 & B(2:end-1,3:end) == 0);

matrix_x(index + 1)=0;
end


function [ isSame ] = isSamePoint( point1,point2 )
%ISSAMEPOINT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% point1=[1,2,3];
% point2=[1,2,3.1];
isSame=1;
if size(point1)==size(point2)
    count = max(size(point1,1),size(point1,2));
    for i=1:count
        if(abs(point1(i) - point2(i)) >= 1)%˵����ͬһ���㡣������1umӦ���㹻��
            isSame=0;
        end
    end
else
    fprintf(2, '\n isSamePoint��������ά�Ȳ�һ�� \n\n');
end


end


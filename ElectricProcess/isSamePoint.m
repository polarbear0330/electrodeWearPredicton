function [ isSame ] = isSamePoint( point1,point2 )
%ISSAMEPOINT 此处显示有关此函数的摘要
%   此处显示详细说明

% point1=[1,2,3];
% point2=[1,2,3.1];
isSame=1;
if size(point1)==size(point2)
    count = max(size(point1,1),size(point1,2));
    for i=1:count
        if(abs(point1(i) - point2(i)) >= 1)%说明是同一个点。误差给个1um应该足够了
            isSame=0;
        end
    end
else
    fprintf(2, '\n isSamePoint：两个点维度不一致 \n\n');
end


end


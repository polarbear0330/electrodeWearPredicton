function [ edgePoints ] = rotateC( edgePoints,edgeNums, angleC, originC )
%ROTATEC 此处显示有关此函数的摘要
%   此处显示详细说明

% edgePoints: 更改tool上的所有点
% edgeNums：不用改，辅助修改 edgePoints
% angleC：协调好X、Y、C的进给比例，角度制
% angleC：C轴当前值，刚体旋转角度，默认初始值为0
% -------------------------------------------

% 测试数据
% % edgePoints = [
% %     1 1 3 3
% %     2 0 0 7];
% % angleC = 0.5;
% % originC = [0, 0];
% % edgeNums = [1, 2];

angleC = angleC / pi;
for i=edgeNums
    delta_x = edgePoints(1,i)-originC(1);
    delta_y = edgePoints(2,i)-originC(2);
    length = sqrt(delta_x^2 + delta_y^2);
    angleStart = atan2(delta_y, delta_x);%质点的起始角度
    angleEnd = angleC - 0 + angleStart;%该点旋转后的角度
    edgePoints(1,i) = length * cos(angleEnd) + originC(1);
    edgePoints(2,i) = length * sin(angleEnd) + originC(2);
end

end








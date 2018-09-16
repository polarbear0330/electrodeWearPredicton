function [ edgePoints ] = rotateC( edgePoints,edgeNums, angleC, originC )
%ROTATEC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% edgePoints: ����tool�ϵ����е�
% edgeNums�����øģ������޸� edgePoints
% angleC��Э����X��Y��C�Ľ����������Ƕ���
% angleC��C�ᵱǰֵ��������ת�Ƕȣ�Ĭ�ϳ�ʼֵΪ0
% -------------------------------------------

% ��������
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
    angleStart = atan2(delta_y, delta_x);%�ʵ����ʼ�Ƕ�
    angleEnd = angleC - 0 + angleStart;%�õ���ת��ĽǶ�
    edgePoints(1,i) = length * cos(angleEnd) + originC(1);
    edgePoints(2,i) = length * sin(angleEnd) + originC(2);
end

end








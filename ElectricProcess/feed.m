function [ feedParas,xyOriginPair ] = feed( feedParas,xyOriginPair )
%FEED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

codeG=feedParas.codeG;
rowG=feedParas.rowG;
increment=feedParas.increment;
start_tool=xyOriginPair.start_tool;

% lineG����ǰִ�е���G���������С���֪С�յ㡢���յ�
% codeG��G����
% end����ǰ��G������յ�

if isSamePoint(start_tool,codeG(rowG,:))
    fprintf(2, '\n ���ԣ�����ʱ����ȡ���µ�һ��G���� \n\n');
%     start_tool(1) - codeG(rowG,1) < 1 %˵����ͬһ���㡣������1umӦ���㹻��
    start_tool = codeG(rowG,:) %�����ۻ����
    increment=feedInterval(codeG,rowG,rowG+1);
    rowG=rowG+1;
end

start_tool = start_tool + increment

feedParas.codeG=codeG;
feedParas.rowG=rowG;
feedParas.increment=increment;
xyOriginPair.start_tool=start_tool;
end




function [ increment ] = feedInterval( codeG,row1,row2 )
coord1 = codeG(row1,:);
coord2 = codeG(row2,:);
%�õ�λ������������xy������,ÿ�ν����������5um����
minLimitLen=5;%um

delta=coord2-coord1;
length=sqrt(delta(1)^2+delta(2)^2);

if length<=minLimitLen
    increment = delta;
else
    count = ceil(length / minLimitLen);
%     feedLen = length / count;
    increment = delta / count;
end

if abs(increment(3)) >= 0.01
    count = ceil(abs(increment(3)) / 0.01);
    increment = increment / count;
end

end




% %     if(maxAbsE < c.breakE)
% %         maxAbsE
% %         if(maxAbsE < 0.3)
% %             fprintf(2,'��ǿ��С(<0.3)������tool��workpiece�����Ӵ���������\n');
% %             fprintf(2,'�����·���δ���庯������� sparkpoint_tool���ж�\n');
% %             errCode_feed = 1;
% %             errCode=errCode|errCode_feed;
% %             break % �˴����滻��return
% %         end
% %         c.processDepth=c.processDepth-c.grid;
% %         newline=ones(1,size(matrix_t,2));
% %         matrix_t=[newline;matrix_t];
% % %         [ matrix ] = refreshModelMatrix( matrix,matrix_t,matrix_w,start_tool,start_workp );
% %         return
% %     end
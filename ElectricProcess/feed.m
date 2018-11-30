function [ feedParas,xyOriginPair ] = feed( feedParas,xyOriginPair )
%FEED 此处显示有关此函数的摘要
%   此处显示详细说明

codeG=feedParas.codeG;
rowG=feedParas.rowG;
increment=feedParas.increment;
start_tool=xyOriginPair.start_tool;

% lineG：当前执行到的G代码所在行。可知小终点、大终点
% codeG：G代码
% end：当前行G代码的终点

if isSamePoint(start_tool,codeG(rowG,:))
    fprintf(2, '\n 测试：进给时，读取了新的一行G代码 \n\n');
%     start_tool(1) - codeG(rowG,1) < 1 %说明是同一个点。误差给个1um应该足够了
    start_tool = codeG(rowG,:) %消除累积误差
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
%用单位弧长法，处理xy进给量,每次进给弧长最大5um左右
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
% %             fprintf(2,'场强过小(<0.3)，疑似tool与workpiece发生接触，等势了\n');
% %             fprintf(2,'请结合下方“未定义函数或变量 sparkpoint_tool”判断\n');
% %             errCode_feed = 1;
% %             errCode=errCode|errCode_feed;
% %             break % 此处可替换成return
% %         end
% %         c.processDepth=c.processDepth-c.grid;
% %         newline=ones(1,size(matrix_t,2));
% %         matrix_t=[newline;matrix_t];
% % %         [ matrix ] = refreshModelMatrix( matrix,matrix_t,matrix_w,start_tool,start_workp );
% %         return
% %     end
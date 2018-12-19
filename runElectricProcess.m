function [ matrixPair,xyOriginPair,feedParas,c,errCode ] = runElectricProcess( vertexes4,matrixPair,xyOriginPair,feedParas,c )
%RUNPROCESS One Cycle
%   all process simulation
errCode=0;
errorCount=3;%����������
showFlag=c.showFlag;

matrix_t=matrixPair.matrix_t;
matrix_w=matrixPair.matrix_w;
start_tool=xyOriginPair.start_tool;
start_workp=xyOriginPair.start_workp;

% showFlag ='showImage'

% ���߽���١�
% �����룺��״����������߽�㼯-���У�������׷�����tool���ױߣ�
% ����ʵedges�ϲ����� + pde��boundaryConditionԤ����
% �����룺boundary points�������edges�������С��߽�������
% ��ע����άͼ�ε�pde_geom������ʱ������ά����Ĺ��죩
% ���糡���㡿
% �����룺�缫��״���߽������������~,ʸ��E��E��������꣬E�Ĵ�С��
% ��ֱ�߽����� + ��ǰ�����˺��� ��return��
% �����룺matrix_tool��matrix�������matrix��
%  [~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE; %һ��pde toolbox��GUIʾ�����ŵ��������
% ����ȡ�ŵ��ԡ�
% �����룺�߽�����У�E��grid�߳������϶���ʵ�����ꣻ������ŵ�����У�
% ��ʴ����
% �����룺�����������ŵ�磬��ʴ�Ӱ뾶���������������

% -------------------------------------------------------------------------
disp('boundary trace:');
tic,
[mnPoints_t] = boundaryTrace(matrix_t, showFlag, "tool");
[mnPoints_w] = boundaryTrace(matrix_w, showFlag, "workpiece");
toc
% -------------------------------------------------------------------------
disp('model transform:');
tic,
[ edgePoints,edgeNums ] = erodeModel2ElectricModel( vertexes4,mnPoints_t,mnPoints_w,start_tool,start_workp,c.origin_left_up,c.grid );
toc
% -------------------------------------------------------------------------
angleC = start_tool(3);
% originC = start_tool(1,[1,2])+[-1106,9875]; %����������������start_toolΪԭ�㣬��ת���������꣨���ǵ缫�ˣ�
originC = start_tool(1,[1,2])+[-1683,9875]; %����������������start_toolΪԭ�㣬��ת���������꣨���ǵ缫�ˣ�
[ edgePoints ] = rotateC( edgePoints,[edgeNums,edgeNums(end)+1], angleC, originC );%����tool��3���ߣ�����3+1=4��������Ҫ��ת
while 1
% -------------------------------------------------------------------------
    fprintf(2,'calculate E: \n');
    tic,
%     edgePoints=edgePoints+[-10212.5;30112.5];%��ʵ���������������ͬһ��ͼ��
    [~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,3-errorCount,showFlag);
%     [maxAbsE,maxPoint,maxE] = electrostaticPDEmodel(edgePoints,edgeNums,3-errorCount,showFlag);
    toc
% -------------------------------------------------------------------------
    disp('feed:');
    tic,
    if(maxAbsE < c.breakE)
        maxAbsE
%         ���缫����Զʱ����һ����Ҫע�͵�START
%         if(maxAbsE < 0.3)
%             fprintf(2,'��ǿ��С(<0.3)������tool��workpiece�����Ӵ���������\n');
%             fprintf(2,'�����·���δ���庯������� sparkpoint_tool���ж�\n');
%             errCode_feed = 1;
%             errCode=errCode|errCode_feed;
%             feedParas.increment
%             break % �˴����滻��return
%         end
%         ���缫����Զʱ����һ����Ҫע�͵�END

%         c.processDepth=c.processDepth-c.grid;
%         newline=ones(1,size(matrix_t,2));
%         matrix_t=[newline;matrix_t];
%         [ matrix ] = refreshModelMatrix( matrix,matrix_t,matrix_w,start_tool,start_workp );
        [ feedParas,xyOriginPair ] = feed( feedParas,xyOriginPair );
        return
    end
    toc
% -------------------------------------------------------------------------
    disp('spark point:');
    tic,
    [sparkpoint_workp,errCode_sparkPts1] = sparkPoint(mnPoints_w,start_workp,maxPoint',maxE,maxAbsE,c);
    % ���ߵ缫�ڡ��糡ģ�͡��з�������ת���˴�������ת��ǿʸ��E��ʹ��E�롰ʴ��ģ�͡��Ĺ��ߵ缫����ͬһ����ϵ��
    [ maxPoint_t ] = rotateC( maxPoint,[1], -angleC, originC );
    [ maxE_t ] = rotateC( maxE,[1], -angleC, [0,0] );
    [sparkpoint_tool,errCode_sparkPts2] = sparkPoint(mnPoints_t,start_tool,maxPoint_t',maxE_t,maxAbsE,c);
    errCode_sparkPts = errCode_sparkPts1 & errCode_sparkPts2;
    toc
% -------------------------------------------------------------------------
    % �ŵ������ �� �ﵽ����Ĵ���������ޣ���break
    if(errCode_sparkPts==0 || errorCount<=0)
    % errorCount
        break;
    elseif(errorCount==1)
        errorCount
        showFlag = 'showImage';
    end
    
    errorCount=errorCount-1;
end
% -------------------------------------------------------------------------
disp('erode:');
tic,
[matrix_t] = erode(matrix_t,c.rt,sparkpoint_tool);
[matrix_w] = erode(matrix_w,c.rw,sparkpoint_workp);
% [matrix_t,matrix_w] = erode(matrix_t,matrix_w,c.rt,c.rw,sparkpoint_tool,sparkpoint_workp,start_tool,start_workp);
[ matrix_t ] = debrisRemove( matrix_t );
[ matrix_w ] = debrisRemove( matrix_w );
toc
% -------------------------------------------------------------------------


%չʾ�������
matrix=matrix_t;
if (showFlag == 'showImage' | showFlag=='stepReslt')
    disp('result pic:');
    tic,
    figure;
    imshow(matrix,'InitialMagnification','fit')
    title('ʴ�����');
    toc
end

errCode=errCode|errCode_sparkPts;

%д��ṹ�塣��������������ࡣ
matrixPair.matrix_t=matrix_t;
matrixPair.matrix_w=matrix_w;
xyOriginPair.start_tool=start_tool;
xyOriginPair.start_workp=start_workp;
end


% �������ڲ��� testCase��
% matrix(sparkpoint_tool(1),sparkpoint_tool(2))%1
% matrix(sparkpoint_tool(1)+1,sparkpoint_tool(2))%0
% matrix(sparkpoint_tool(1),sparkpoint_tool(2)+1)%0
% matrix(sparkpoint_workp(1),sparkpoint_workp(2))%1
% matrix(sparkpoint_workp(1)-1,sparkpoint_workp(2))%0
% matrix(sparkpoint_workp(1)+1,sparkpoint_workp(2))%1
% size(matrix)
%--------------------------------------------------------------------------
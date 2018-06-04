function [ matrix,startRow,c,errCode ] = runElectricProcess( matrix,matrix_t,startRow,startCol,c )
%RUNPROCESS One Cycle
%   all process simulation


% ���߽���١�
% �����룺��״����������߽�㼯-���У�������׷�����tool���ױߣ�
% ����ʵedges�ϲ����� + pde��boundaryConditionԤ����
% �����룺boundary points�������edges�������С��߽�������
% ��ע����άͼ�ε�pde_geom������ʱ������ά����Ĺ��죩
% ���糡���㡿
% �����룺�缫��״���߽������������~,ʸ��E��E��������꣬E�Ĵ�С��
%  [~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE; %һ��pde toolbox��GUIʾ�����ŵ��������
% ����ȡ�ŵ��ԡ�
% �����룺�߽�����У�E��grid�߳������϶���ʵ�����ꣻ������ŵ�����У�
% ��ʴ����
% �����룺�����������ŵ�磬��ʴ�Ӱ뾶���������������
% ��ֱ�߽�����
% �����룺matrix_tool��matrix�������matrix��

disp('boundary trace:');
tic,[m,n] = boundaryTrace(matrix, c.showFlag);toc
disp('combine pts to edge:');
tic,[ edgePoints,edgeNums ] = pdeEdgeGeom( m,n,c.origin_left_up,c.grid );toc
disp('calculate E');
tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,c.showFlag);toc
disp('spark point:');
tic,[sparkpoint_tool,sparkpoint_workp,errCode_sparkPts] = sparkPoint(m,n,maxPoint',maxE,maxAbsE,c.grid,c.origin_left_up,c.sparkDist);toc
disp('erode:');
tic,[matrix] = erode(matrix,c.rt,c.rw,sparkpoint_tool,sparkpoint_workp);toc
disp('feed:');
tic,
if(maxAbsE < c.breakE)
    maxAbsE
    c.processDepth=c.processDepth-c.grid;
    [height_t,wide_t]=size(matrix_t);
    matrix_t=matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));
    startRow=startRow+1;
    matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;
end
toc

%չʾ���
if (c.showFlag == 'showImage' | c.showFlag=='stepReslt')
    tic,
    disp('result pic:');
    toc
    tic,
    figure(5);
    imshow(matrix,'InitialMagnification','fit')
    title('ʴ�����');
    toc
end

errCode=0|errCode_sparkPts;
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
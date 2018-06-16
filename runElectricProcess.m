function [ matrix,matrix_t,startRow,c,errCode ] = runElectricProcess( matrix,matrix_t,startRow,startCol,c )
%RUNPROCESS One Cycle
%   all process simulation
errCode=0;
errorCount=3;%����������
showFlag=c.showFlag;

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


disp('boundary trace:');
tic,[m,n] = boundaryTrace(matrix, showFlag);toc

disp('combine pts to edge:');
tic,[edgePoints,edgeNums] = pdeEdgeGeom( m,n,c.origin_left_up,c.grid );toc


while 1    
    fprintf(2,'calculate E: \n');
    tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,3-errorCount,showFlag);
    toc
    
    disp('feed:');
    tic,
    if(maxAbsE < c.breakE)
        maxAbsE
        if(maxAbsE < 0.3)
            fprintf(2,'��ǿ��С(<0.3)������tool��workpiece�����Ӵ���������\n');
            fprintf(2,'�����·���δ���庯������� sparkpoint_tool���ж�\n');
            errCode_feed = 1;
            errCode=errCode|errCode_feed;
            break % �˴����滻��return
        end
        c.processDepth=c.processDepth-c.grid;
        [height_t,wide_t]=size(matrix_t);%������
        matrix_t=matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));%������
        startRow=startRow+1;
        matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;%������
        return
    end
    toc
    
    disp('spark point:');
    tic,[sparkpoint_tool,sparkpoint_workp,errCode_sparkPts] = sparkPoint(m,n,maxPoint',maxE,maxAbsE,c.grid,c.origin_left_up,c.sparkDist);toc
    
    % �ŵ������ �� �ﵽ����Ĵ���������ޣ���break
    if(errCode_sparkPts==0 || errorCount<=0)
%         errorCount
        break;
    elseif(errorCount==1)
        errorCount
        showFlag = 'showImage';
    end
    
    errorCount=errorCount-1;
end

disp('erode:');
tic,[matrix,matrix_t] = erode(matrix,c.rt,c.rw,sparkpoint_tool,sparkpoint_workp,matrix_t,startRow,startCol);toc



%չʾ�������
if (showFlag == 'showImage' | showFlag=='stepReslt')
    tic,
    disp('result pic:');
    toc
    tic,
    figure(5);
    imshow(matrix,'InitialMagnification','fit')
    title('ʴ�����');
    toc
end

errCode=errCode|errCode_sparkPts;
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
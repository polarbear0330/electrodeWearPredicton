%main ��ڳ���

%grid��΢�ף�
grid=25; 
%����ŵ��϶100΢��
sparkDist=75;
%�����ı���ʴ�Ӱ뾶(���辫�ӹ��ŵ��100um��300umֱ��)
rw=300/2/grid;
wearRatio=1/9;
rt=rw*sqrt(wearRatio);
%�����С���ϵ��
gridRatio=1/grid;
%������ǿ��С
% breakE=
%--------------------------------------------------------------------------
disp('model');
tic,
%��λ��΢��
%tool
tl=zeros(25000*gridRatio,12000*gridRatio);
tt=ones(25000*gridRatio,6000*gridRatio);
tr=zeros(25000*gridRatio,12000*gridRatio);
t=[tl tt tr];
%workpiece
wl=zeros(5000*gridRatio,5000*gridRatio);
ww=ones(5000*gridRatio,20000*gridRatio);
wr=zeros(5000*gridRatio,5000*gridRatio);
w=[wl ww wr];
%whole
h1=ones(1,30000*gridRatio);% �˴�1д����
spark=zeros(sparkDist*gridRatio,30000*gridRatio);% �ŵ��϶sparkDist����3������
matrix=[h1; t; spark; w; h1];
matrix(:,1)=1;
matrix(:,size(matrix,2))=1;
toc


showFlag='000000000';
showFlag='showImage';
showFlag='onlyReslt';
%--------------------------------------------------------------------------
%ȷ������ԭ��
origin_left_up=[...
    -size(matrix,2)/2, ...
    size(matrix,1)-size(h1,1)...
    ]*grid; % �����޸ģ������Ǻ�����
origin_left_up=[0,0];

matrix_t=tt;
matrix_w=ww;

disp('model:');
tic,[ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,sparkDist/grid,1.5 );toc

% ���߽���١�
% �����룺���������缫��״�ľ�������������缫�߽�����У�������׷�����tool���ױߣ�
disp('boundary trace:');
tic,[m,n] = boundaryTrace(matrix, showFlag);toc

% ����ʵedges�ϲ�����
% + pde��boundaryConditionԤ����
% �����룺boundary points����������Ӻõ�edge��ɵ�geom_dl����
%��ע����άͼ�ε�pde_geom������ʱ������ά����Ĺ��죩
disp('generate pde Geometry:');
tic,[ edgePoints,edgeNums ] = pdeEdgeGeom( m,n,origin_left_up,grid );toc

% ���糡���㡿
% �����룺�缫��״���߽������������~,ʸ��E��E��������꣬E�Ĵ�С��
disp('calculate E');
tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(edgePoints,edgeNums,showFlag);toc
% tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE;toc %һ��pde toolbox��GUIʾ�����ŵ��������

% ����ȡ�ŵ��ԡ�
% �����룺�߽�����У�E��grid�߳������϶���ʵ�����ꣻ������ŵ�����У�
disp('spark point:');
tic,[sparkpoint_tool,sparkpoint_workp] = sparkPoint(m,n,maxPoint',maxE,maxAbsE,grid,origin_left_up,sparkDist);toc

% ��ʴ����
% �����룺�����������ŵ�磬��ʴ�Ӱ뾶���������������
disp('erode:');
tic,[matrix] = erode(matrix,rt,rw,sparkpoint_tool,sparkpoint_workp);toc

% ��ֱ�߽�����
if(maxAbsE < 2.4)
    [height_t,wide_t]=size(matrix_t);
    matrix_t=matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1));
    startRow=startRow+1;
    matrix(startRow:height_t+startRow-1, startCol:(wide_t+startCol-1))=matrix_t;
end
% �������ڲ��ԣ�
% matrix(sparkpoint_tool(1),sparkpoint_tool(2))%1
% matrix(sparkpoint_tool(1)+1,sparkpoint_tool(2))%0
% matrix(sparkpoint_tool(1),sparkpoint_tool(2)+1)%0
% matrix(sparkpoint_workp(1),sparkpoint_workp(2))%1
% matrix(sparkpoint_workp(1)-1,sparkpoint_workp(2))%0
% matrix(sparkpoint_workp(1)+1,sparkpoint_workp(2))%1
% size(matrix)
%--------------------------------------------------------------------------

%չʾ���
if (showFlag == 'showImage' | showFlag=='onlyReslt')
    tic,
    disp('result pic:');
    toc
    tic,
    figure(5);
    imshow(matrix,'InitialMagnification','fit')
    title('ʴ�����');
    toc
end


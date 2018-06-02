%main ��ڳ���

%grid��΢�ף�
grid=25; 
%����ŵ��϶100΢��
sparkDist=100;
%�����ı���ʴ�Ӱ뾶(���辫�ӹ��ŵ��100um��300umֱ��)
rw=300/2/grid;
wearRatio=1/9;
rt=rw*sqrt(wearRatio);
%�����С���ϵ��
gridRatio=1/grid;
%������ǿ��С
% breakE=

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

geom_dl = [2,2,2,2,2,2,2,2,2,2,2,2;
    100, -30, 150, -150, 100,-100, 30, -30, -150, 100, 150, -30;
    -100, 30, 150, -150, 100,-100, 30, -30, -100, 150,  30,-150;
    50,   51,   0,  300,   0,  50, 51, 300,    0,   0, 300, 300;
    50,   51, 300,    0,  50,   0,300,  51,    0,   0, 300, 300;
    0,     0,   1,    1,   0,   0,  0,   0,    1,   1,   1,   1;
    1,     1,   0,    0,   1,   1,  1,   1,    0,   0,   0,   0];

showFlag='';
showFlag='showImage';
%--------------------------------------------------------------------------


% �߽���٣����룺���������缫��״�ľ�������������缫�߽�����У�
disp('boundary trace:');
tic,[wm,wn,tm,tn] = boundaryTrace(matrix, showFlag);toc

% 1.��������ӳɱߣ���ͬб�ʵı���ͬһ����
% 2.���� geom ����
%�����룺boundary points����������Ӻõ�edge��ɵ�geom_dl����
%��ע����άͼ�ε�pde_geom������ʱ������ά����Ĺ��죩
disp('generate pde Geometry:');
% tic,[geom_dl] = pdeEdgeGeom(boundaryPoints);toc

% �糡���㣨���룺�缫��״���߽������������~,ʸ��E��E��������꣬E�Ĵ�С��
disp('calculate E');
tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = electrostaticPDE(geom_dl);toc
% tic,[~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE;toc

% ��ȡ�ŵ��ԣ����룺�߽�����У�E��grid�߳������϶���ʵ�����ꣻ������ŵ�����У�
disp('spark point:');
tic,
origin_left_up=[...
    -size(matrix,2)/2, ...
    size(matrix,1)-size(h1,1)...
    ]*grid/1000*10; % �����޸ģ������Ǻ����꣬/10��ת����������
[sparkpoint_tool] = sparkPoint(tm,tn,maxPoint',maxE,maxAbsE,grid/1000*10,origin_left_up);% �����޸ģ������Ǻ����꣬/10��ת����������
[sparkpoint_workp] = sparkPoint(wm,wn,maxPoint',maxE,maxAbsE,grid/1000*10,origin_left_up);
toc

% ʴ�������룺�����������ŵ�磬��ʴ�Ӱ뾶���������������
disp('erode:');
tic,[matrix] = erode(matrix,rt,rw,sparkpoint_tool,sparkpoint_workp);toc

% �������ڲ��ԣ�
% matrix(sparkpoint_tool(1),sparkpoint_tool(2))%1
% matrix(sparkpoint_tool(1)+1,sparkpoint_tool(2))%0
% matrix(sparkpoint_tool(1),sparkpoint_tool(2)+1)%0
% matrix(sparkpoint_workp(1),sparkpoint_workp(2))%1
% matrix(sparkpoint_workp(1)-1,sparkpoint_workp(2))%0
% matrix(sparkpoint_workp(1)+1,sparkpoint_workp(2))%1
% size(matrix)
%--------------------------------------------------------------------------

tic,
disp('result pic:');
toc
tic,
figure(4);
imshow(matrix);
title('ʴ�����');
toc



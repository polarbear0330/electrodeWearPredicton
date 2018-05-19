%grid��΢�ף����辫�ӹ��ŵ��100um��300umֱ��
grid=25; 
rw=300/grid;
wearRatio=1/9;
rt=rw*sqrt(wearRatio);

% %����ŵ��϶100΢��
% sparkDist=100/1000;
%�����С���ϵ��
gridRatio=1/grid;
% gridRatio=1;

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
h1=zeros(10,30000*gridRatio);% �˴�10д����
spark=zeros(100*gridRatio,30000*gridRatio);% �ŵ��϶100΢�ף�����д�ɱ���
matrix=[h1; t; spark; w; h1];


% �߽���٣����룺���������缫��״�ľ�������������缫�߽�����У�
[wm,wn,tm,tn]=boundaryTrace_Main(matrix);

% �糡���㣨���룺�缫��״���߽������������~,ʸ��E��E��������꣬E�Ĵ�С��
[~,~,~,~,~,maxAbsE,maxPoint,maxE] = wholeE;

% ��ȡ�ŵ��ԣ����룺�߽�����У�E��grid�߳������϶���ʵ�����ꣻ������ŵ�����У�
origin_left_up=[...
    -size(matrix,2)/2, ...
    size(matrix,1)-size(h1,1)...
    ]*grid/1000/10; % �����޸ģ������Ǻ����꣬/10��ת����������
[sparkpoint_tool] = sparkPoint(tm,tn,maxPoint',maxE,maxAbsE,grid,origin_left_up);
[sparkpoint_workp] = sparkPoint(wm,wn,maxPoint',maxE,maxAbsE,grid,origin_left_up);

% ʴ�������룺�����������ŵ�磬��ʴ�Ӱ뾶���������������
[matrix] = erode(matrix,rt,rw,sparkpoint_tool,sparkpoint_workp);


figure(4);
imshow(matrix);
title('ʴ�����');








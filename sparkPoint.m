function [ sparkpoint ] = sparkPoint( m,n,point,E,absE,grid,origin_left_up)
%%SPARKPOINT ����ŵ�����
% point=[-0.5;0.5]';
% E=[1;1];
% absE=1.414;
% m=tm;n=tn;
% grid=0.01;
% origin_left_up=[-1.5,3.11];

%���룺
%m-����������У�
%n-����������У�
%point-������ʵ�����ꣻ
%E-������糡ǿ��Eʸ��
%grid-��������߳�

%���������grid������ÿһ��������Ӧ����ʵ��������ĵ�����C(x,y)
%��֪ÿһ��C������E�������еĴ��߸�H
%�ҵ���С�ļ���H��index��H <= grid/2
%����������С�����������Ӧ�ŵ��

%������֤��distance < ����ŵ��� * ����ϵ��(�磺2)
% sparkPoint=[0;0];

%����ϵ�任
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid+origin(1);
y=(m-1)*grid*(-1)+origin(2);
%����point->spark
sparks=[x,y]-point;
%����E�ĵ�λ������nE
nE=[-E(2);E(1)]/absE;
% E=[-E(2);E(1)];
%���߶θ�H
H=abs(sparks*nE);
[rowH,~]=find(H<=grid/2);%��Ӧ�������
%�����������ȣ�ȡ��̵�
possibleSparks=sparks(rowH,:);
length2=possibleSparks(:,1).^2 + possibleSparks(:,2).^2;
[~,sparkPos]=min(length2,[],1);
%����ϵ�任ʡ�ԣ�ֱ�Ӷ�ӦrowH����m��n
sparkPos=rowH(sparkPos);
sparkpoint=[m(sparkPos),n(sparkPos)];
% x(sparkPos)
% y(sparkPos)
% end


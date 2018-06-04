function [ sparkpoint1,sparkpoint2,errCode ] = sparkPoint( m,n,point,E,absE,grid,origin_left_up,sparkDist)
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
%�������飬ָ��tool��workpiece�����н�ԼΪ180�㣬������90����Ϊ�ж�����,��><0
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
%���ܵķŵ�㣬��Ӧ�������
[rowH,~]=find(H<=grid/2);
%�������飬���ֳ�ָ��tool�ĺ�workpiece��
%cosAngle�ֱ�><0��cos(90��)=0,ʵ�ʼн�Ϊ180������
possibleSparks=sparks(rowH,:);
firstSparkVec=possibleSparks(1,:);
temp=possibleSparks.*firstSparkVec;
cosAngle=temp(:,1)+temp(:,2);
row_possible_1=find(cosAngle>0);
row_possible_2=find(cosAngle<0);

[sparkpoint1,errCode1]=getMinLengthPt(possibleSparks,row_possible_1,rowH,m,n,sparkDist);
[sparkpoint2,errCode2]=getMinLengthPt(possibleSparks,row_possible_2,rowH,m,n,sparkDist);

errCode=0|(errCode1&errCode2);%����&����|
end

function [point,errCode]=getMinLengthPt(possibleSparks,row,rowH,m,n,sparkDist)
errCode=0;

%�����������ȣ�ȡ��̵�
length2=possibleSparks(row,1).^2 + possibleSparks(row,2).^2;
[minLen,sparkPos]=min(sqrt(length2),[],1);

%����ϵ�任ʡ�ԣ�ֱ�Ӷ�ӦrowH����m��n
sparkPos=row(sparkPos);
sparkPos=rowH(sparkPos);
point=[m(sparkPos),n(sparkPos)];

if(minLen>sparkDist*3)
    point=[-1,-1];
    minLen
    errCode=1;
end
errCode=0|errCode;
end


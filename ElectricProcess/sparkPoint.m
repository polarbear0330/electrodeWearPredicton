function [ sparkpoint,errCode ] = sparkPoint( mnPoints,start,pointE,E,absE,conf)
%%SPARKPOINT ����ŵ�����
% pointE=[-0.5;0.5]';
% E=[1;1];
% absE=1.414;
% m=tm;n=tn;
% grid=0.01;
% origin_left_up=[-1.5,3.11];

%���룺
%m-����������У�
%n-����������У�
%start-����ԭ���xy��������
%pointE-������ʵ��xy���ꣻ
%E-������糡ǿ��Eʸ��
%grid-��������߳�

%���������grid������ÿһ��������Ӧ����ʵ��������ĵ�����C(x,y)
%��֪ÿһ��C������E�������еĴ��߸�H
%�ҵ���С�ļ���H��index��H <= grid/2
%(ɾ)�������飬ָ��tool��workpiece�����н�ԼΪ180�㣬������90����Ϊ�ж�����,��><0
%����������С�����������Ӧ�ŵ��

%������֤��distance < ����ŵ��� * ����ϵ�� (�磺2)
% sparkPoint=[0;0];

grid=conf.grid;
origin_left_up=conf.origin_left_up;
sparkDist=conf.sparkDist;

m=mnPoints(:,1);
n=mnPoints(:,2);

%����ϵ�任
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid + start(1) + origin(1);
y=(m-1)*grid*(-1) + start(2) + origin(2);
%����point->spark
sparks=[x,y]-pointE;
%����E�ĵ�λ������nE
nE=[-E(2);E(1)]/absE;
% E=[-E(2);E(1)];
%���߶θ�H
H=abs(sparks*nE);
%���ܵķŵ�㣬��Ӧ�������
[rowH,~]=find(H<=grid/2);
%����ǿE������û���ཻ���κε�
if size(rowH,1)==0 || size(rowH,2)==0
    sparkpoint=[-1,-1]
    start
    errCode=1;
    return;
end
possibleSparks=sparks(rowH,:);
% %�������飬���ֳ�ָ��tool�ĺ�workpiece��
% %cosAngle�ֱ�><0��cos(90��)=0,ʵ�ʼн�Ϊ180������
% firstSparkVec=possibleSparks(1,:);
% temp=possibleSparks.*firstSparkVec;
% cosAngle=temp(:,1)+temp(:,2);
% row_possible_1=find(cosAngle>0);
% row_possible_2=find(cosAngle<0);

[sparkpoint,errCode]=getMinLengthPt(possibleSparks,rowH,m,n,sparkDist);

% [sparkpoint2,errCode2]=getMinLengthPt(possibleSparks,row_possible_2,rowH,m,n,sparkDist);
% errCode=0|(errCode1&errCode2);%����&����|
end

function [point,errCode]=getMinLengthPt(possibleSparks,rowH,m,n,sparkDist)
errCode=0;

%�����������ȣ�ȡ��̵�
length2=possibleSparks(:,1).^2 + possibleSparks(:,2).^2;
[minLen,sparkPos]=min(sqrt(length2),[],1);

%����ϵ�任ʡ�ԣ�ֱ�Ӷ�ӦrowH����m��n
% sparkPos=row(sparkPos);
sparkPos=rowH(sparkPos);
point=[m(sparkPos),n(sparkPos)];
% minLen

if(minLen>sparkDist*3)
    point=[-1,-1];
    minLen
    errCode=1;
end
errCode=0|errCode;
end


function [ sparkpoint,errCode ] = sparkPoint( mnPoints,start,pointE,E,absE,conf)
%%SPARKPOINT 计算放电矩阵点
% pointE=[-0.5;0.5]';
% E=[1;1];
% absE=1.414;
% m=tm;n=tn;
% grid=0.01;
% origin_left_up=[-1.5,3.11];

%输入：
%m-轮廓点矩阵行；
%n-轮廓点矩阵列；
%start-矩阵原点的xy绝对坐标
%pointE-击穿点实际xy坐标；
%E-击穿点电场强度E矢量
%grid-矩阵网格边长

%由网格长与宽grid，计算每一个矩阵点对应的真实网格的中心点坐标C(x,y)
%已知每一点C、向量E，求所有的垂线高H
%找到最小的几个H的index：H <= grid/2
%(删)向量分组，指向tool和workpiece向量夹角约为180°，这里以90°作为判断条件,即><0
%计算向量大小，最短向量对应放电点

%防错验证：distance < 常规放电间距 * 经验系数 (如：2)
% sparkPoint=[0;0];

grid=conf.grid;
origin_left_up=conf.origin_left_up;
sparkDist=conf.sparkDist;

m=mnPoints(:,1);
n=mnPoints(:,2);

%坐标系变换
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid + start(1) + origin(1);
y=(m-1)*grid*(-1) + start(2) + origin(2);
%向量point->spark
sparks=[x,y]-pointE;
%向量E的单位法向量nE
nE=[-E(2);E(1)]/absE;
% E=[-E(2);E(1)];
%垂线段高H
H=abs(sparks*nE);
%可能的放电点，对应多个向量
[rowH,~]=find(H<=grid/2);
%若场强E误差过大，没有相交于任何点
if size(rowH,1)==0 || size(rowH,2)==0
    sparkpoint=[-1,-1]
    start
    errCode=1;
    return;
end
possibleSparks=sparks(rowH,:);
% %向量分组，区分出指向tool的和workpiece的
% %cosAngle分别><0，cos(90°)=0,实际夹角为180°左右
% firstSparkVec=possibleSparks(1,:);
% temp=possibleSparks.*firstSparkVec;
% cosAngle=temp(:,1)+temp(:,2);
% row_possible_1=find(cosAngle>0);
% row_possible_2=find(cosAngle<0);

[sparkpoint,errCode]=getMinLengthPt(possibleSparks,rowH,m,n,sparkDist);

% [sparkpoint2,errCode2]=getMinLengthPt(possibleSparks,row_possible_2,rowH,m,n,sparkDist);
% errCode=0|(errCode1&errCode2);%考虑&换成|
end

function [point,errCode]=getMinLengthPt(possibleSparks,rowH,m,n,sparkDist)
errCode=0;

%计算向量长度，取最短的
length2=possibleSparks(:,1).^2 + possibleSparks(:,2).^2;
[minLen,sparkPos]=min(sqrt(length2),[],1);

%坐标系变换省略：直接对应rowH——m与n
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


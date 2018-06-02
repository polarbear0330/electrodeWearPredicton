function [ sparkpoint1,sparkpoint2 ] = sparkPoint( m,n,point,E,absE,grid,origin_left_up)
%%SPARKPOINT 计算放电矩阵点
% point=[-0.5;0.5]';
% E=[1;1];
% absE=1.414;
% m=tm;n=tn;
% grid=0.01;
% origin_left_up=[-1.5,3.11];

%输入：
%m-轮廓点矩阵行；
%n-轮廓点矩阵列；
%point-击穿点实际坐标；
%E-击穿点电场强度E矢量
%grid-矩阵网格边长

%由网格长与宽grid，计算每一个矩阵点对应的真实网格的中心点坐标C(x,y)
%已知每一点C、向量E，求所有的垂线高H
%找到最小的几个H的index：H <= grid/2
%向量分组，指向tool和workpiece向量夹角约为180°，这里以90°作为判断条件,即><0
%计算向量大小，最短向量对应放电点

%防错验证：distance < 常规放电间距 * 经验系数(如：2)
% sparkPoint=[0;0];

%坐标系变换
origin=origin_left_up+[grid/2,-grid/2];
x=(n-1)*grid+origin(1);
y=(m-1)*grid*(-1)+origin(2);
%向量point->spark
sparks=[x,y]-point;
%向量E的单位法向量nE
nE=[-E(2);E(1)]/absE;
% E=[-E(2);E(1)];
%垂线段高H
H=abs(sparks*nE);
%可能的放电点，对应多个向量
[rowH,~]=find(H<=grid/2);
%向量分组，区分出指向tool的和workpiece的
%cosAngle分别><0，cos(90°)=0,实际夹角为180°左右
possibleSparks=sparks(rowH,:);
firstSparkVec=possibleSparks(1,:)
temp=possibleSparks.*firstSparkVec
cosAngle=temp(:,1)+temp(:,2)

row_possible_1=find(cosAngle>0)
row_possible_2=find(cosAngle<0)
sparkpoint1=getMinLengthPt(possibleSparks,row_possible_1,rowH,m,n)
sparkpoint2=getMinLengthPt(possibleSparks,row_possible_2,rowH,m,n)

end

function [point]=getMinLengthPt(possibleSparks,row,rowH,m,n)

%计算向量长度，取最短的
length2=possibleSparks(row,1).^2 + possibleSparks(row,2).^2;
[~,sparkPos]=min(length2,[],1);
%坐标系变换省略：直接对应rowH——m与n
sparkPos=row(sparkPos)
sparkPos=rowH(sparkPos)
point=[m(sparkPos),n(sparkPos)];
% x(sparkPos)
% y(sparkPos)
end


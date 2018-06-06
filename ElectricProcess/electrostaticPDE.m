function [ u,E,pos,points_E,EE,max_absE,point_max,maxE ] = electrostaticPDE( edgePoints,edgeNums,showFlag )
%ELECTROSTATICPDE �糡����
%���룺�缫��״���߽�����-edgesNum��
%�����~,ʸ��E��E��������꣬E�Ĵ�С

% model = createpde;
% geometryFromEdges(model,dl);
% figure(1);
% pdegplot(model,'EdgeLabels','on');

%�������߳ɱ�
startPts=edgePoints; % �У�1 ~ end-1
endPts=[edgePoints(:,2:end), edgePoints(:,1)]; % �У�2 ~ end
n=size(edgePoints,2); % ���� - ����
dl=[2*ones(1,n);startPts(1,:);endPts(1,:);startPts(2,:);endPts(2,:);ones(1,n);zeros(1,n)];
% dl = [2,2,2,2,2,2,2,2,2,2,2,2;
%     100, -30, 150, -150, 100,-100, 30, -30, -150, 100, 150, -30;
%     -100, 30, 150, -150, 100,-100, 30, -30, -100, 150,  30,-150;
%     50,   51,   0,  300,   0,  50, 51, 300,    0,   0, 300, 300;
%     50,   51, 300,    0,  50,   0,300,  51,    0,   0, 300, 300;
%     0,     0,   1,    1,   0,   0,  0,   0,    1,   1,   1,   1;
%     1,     1,   0,    0,   1,   1,  1,   1,    0,   0,   0,   0];


[p,e,t] = initmesh(dl,'Hgrad',1.9); %Ĭ��1.3 
% subplot(2,2,1), pdemesh(p,e,t) 
[p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,2), pdemesh(p,e,t) 
[p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,3), pdemesh(p,e,t) 
% [p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,4), pdemesh(p,e,t) 


b = allzerobc(dl);%boundary matrix, MODEL!!!
% applyBoundaryCondition(model,'dirichlet','edge',1:model.Geometry.NumEdges,'u',0);
% edgeNums=[2,7,8];
applyBoundaryCondition(b,'dirichlet','edge',edgeNums,'u',150);
u=assempde(b,p,e,t,1,0,0); 



if (showFlag == 'showImage')
    figure(2);
    pdegplot(dl,'EdgeLabels','on','FaceLabels','on')
    axis equal
    
    figure(3);
    pdemesh(p,e,t) 
    axis equal
    
    figure(4);
    pdeplot(p,e,t,'XYData',u)
    axis equal
end


%------------------E-------------------------------------------------------
point = p;
%pdetool�������������Ĵ��ݶȡ�����ǿ
[Ex,Ey]=pdegrad(point,t,u);
E = [Ex;Ey];
EE = sqrt(Ex.^2 + Ey.^2);
[max_absE,pos] = max(EE,[],2);%dim=2��ÿһ�е����ֵ

% Triangle point indices
it1 = t(1,:);
it2 = t(2,:);
it3 = t(3,:);
% Find centroids of triangles
xpts = (point(1,it1) + point(1,it2) + point(1,it3))/3;
ypts = (point(2,it1) + point(2,it2) + point(2,it3))/3;
points_E = [xpts;ypts];

% figure(4);
% pdeplot(points_E,e,t,'XYData',EE)

%����E���
point_max = points_E(:,pos);
%����E
maxE = E(:,pos);

end

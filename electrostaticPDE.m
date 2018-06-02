function [ u,E,pos,points_E,EE,max_absE,point_max,maxE ] = electrostaticPDE( dl,edgeNums,showFlag )
%ELECTROSTATICPDE �糡����
%���룺�缫��״���߽�����-edgesNum��
%�����~,ʸ��E��E��������꣬E�Ĵ�С

figure(1);
pdegplot(dl,'EdgeLabels','on','FaceLabels','on')
xlim([-1.5,1.5])
axis equal


% model = createpde;
% geometryFromEdges(model,dl);
% figure(1);
% pdegplot(model,'EdgeLabels','on');



figure(2);
% [p,e,t] = initmesh(dl);%Ĭ��1.3 
[p,e,t] = initmesh(dl,'Hgrad',1.9); 
subplot(2,2,1), pdemesh(p,e,t) 
[p,e,t] = refinemesh(dl,p,e,t); 
subplot(2,2,2), pdemesh(p,e,t) 
% [p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,3), pdemesh(p,e,t) 
% [p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,4), pdemesh(p,e,t) 

figure(3);
b = allzerobc(dl);%boundary matrix, MODEL!!!
% applyBoundaryCondition(model,'dirichlet','edge',1:model.Geometry.NumEdges,'u',0);
% applyBoundaryCondition(b,'dirichlet','edge',2,'u',150);
% applyBoundaryCondition(b,'dirichlet','edge',7,'u',150);
% edgeNums=[2,7,8];
applyBoundaryCondition(b,'dirichlet','edge',edgeNums,'u',150);
u=assempde(b,p,e,t,1,0,0); 
pdeplot(p,e,t,'XYData',u)




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


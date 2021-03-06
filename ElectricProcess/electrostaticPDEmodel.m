function [ max_absE,point_max,maxE ] = electrostaticPDEmodel( edgePoints,edgeNums,meshCount,showFlag )
%ELECTROSTATICPDE 电场计算
%输入：电极形状，边界条件-edgesNum；
%输出：~,矢量E，E的起点坐标，E的大小

% model = createpde;
% geometryFromEdges(model,dl);
% figure(1);
% pdegplot(model,'EdgeLabels','on');
% disp('pde model');
%顶点连线成边
startPts=edgePoints; % 列：1 ~ end-1
endPts=[edgePoints(:,2:end), edgePoints(:,1)]; % 列：2 ~ end
n=size(edgePoints,2); % 点数 - 列数
dl=[2*ones(1,n);startPts(1,:);endPts(1,:);startPts(2,:);endPts(2,:);ones(1,n);zeros(1,n)];
figure;
pdegplot(dl,'EdgeLabels','off','FaceLabels','on')
% dl = [2,2,2,2,2,2,2,2,2,2,2,2;
%     100, -30, 150, -150, 100,-100, 30, -30, -150, 100, 150, -30;
%     -100, 30, 150, -150, 100,-100, 30, -30, -100, 150,  30,-150;
%     50,   51,   0,  300,   0,  50, 51, 300,    0,   0, 300, 300;
%     50,   51, 300,    0,  50,   0,300,  51,    0,   0, 300, 300;
%     0,     0,   1,    1,   0,   0,  0,   0,    1,   1,   1,   1;
%     1,     1,   0,    0,   1,   1,  1,   1,    0,   0,   0,   0];

Hgrad=1.9-meshCount/5;
[p,e,t] = initmesh(dl,'Hgrad',Hgrad,'MesherVersion', 'R2013a'); %默认1.3 
% subplot(2,2,1), pdemesh(p,e,t) 
[p,e,t] = refinemesh(dl,p,e,t);
for i=0:meshCount
%     meshCount
    [p,e,t] = refinemesh(dl,p,e,t);
end
% subplot(2,2,2), pdemesh(p,e,t) 
% [p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,3), pdemesh(p,e,t) 
% [p,e,t] = refinemesh(dl,p,e,t); 
% subplot(2,2,4), pdemesh(p,e,t) 


model = allzerobc(dl);%boundary 0
assoc = pde.FEMeshAssociation(t, e);
t(end,:) = [];
model.Mesh=pde.FEMesh(p, t, 0, 0, 'linear', assoc);
% edgeNums=[2,7,8];
applyBoundaryCondition(model,'dirichlet','edge',edgeNums,'u',150);
specifyCoefficients(model,'m',0,...
                          'd',0,...
                          'c',1,...
                          'a',0,...
                          'f',0);

                          
results = solvepde(model);

u = results.NodalSolution;

%------------------E-------------------------------------------------------

% % 计算出的E经过了插值处理，略微有一点点不准确。
% % 即，能体现尖端放电，只是放电点的位置有较小的误差
% % 可能原因分析：matlab自带函数的插值做得太粗略了，间隔过大。

absE=sqrt(results.XGradients.^2 + results.YGradients.^2);
[max_absE,pos] = max(absE,[],1);%dim=2：每一列的最大值
%向量E起点
point_max = p(:,pos);
%向量E
maxE = [results.XGradients(pos); results.YGradients(pos)];



if (showFlag == 'showImage')
    figure;
    pdegplot(dl,'EdgeLabels','on','FaceLabels','on')
    axis equal
    
    figure;
    pdemesh(model) 
    axis equal
    
    figure;
    % subplot(1,2,1), 
    % subplot(1,2,2), 
    pdeplot(model,'XYData',absE,'Mesh','off','ColorMap','jet');
    axis equal
    figure;
    pdeplot(model,'XYData',u,'Mesh','off','ColorMap','jet');
    axis equal
end

end


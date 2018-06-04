%main 入口程序

% -------------------------------------------------------------------------
% 参数配置
conf=loadConfig();
% 建模
matrix_t=ones(25000/grid,6000/grid);
matrix_w=ones(5000/grid,20000/grid);
[ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/conf.grid,conf.wideRatio );

% electric process simulation 电加工仿真
[ matrix ] = runElectricProcess(matrix,matrix_t,startRow,startCol,conf);

% -------------------------------------------------------------------------


function [config]=loadConfig()
% load config

%grid：微米；
c.grid=25; 
%假设放电间隙100微米
c.sparkDist=75;
%体积损耗比与蚀坑半径(假设精加工放电坑100um、300um直径)
c.rw=300/2/c.grid;
c.wearRatio=1/9;
c.rt=c.rw*sqrt(c.wearRatio);
% %矩阵大小相关系数
% c.gridRatio=1/c.grid;
%击穿场强大小
c.breakE=2.4;
%确定坐标原点——设定图形最左上顶点为如下值，即（1,1）网格的左上顶点的真实坐标
c.origin_left_up=[0,0];
%初始建模：模型宽比工件宽（倍数）
c.wideRatio=1.5;
%绘图功能开关
c.showFlag='close_all';
c.showFlag='showImage';
c.showFlag='onlyReslt';
c.showFlag='stepReslt';

config=c;
end


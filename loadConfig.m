function [ config ] = loadConfig( )
%LOADCONFIG 加载各项配置常数及电参数
%   load config, parameters

%加工深度
c.processDepth=2000;


%grid：微米；
c.grid=25; 
%假设放电间隙100微米
c.sparkDist=75;
%体积损耗比与蚀坑半径(假设精加工放电坑100um、300um直径)
c.rw=300/2/c.grid;
c.wearRatio=1/9;
c.rt=c.rw*sqrt(c.wearRatio);
%击穿场强大小
c.breakE=2.4;
%确定坐标原点——设定图形最左上顶点为如下值，即（1,1）网格的左上顶点的真实坐标
c.origin_left_up=[0,0];
%初始建模：模型宽比工件宽（倍数）
c.wideRatio=1.5;
%绘图功能开关
c.showFlag='close_all';
c.showFlag='showImage';
c.showFlag='stepReslt';
c.showFlag='onlyReslt';

config=c;
end


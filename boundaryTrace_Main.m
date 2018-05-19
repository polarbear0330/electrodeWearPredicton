function [wm,wn,tm,tn]=boundaryTrace_Main(matrix)
% 边界跟踪功能入口 + 边界imshow

%输入矩阵的模拟数据
% %tool
% tl=zeros(250,120);
% tt=ones(250,60);
% tr=zeros(250,120);
% t=[tl tt tr];
% %workpiece
% wl=zeros(50,50);
% ww=ones(50,200);
% wr=zeros(50,50);
% w=[wl ww wr];
% %whole
% h1=zeros(10,300);
% spark=zeros(1,300);
% matrix=[h1; t; spark; w; h1];



% figure(1);
% imshow(matrix);
% title('原始图像');

[b,wm,wn]=boundaryTrace(matrix,"workpiece");
% % [b,wm,wn]=boundaryTrace(matrix,"tool");
% figure(2);
% imshow(b);
% title('四连通边界跟踪结果workpiece');

[b,tm,tn]=boundaryTrace(matrix,"tool");
% figure(3);
% imshow(b);
% title('四连通边界跟踪结果tool');

  
                    
    


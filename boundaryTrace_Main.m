function [wm,wn,tm,tn]=boundaryTrace_Main(matrix)
% �߽���ٹ������ + �߽�imshow

%��������ģ������
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
% title('ԭʼͼ��');

[b,wm,wn]=boundaryTrace(matrix,"workpiece");
% % [b,wm,wn]=boundaryTrace(matrix,"tool");
% figure(2);
% imshow(b);
% title('����ͨ�߽���ٽ��workpiece');

[b,tm,tn]=boundaryTrace(matrix,"tool");
% figure(3);
% imshow(b);
% title('����ͨ�߽���ٽ��tool');

  
                    
    


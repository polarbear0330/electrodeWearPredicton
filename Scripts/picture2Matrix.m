
f=imread('1.png');
figure(5);
imshow(f);
title('原图');

figure(2);
bw1=im2bw(f,0.2);%使用默认值0.5
imshow(bw1)
title('使用0.5作为门槛时的二值图像');

figure(3);
level=graythresh(f);%使用graythresh计算灰度门槛
bw2=im2bw(f,level);
imshow(bw2);
title('通过graythresh计算灰度门槛时的二值图像');



matrix_t=ones(size(bw2));
matrix_t(bw2)=0;
figure(4);
imshow(matrix_t)
title('矩阵');

% save('wholeElectrode.mat', 'matrix_t');
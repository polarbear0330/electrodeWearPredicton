
f=imread('4mm_640_400.png');
figure(1);
imshow(f);
title('ԭͼ');

figure(2);
bw1=im2bw(f,0.2);%ʹ��Ĭ��ֵ0.5
imshow(bw1)
title('ʹ��0.5��Ϊ�ż�ʱ�Ķ�ֵͼ��');

figure(3);
level=graythresh(f);%ʹ��graythresh����Ҷ��ż�
bw2=im2bw(f,level);
imshow(bw2);
title('ͨ��graythresh����Ҷ��ż�ʱ�Ķ�ֵͼ��');



matrix_t=ones(size(bw1));
matrix_t(bw1)=0;
figure(4);
imshow(matrix_t)
title('����');
%main ��ڳ���
% ---------------------------------start-----------------------------------
% ��������
conf=loadConfig();
% ��ģ
grid=conf.grid;
matrix_t=ones(25000/grid,10000/grid); % 25mm * 10mm
matrix_w=ones(5000/grid,20000/grid);
[ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/grid,conf.wideRatio );
% ��ӹ����� electric process simulation 
count =0;
while 1
    count=count+1
    [ matrix,startRow,conf,errCode ] = runElectricProcess(matrix,matrix_t,startRow,startCol,conf);
    if(errCode || conf.processDepth==0)
        break;
    end
end
% ----------------------------------end------------------------------------

%չʾ���
tic,
if (conf.showFlag == 'onlyReslt')
    figure(10);
    imshow(matrix,'InitialMagnification','fit')
    title('ʴ�����');
end
toc


function [config]=loadConfig()
% load config

%�ӹ����
c.processDepth=2000;


%grid��΢�ף�
c.grid=25; 
%����ŵ��϶100΢��
c.sparkDist=75;
%�����ı���ʴ�Ӱ뾶(���辫�ӹ��ŵ��100um��300umֱ��)
c.rw=300/2/c.grid;
c.wearRatio=1/9;
c.rt=c.rw*sqrt(c.wearRatio);
%������ǿ��С
c.breakE=2.4;
%ȷ������ԭ�㡪���趨ͼ�������϶���Ϊ����ֵ������1,1����������϶������ʵ����
c.origin_left_up=[0,0];
%��ʼ��ģ��ģ�Ϳ�ȹ�����������
c.wideRatio=1.5;
%��ͼ���ܿ���
c.showFlag='close_all';
c.showFlag='showImage';
c.showFlag='stepReslt';
c.showFlag='onlyReslt';

config=c;
end


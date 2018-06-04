%main ��ڳ���

% -------------------------------------------------------------------------
% ��������
conf=loadConfig();
% ��ģ
matrix_t=ones(25000/grid,6000/grid);
matrix_w=ones(5000/grid,20000/grid);
[ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/conf.grid,conf.wideRatio );

% electric process simulation ��ӹ�����
[ matrix ] = runElectricProcess(matrix,matrix_t,startRow,startCol,conf);

% -------------------------------------------------------------------------


function [config]=loadConfig()
% load config

%grid��΢�ף�
c.grid=25; 
%����ŵ��϶100΢��
c.sparkDist=75;
%�����ı���ʴ�Ӱ뾶(���辫�ӹ��ŵ��100um��300umֱ��)
c.rw=300/2/c.grid;
c.wearRatio=1/9;
c.rt=c.rw*sqrt(c.wearRatio);
% %�����С���ϵ��
% c.gridRatio=1/c.grid;
%������ǿ��С
c.breakE=2.4;
%ȷ������ԭ�㡪���趨ͼ�������϶���Ϊ����ֵ������1,1����������϶������ʵ����
c.origin_left_up=[0,0];
%��ʼ��ģ��ģ�Ϳ�ȹ�����������
c.wideRatio=1.5;
%��ͼ���ܿ���
c.showFlag='close_all';
c.showFlag='showImage';
c.showFlag='onlyReslt';
c.showFlag='stepReslt';

config=c;
end


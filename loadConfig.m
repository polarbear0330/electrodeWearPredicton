function [ config ] = loadConfig( )
%LOADCONFIG ���ظ������ó����������
%   load config, parameters

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


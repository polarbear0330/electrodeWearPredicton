function [ config ] = loadConfig( )
%LOADCONFIG ���ظ������ó����������
%   load config, parameters

%�ӹ���ȣ��ñ���������ǰ�ڲ��ԣ�����ʽ��������ļӹ�G���������ȡ��
c.processDepth=5000;


%grid��΢�ף�
c.grid=25; 
%����ŵ��϶100΢��
c.sparkDist=75;
%�����ı���ʴ�Ӱ뾶(���辫�ӹ��ŵ��100um��300umֱ��)
c.rw=200/2/c.grid;
c.wearRatio=1/4;
c.rt=c.rw*sqrt(c.wearRatio);
%������ǿ��С
c.breakE=2.4;
%ȷ������ԭ�㡪���趨ͼ�������϶���Ϊ����ֵ������1,1����������϶������ʵ����
c.origin_left_up=[0,0];
%��ʼ��ģ��ģ�Ϳ�ȹ�����������
c.wideRatio=1.5;
%��ͼ���ܿ���-ѡ��������
c.showFlag='close_all';
c.showFlag='showImage';
c.showFlag='stepReslt';
c.showFlag='onlyReslt';

config=c;
disp('load init config paras');
end

% % blisk
% c.rw=200/2/c.grid;
% c.wearRatio=1/4;
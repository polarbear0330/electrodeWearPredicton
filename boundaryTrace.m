% �߽����
% % ģ�����룬���ڵ���
% %tool
% tl=zeros(250,120);
% tm=ones(250,60);
% tr=zeros(250,120);
% t=[tl tm tr];
% %workpiece
% wl=zeros(50,50);
% wm=ones(50,200);
% wr=zeros(50,50);
% w=[wl wm wr];
% %whole
% h1=zeros(10,300);
% spark=zeros(1,300);
% f=[h1; t; spark; w; h1];
% mode="tool";
    %%%%%%%%%  ��������ʾ�߽���ٵ��Ӻ���  %%%%%%%%%    
function [g,m,n]=boundaryTrace(f, mode)
% function g=boundary_trace(f) ����Ŀ�����߽磬fλ����Ķ�ֵͼ��gΪ����Ķ�ֵͼ��
offsetr=[-1, 0 ,1 ,0];
offsetc=[0, 1, 0 ,-1];
next_search_dir_table=[4,1,2,3];   % ����������ұ�
next_dir_table=[2,3,4,1];
start=-1;
boundary=-2;
% �ҳ���ʼ��
% mode="workpiece";
if (mode=="workpiece")%ע��find����ֻ��¼���������Ľ���е����һ����������Ż�������
    [rv,cv]=find( (f(2:end-1,:)==0) & (f(1:end-2,:)>0) );
elseif (mode=="tool")%��ֹλ�õ�ѡ��Ҫ�ȹ����ߣ�����ѡ��tool���˴��̶���find��ֹλ��
    [rv,cv]=find( (f(2:15,:)>0) & (f(1:14,:)==0) );
end
rv=rv+1;
startr=rv(1);
startc=cv(1);
f=im2double(f);
f(startr,startc)=start;
cur_p=[startr,startc];
init_departure_dir=-1;
done=0;
next_dir=2;  % ��ʼ����
while ~done
    dir=next_dir;
    found_neighbour=0;
    for i=1:length(offsetr)
        offset=[offsetr(dir),offsetc(dir)];
        neighbour=cur_p+offset;
        if( f(neighbour(1),neighbour(2))~=0 ) %�ҵ��µı�Ե��
            if(( f(cur_p(1),cur_p(2))==start ) && (init_departure_dir==-1))
                init_departure_dir=dir;  %�����뿪��ʼ��ķ���
                %��ǰ��λ��ʼ�����µı�Ե���뿪����λ��ʼ�뿪���򣬱��������Ѿ�����һȦ
            elseif( (f(cur_p(1),cur_p(2))==start) && (init_departure_dir==dir) )
                done=1;
                found_neighbour=1;
                break;
            end
            next_dir=next_search_dir_table(dir); %������һ������
            found_neighbour=1;
            if (f(neighbour(1),neighbour(2))~=start)
                f(neighbour(1),neighbour(2))=boundary;
                %�����������mn��ֵ
            end
            cur_p=neighbour;
            break;
        end
        dir=next_dir_table(dir);
    end
end
% bi= f==boundary;
bi=find(f==boundary);

[m,n]=ind2sub(size(f),bi);
m=[startr;m];
n=[startc;n];

f(:)=0;
f(bi)=1;
f(startr,startc)=1;
g=im2bw(f);
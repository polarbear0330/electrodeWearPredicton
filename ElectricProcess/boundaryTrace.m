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
% mode="all";
    %%%%%%%%%  ��������ʾ�߽���ٵ��Ӻ���  %%%%%%%%%    
function [mnPoints]=boundaryTrace(matrix, showFlag, mode)
% function g=boundary_trace(f) ����Ŀ�����߽磬fλ����Ķ�ֵͼ��gΪ����Ķ�ֵͼ��
matrixOriginal=matrix;

offsetr=[-1, 0 ,1 ,0];
offsetc=[0, 1, 0 ,-1];
next_dir_table=[4,1,2,3];   % ����������ұ�,����0����һ�������棬��ת��
next_search_dir_table=[2,3,4,1]; %����1����һ������˳����ת��
start=-1;
boundary=-2;
% �ҳ���ʼ��
% mode="all";
if (mode=="workpiece")
    [~,cv]=find( (matrix(end-1,1:end-1)==1) & (matrix(end-1,2:end)==0) );
    rv=size(matrix,1)-1;
    next_dir=1;  % ��ʼ����
elseif (mode=="tool")
    [~,cv]=find( (matrix(2,1:end-1)==0) & (matrix(2,2:end)>0) ,1);
    rv=2;
    cv=cv+1;
    next_dir=3;  % ��ʼ����
end
startr=rv(1);
startc=cv(1);
% matrix=im2double(matrix);
matrix(startr,startc)=start;
cur_p=[startr,startc];
init_departure_dir=-1;
done=0;

%Ԥ�����ڴ��Ż�
m=[startr];
n=[startc];
while ~done
    dir=next_dir;
    found_neighbour=0;
    for i=1:length(offsetr)
        offset=[offsetr(dir),offsetc(dir)];
        neighbour=cur_p+offset;
        if( matrix(neighbour(1),neighbour(2))~=0 ) %�ҵ��µı�Ե��
            if(( matrix(cur_p(1),cur_p(2))==start ) && (init_departure_dir==-1))
                init_departure_dir=dir;  %�����뿪��ʼ��ķ���
                %��ǰ��λ��ʼ�����µı�Ե���뿪����λ��ʼ�뿪���򣬱��������Ѿ�����һȦ
            elseif( (matrix(cur_p(1),cur_p(2))==start) && (init_departure_dir==dir) )
                done=1;
                found_neighbour=1;
                break;
            end
            next_dir=next_search_dir_table(dir); %������һ������
            found_neighbour=1;
            if (matrix(neighbour(1),neighbour(2))~=start)
                matrix(neighbour(1),neighbour(2))=boundary;
                %�����������mn��ֵ
                m=[m;neighbour(1)];
                n=[n;neighbour(2)];
            end
            cur_p=neighbour;
            break;
        end
        dir=next_dir_table(dir);
    end
end
% % bi= f==boundary;
% matrix(startr,startc)=boundary;
% % matrix(startr,startc)
% bi=find(matrix==boundary);
% [m,n]=ind2sub(size(matrix),bi);

%�򻯱߽�
% mnPoints = [m, n];
mnPoints = deleteInsidePoint(m,n,matrixOriginal);

%     tic,
if (showFlag == 'showImage')

    matrix(:)=0;
    bi=sub2ind(size(matrix),m,n);
    matrix(bi)=1;
%     matrix(m,n)=1;%����
    figure;
    imshow(matrix,'InitialMagnification','fit')
    title('����ͨ�߽���ٽ��');

end
end

function [mnPoints] = deleteInsidePoint(m,n,matrixOriginal)
%�޳��ս��ڷǱ߽��
mnPoints=[m(1), n(1)];
for i = 2:length(m)
    if  matrixOriginal(m(i)+1,n(i)) &&...
        matrixOriginal(m(i)-1,n(i)) &&...
        matrixOriginal(m(i),n(i)+1) &&...
        matrixOriginal(m(i),n(i)-1)
%                     disp('delete inside point');
        continue;
    elseif m(i)==m(i-1) && n(i)==n(i-1)
%         disp('delete duplicate point');
        continue;
    else
        mnPoints=[mnPoints; m(i), n(i)];
    end
end
end




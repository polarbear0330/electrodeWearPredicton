% 边界跟踪
% % 模拟输入，用于调试
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
    %%%%%%%%%  下面是显示边界跟踪的子函数  %%%%%%%%%    
function [g,m,n]=boundaryTrace(f, mode)
% function g=boundary_trace(f) 跟踪目标的外边界，f位输入的二值图像，g为输出的二值图像
offsetr=[-1, 0 ,1 ,0];
offsetc=[0, 1, 0 ,-1];
next_search_dir_table=[4,1,2,3];   % 搜索方向查找表
next_dir_table=[2,3,4,1];
start=-1;
boundary=-2;
% 找出起始点
% mode="workpiece";
if (mode=="workpiece")%注：find函数只记录符合条件的结果中的最后一个结果，可优化！！！
    [rv,cv]=find( (f(2:end-1,:)==0) & (f(1:end-2,:)>0) );
elseif (mode=="tool")%终止位置的选择，要比工件高，才能选到tool。此处固定了find终止位置
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
next_dir=2;  % 初始方向
while ~done
    dir=next_dir;
    found_neighbour=0;
    for i=1:length(offsetr)
        offset=[offsetr(dir),offsetc(dir)];
        neighbour=cur_p+offset;
        if( f(neighbour(1),neighbour(2))~=0 ) %找到新的边缘点
            if(( f(cur_p(1),cur_p(2))==start ) && (init_departure_dir==-1))
                init_departure_dir=dir;  %记下离开初始点的方向
                %当前点位初始点且新的边缘点离开方向位初始离开方向，表明跟踪已经饶了一圈
            elseif( (f(cur_p(1),cur_p(2))==start) && (init_departure_dir==dir) )
                done=1;
                found_neighbour=1;
                break;
            end
            next_dir=next_search_dir_table(dir); %搜索下一个方向
            found_neighbour=1;
            if (f(neighbour(1),neighbour(2))~=start)
                f(neighbour(1),neighbour(2))=boundary;
                %可以在这里给mn赋值
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
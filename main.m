%main ��ڳ���



% ---------------------------------start-----------------------------------
try
    load
catch
    % ��������
    conf=loadConfig();
    % ��ģ
    grid=conf.grid;
    matrix_t=ones(25000/grid,10000/grid); % 25mm * 10mm
    tipLen=10000/grid/2;
    tipLeft=triu(ones(tipLen,tipLen),0);
    tip=[tipLeft,fliplr(tipLeft)];
    matrix_t(end-tipLen+1:end,:)=tip;
    matrix_w=ones(10000/grid,20000/grid);
    [ matrix,start_tool,start_workp ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/grid,conf.wideRatio );
    % runElectricProcess ִ�д�����Լ���ڷŵ����
    count=0;
    imshow(matrix,'InitialMagnification','fit');
end

while count<=3000
    count=count+1
    try
        % ��ӹ����� electric process simulation
        [ matrix,matrix_t,start_tool,matrix_w,start_workp,conf,errCode ] = runElectricProcess(matrix,matrix_t,start_tool,matrix_w,start_workp,conf);
    catch exception
        save;
        errCode=1;
        errorReport=getReport(exception);
        disp(errorReport);
    end
    
    % ������
    if(errCode || conf.processDepth==0)
        save;
        boundaryTrace(matrix, 'showImage');
        fprintf(2, '\n currentDepth = %d \n\n', conf.processDepth);
        break;
    end
end
% ----------------------------------end------------------------------------

save;
curFileName=['withTip_noDebris/matlab',num2str(count),'.mat'];
save(curFileName);
fprintf(1, '\n currentDepth = %d \n\n', conf.processDepth);


% ---------------------------display_result--------------------------------
tic,
if (conf.showFlag == 'onlyReslt')
    figure(10);
    imshow(matrix,'InitialMagnification','fit')
    title('ʴ�����');
end
toc
% -------------------------------------------------------------------------


% ����-------------------------------------------------------------------
% whole=matrix;
% tool=matrix_t;
% workp=matrix_w;
% tool(:)=0;
% [ whole ] = refreshModelMatrix( whole,tool,workp,start_tool,start_workp );
% figure(11);
% imshow(whole,'InitialMagnification','fit')
% title('ʴ�����');
% 
% matrix_back0=matrix_t;
% matrix_back0(:)=0;
% % matrix_t(:)=1;
% matrix_test=[matrix_back0,matrix_t,matrix_back0];
% imshow(matrix_test,'InitialMagnification','fit')

% ����----------------------------------------------------
% [ matrix_t ] = debrisRemove( matrix_t );
% imshow(matrix_t(679:end,:),'InitialMagnification','fit')
% 
% [ matrix_w ] = debrisRemove( matrix_w );
% imshow(matrix_w(:,250:550),'InitialMagnification','fit')
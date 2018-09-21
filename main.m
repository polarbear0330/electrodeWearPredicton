%main 入口程序

conf.showFlag='showImage';
conf.showFlag='onlyReslt';

% ---------------------------------start-----------------------------------
try
    load
catch
    % 参数配置
    conf=loadConfig();
    % 建模
    grid=conf.grid;
    matrix_t=ones(25000/grid,10000/grid); % 25mm * 10mm
    tipLen=10000/grid/2;
    tipLeft=triu(ones(tipLen,tipLen),0);
    tip=[tipLeft,fliplr(tipLeft)];
    matrix_t(end-tipLen+1:end,:)=tip;
    matrix_w=ones(10000/grid,20000/grid);
    [ vertexes4,matrixPair,xyOriginPair ] = initModelMatrix( matrix_t,matrix_w,conf );
    % 解析G代码
    feedParas.codeG=[xyOriginPair.start_tool;xyOriginPair.start_tool+[0,-10000,0]];
    feedParas.rowG=1;
    feedParas.increment=[0,0,0];
    
    count=0;
%     imshow(matrix,'InitialMagnification','fit');
end

while count<=4000
    count=count+1
    try
        % 电加工仿真 electric process simulation
        [ matrixPair,xyOriginPair,feedParas,conf,errCode ] = runElectricProcess(vertexes4,matrixPair,xyOriginPair,feedParas,conf);
    catch exception
        save;
        errCode=1;
        errorReport=getReport(exception);
        disp(errorReport);
    end
    
    % 错误处理
    if(errCode || isSamePoint(xyOriginPair.start_tool,feedParas.codeG(size(feedParas.codeG,1),:)))
        save;
        figure;
        boundaryTrace(matrixPair.matrix_t, 'showImage', "tool");
        figure;
        boundaryTrace(matrixPair.matrix_w, 'showImage', "workpiece");
        
        fprintf(2, '\n Work Done! : \n\n');
        break;
    end
end
% ----------------------------------end------------------------------------

save;
curFileName=['rotate/straightLineDown/matlab',num2str(count),'.mat'];
save(curFileName);
% fprintf(1, '\n currentDepth = %d \n\n', conf.processDepth);


% ---------------------------display_result--------------------------------
tic,
if (conf.showFlag == 'onlyReslt')
    figure;
    imshow(matrixPair.matrix_t,'InitialMagnification','fit')
    figure;
    imshow(matrixPair.matrix_w,'InitialMagnification','fit')
    title('蚀除结果');
end
toc
% -------------------------------------------------------------------------


% 后处理-------------------------------------------------------------------
% whole=matrix;
% tool=matrix_t;
% workp=matrix_w;
% tool(:)=0;
% [ whole ] = refreshModelMatrix( whole,tool,workp,start_tool,start_workp );
% figure(11);
% imshow(whole,'InitialMagnification','fit')
% title('蚀除结果');
% 
% matrix_back0=matrix_t;
% matrix_back0(:)=0;
% % matrix_t(:)=1;
% matrix_test=[matrix_back0,matrix_t,matrix_back0];
% imshow(matrix_test,'InitialMagnification','fit')

% 测试----------------------------------------------------
% [ matrix_t ] = debrisRemove( matrix_t );
% imshow(matrix_t(679:end,:),'InitialMagnification','fit')
% 
% [ matrix_w ] = debrisRemove( matrix_w );
% imshow(matrix_w(:,250:550),'InitialMagnification','fit')
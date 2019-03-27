%main 入口程序

% % % % conf.showFlag='showImage';


% -----------------------simulation-start----------------------------------
try
    load
    conf.showFlag='onlyReslt';
catch
    % 参数配置
    conf=loadConfig();
    % 工具、工件矩阵的建立
    grid=conf.grid;
    matrix_t=ones(25000/grid,9825/grid); % 25mm * 9.825mm，平头电极
%         tipLen=10000/grid/2; % 尖头电极的一种建模方式
%         tipLeft=triu(ones(tipLen,tipLen),0);
%         tip=[tipLeft,fliplr(tipLeft)];
%         matrix_t(end-tipLen+1:end,:)=tip;
    matrix_w=ones(10000/grid,20000/grid);
    % 蚀除模型的初始化     
    [ vertexes4,matrixPair,xyOriginPair ] = initModelMatrix( matrix_t,matrix_w,conf );
    % 解析G代码
    feedParas.codeG=[
        xyOriginPair.start_tool;
        xyOriginPair.start_tool+[0,-10075,0];
        xyOriginPair.start_tool+[0,-7000,30];
        ];
    feedParas.rowG=1;
    feedParas.increment=[0,0,0];
    
    count=0;
%     imshow(matrix,'InitialMagnification','fit');
end

while count<=50 %调试程序时，可设为1至100左右；正式仿真时，设置一个特别大的值如99999
    count=count+1
    try
        % 电加工仿真函数
%         conf.showFlag='showImage' % 用于即时测试
        [ matrixPair,xyOriginPair,feedParas,conf,errCode ] = runElectricProcess(vertexes4,matrixPair,xyOriginPair,feedParas,conf);
    catch exception
        save;
        errCode=1;
        errorReport=getReport(exception);
        disp(errorReport);
    end
    
    % 终止或结束处理
    if(errCode || isSamePoint(xyOriginPair.start_tool,feedParas.codeG(size(feedParas.codeG,1),:)))
        save;
        figure;
        boundaryTrace(matrixPair.matrix_t, 'showImage', "tool");
        figure;
        boundaryTrace(matrixPair.matrix_w, 'showImage', "workpiece");
        
        fprintf(2, '\n Work Done/Stop! : \n\n');
        break;
    end
end
% -----------------------simulation-end------------------------------------

% save;
% curFileName=['ExperimentSimulationCases/flat1/matlab',num2str(count),'.mat'];
% save(curFileName);

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


% 后处理与显示---系统调试时可启动这部分代码-----------------------------------
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

% 测试代码-----------------------------------------------------------------
% [ matrix_t ] = debrisRemove( matrix_t );
% imshow(matrix_t(679:end,:),'InitialMagnification','fit')
% 
% [ matrix_w ] = debrisRemove( matrix_w );
% imshow(matrix_w(:,250:550),'InitialMagnification','fit')
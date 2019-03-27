%main ��ڳ���

% % % % conf.showFlag='showImage';


% -----------------------simulation-start----------------------------------
try
    load
    conf.showFlag='onlyReslt';
catch
    % ��������
    conf=loadConfig();
    % ���ߡ���������Ľ���
    grid=conf.grid;
    matrix_t=ones(25000/grid,9825/grid); % 25mm * 9.825mm��ƽͷ�缫
%         tipLen=10000/grid/2; % ��ͷ�缫��һ�ֽ�ģ��ʽ
%         tipLeft=triu(ones(tipLen,tipLen),0);
%         tip=[tipLeft,fliplr(tipLeft)];
%         matrix_t(end-tipLen+1:end,:)=tip;
    matrix_w=ones(10000/grid,20000/grid);
    % ʴ��ģ�͵ĳ�ʼ��     
    [ vertexes4,matrixPair,xyOriginPair ] = initModelMatrix( matrix_t,matrix_w,conf );
    % ����G����
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

while count<=50 %���Գ���ʱ������Ϊ1��100���ң���ʽ����ʱ������һ���ر���ֵ��99999
    count=count+1
    try
        % ��ӹ����溯��
%         conf.showFlag='showImage' % ���ڼ�ʱ����
        [ matrixPair,xyOriginPair,feedParas,conf,errCode ] = runElectricProcess(vertexes4,matrixPair,xyOriginPair,feedParas,conf);
    catch exception
        save;
        errCode=1;
        errorReport=getReport(exception);
        disp(errorReport);
    end
    
    % ��ֹ���������
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
    title('ʴ�����');
end
toc
% -------------------------------------------------------------------------


% ��������ʾ---ϵͳ����ʱ�������ⲿ�ִ���-----------------------------------
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

% ���Դ���-----------------------------------------------------------------
% [ matrix_t ] = debrisRemove( matrix_t );
% imshow(matrix_t(679:end,:),'InitialMagnification','fit')
% 
% [ matrix_w ] = debrisRemove( matrix_w );
% imshow(matrix_w(:,250:550),'InitialMagnification','fit')
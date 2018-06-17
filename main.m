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
    matrix_w=ones(5000/grid,20000/grid);
    [ matrix,start_tool,start_workp ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/grid,conf.wideRatio );
    % runElectricProcess ִ�д�����Լ���ڷŵ����
    count=0;
end

while count<=200
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

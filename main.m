%main 入口程序



% ---------------------------------start-----------------------------------
try
    load
catch
    % 参数配置
    conf=loadConfig();
    % 建模
    grid=conf.grid;
    matrix_t=ones(25000/grid,10000/grid); % 25mm * 10mm
    matrix_w=ones(5000/grid,20000/grid);
    [ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/grid,conf.wideRatio );
    % runElectricProcess 执行次数，约等于放电次数
    count=0;
end

while 1
    count=count+1
    try
        % 电加工仿真 electric process simulation
        [ matrix,startRow,conf,errCode ] = runElectricProcess(matrix,matrix_t,startRow,startCol,conf);
        if(errCode)%?????????????????????????????????????????
            continue;
        end
    catch
        errCode=1;
        errorReport=getReport(MException.last);
        disp(errorReport);
    end
    
    % 错误处理
    if(errCode || conf.processDepth==0)
        save;
        conf.showFlag='showImage';
        runElectricProcess(matrix,matrix_t,startRow,startCol,conf);
        fprintf(2, '\n currentDepth = %d \n\n', conf.processDepth);
        break;
    end
end
% ----------------------------------end------------------------------------





% ---------------------------display_result--------------------------------
tic,
if (conf.showFlag == 'onlyReslt')
    figure(10);
    imshow(matrix,'InitialMagnification','fit')
    title('蚀除结果');
end
toc
% -------------------------------------------------------------------------

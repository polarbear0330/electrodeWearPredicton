%main 入口程序



% ---------------------------------start-----------------------------------
% 参数配置
conf=loadConfig();
% 建模
grid=conf.grid;
matrix_t=ones(25000/grid,10000/grid); % 25mm * 10mm
matrix_w=ones(5000/grid,20000/grid);
[ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/grid,conf.wideRatio );
% 电加工仿真 electric process simulation 
count =0;
while count<=10
    count=count+1
    [ matrix,startRow,conf,errCode ] = runElectricProcess(matrix,matrix_t,startRow,startCol,conf);
    if(errCode || conf.processDepth==0)
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

%main ��ڳ���



% ---------------------------------start-----------------------------------
% ��������
conf=loadConfig();
% ��ģ
grid=conf.grid;
matrix_t=ones(25000/grid,10000/grid); % 25mm * 10mm
matrix_w=ones(5000/grid,20000/grid);
[ matrix,startRow,startCol ] = initModelMatrix( matrix_t,matrix_w,conf.sparkDist/grid,conf.wideRatio );
% ��ӹ����� electric process simulation 
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
    title('ʴ�����');
end
toc
% -------------------------------------------------------------------------

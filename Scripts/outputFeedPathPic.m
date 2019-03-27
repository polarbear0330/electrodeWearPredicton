

% fill([-5000 35000 35000 -5000],[-30000 -30000 -20000 -20000],'g');
% fill([5000 25000 25000 5000],[-40000 -40000 -30000 -30000]+6000,'g');

matrix_w=ones(10000/grid,20000/grid);
[ ~,matrixPair,~ ] = initModelMatrix( matrix_t,matrix_w,conf );
   


conf.showFlag='onlyReslt';
[ matrixPair,xyOriginPair,feedParas,conf,errCode ] = runElectricProcess(vertexes4,matrixPair,xyOriginPair,feedParas,conf);


% figure(1)
% hold on
% axis equal


init=[
    0 5000
    0 0
    9800 0
    9800 5000
];
init=init+[10137.5 -30112.5];%坐标原点
figure(3)
hold on
plot(init(:,1),init(:,2),'black');

flat_simulation_coord=[
    10137.5	-25208.41837
    10137.5	-26610.45918
%     10157.39796	-28032.39796
    10166.58163	-28133.41837
    10212.5	-28987.5
    10324.23469	-29212.5
    10379.33673	-29320.66327
    10512.5	-29412.5
    10787.5	-29462.5
%     11262.5	-29462.5
%     11562.5	-29462.5
    12162.5	-29462.5
%     12840.56122	-29434.43878
    13495.15306	-29454.84694
%     14012.5	-29487.5
%     14137.5	-29512.5
    14687.5	-29437.5
%     15135.96939	-29437.5
    15958.92857	-29462.5
%     16636.9898	-29437.5
    17043.62245	-29406.37755
    18262.5	-29437.5
%     18818.11224	-29431.88776
    19281.37755	-29406.37755
    19512.5	-29387.5
    19682.90816	-29307.90816
    19862.5	-29062.5
    19883.92857	-28841.07143
    19922.19388	-28497.19388
    19928.31633	-28371.68367
    19937.5	-26464.54082
    19937.5	-25041.07143
    ];
figure(3);
plot(flat_simulation_coord(:,1),flat_simulation_coord(:,2),'red');
% grid on


xy=[
    0 5000
    
    42 1645
    82 1201
    132 1061
    181 938
    263 790
    378 691
    509 625
    
    3635 625
    5939 625
    
    9271 650
    9345 724
    9534 823
    9608 946
    9666 1045
    9724 1267
    9774 1670
    
    9800 5000
    ];
xy=xy+[10137.5 -30112.5];%坐标原点
figure(3)
hold on
plot(xy(:,1),xy(:,2),'blue');




xlim([5000,25000]);
% ylim([-30000,-25000]);
% axis([5000,25000,-35000,-25000])
axis equal;
% axis square;
title('工具电极损耗仿真与实验结果对比');

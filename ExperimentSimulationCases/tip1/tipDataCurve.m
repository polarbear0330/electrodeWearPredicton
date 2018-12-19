tip_simulation_coord=[
    19912.5	-23336.9898
    19912.5	-24512.5
    19900.2551	-24824.7449
    19887.5	-24937.5
    19775.2551	-25150.2551
    19587.5	-25412.5
    19162.5	-26112.5
    18533.92857	-27066.07143
    17885.96939	-27985.96939
    17237.5	-28962.5
    16380.86735	-30237.5
    15787.5	-31112.5
    15512.5	-31487.5
    15362.5	-31587.5
    15162.5	-31737.5
    15024.5 -31789.5
    14887.5 -31738.5
    14662.5	-31637.5
    14412.5	-31387.5
    13762.5	-30462.5
    12887.5	-29112.5
    12317.09184	-28187.5
    11662.5	-27337.5
    10864.03061	-26060.96939
    10362.5	-25312.5
    10287.5	-25162.5
    10187.5	-25012.5
    10157.39796	-24907.39796
    10157.39796	-24707.39796
    10137.5	-23336.9898
    ];
figure(5);
plot(tip_simulation_coord(:,1),tip_simulation_coord(:,2),'red');
% grid on


experiment_coord=[
    0 10000
    
    25	8728
    41	8556
    82	8465
    222	8350
    271	8169
    461	7881
    1505	6269
    2797	4327
    3653	3093
    4286	2131
    4533	1769
    4623	1654
    4681	1596
    4714	1555
    4771	1522
    4854	1522
    4928	1547
    5018	1588
    5084	1654
    5166	1760
    5405	2114
    6088	3134
    6984	4377
    8227	6219
    9329	7955
    9584	8366
    9674	8515
    9732	8597
    9749	8663
    9773	8778
    
    9775 10000
    ];
experiment_coord=experiment_coord+[10137.5 -33587.5];%坐标原点
figure(5)
hold on
plot(experiment_coord(:,1),experiment_coord(:,2),'blue');


init=[
    0 10000
    0 8465
    4887.5 0
    9775 8465
    9775 10000
];
init=init+[10137.5 -33587.5];%坐标原点
figure(5)
hold on
plot(init(:,1),init(:,2),'black');


% xlim([5000,25000]);5
% ylim([-30000,-25000]);
% axis([5000,25000,-35000,-25000])
axis equal;
% axis square;
title('工具电极损耗仿真与实验结果对比');
% legend(axes1,'show');

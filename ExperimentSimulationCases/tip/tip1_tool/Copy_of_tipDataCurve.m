init=[
    0 10000
    0 8465
    4887.5 0
    9775 8465
    9775 10000
];
init=init+[10137.5 -33587.5];%����ԭ��
figure(5)
hold on
plot(init(:,1),init(:,2),'black');

tip_simulation_coord=[
    19912.5	-23336.9898
    19912.5	-24512.5
    19903.31633	-24653.31633
    19838.52041	-24888.52041
    19737.5	-25112.5
    19562.5	-25387.5
    19122.70408	-26052.29592
    18496.17347	-27021.17347
    17864.54082	-27964.54082
    17210.96939	-28935.96939
    16337.5	-30212.5
    15740.56122	-31034.43878
    15544.13265	-31319.13265
    15362.5	-31587.5
    15162.5	-31737.5
    
    15025.5  -31789.5
    14888.5  -31738.5
    
    14662.5	-31637.5
    14437.5	-31337.5
    13787.5	-30412.5
    12937.5	-29087.5
    12322.19388	-28187.5
    11765.56122	-27334.43878
    10877.80612	-25997.19388
    10378.82653	-25246.17347
    10337.5	-25137.5
    10248.21429	-25026.78571
    10210.96939	-24964.03061
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
    160	8350
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
experiment_coord=experiment_coord+[10137.5 -33437.5];%����ԭ��
figure(5)
hold on
plot(experiment_coord(:,1),experiment_coord(:,2),'blue');





% xlim([5000,25000]);5
% ylim([-30000,-25000]);
% axis([5000,25000,-35000,-25000])
axis equal;
% axis square;
title('���ߵ缫��ķ�����ʵ�����Ա�');
% legend(axes1,'show');
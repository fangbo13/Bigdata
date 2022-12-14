%% Plotting graphs in Matlab



%% Show two plots on different y-axes
%% 1000 data processed
x1Vals = [2, 3, 4, 5, 6,7, 8];
y1Vals = [94.36,66.02 ,52.45, 44.42,39.81, 36.72,36.29];
figure(1)
subplot(1,2,1)
%yyaxis right
plot(x1Vals, y1Vals, '-bd','Linewidth',1)
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
hold on 

%% 5000 data processed
x2Vals = [2, 3, 4, 5, 6, 7, 8];
y2Vals = [584.94,413.71,315.99,260.92,230.99,210.06,196.10];
figure(1)
%yyaxis right
plot(x2Vals, y2Vals, '-rx','Linewidth',1)
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

legend('1000 Data', '5000 Data')


%% Show two plots on same y-axis
%% Mean processing time
y1MeanVals = y1Vals / 1000;
y2MeanVals = y2Vals / 5000;

subplot(1,2,2)
%yyaxis right
plot(x1Vals, y1MeanVals, '-bd','Linewidth',1)
hold on
%yyaxis right
plot(x2Vals, y2MeanVals, '-rx')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
legend('1000 Data', '5000 Data')

x3Vals = [2, 3, 4, 5, 6, 7, 8];
y3Vals = [584.94,413.71,315.99,260.92,230.99,210.06,196.10];
figure(2)

plot(x1Vals, y1Vals, '-bd','Linewidth',1)
hold on 

plot(x3Vals, y3Vals, '-rx','Linewidth',1)
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
legend('Parallel processing', 'Sequential processing')
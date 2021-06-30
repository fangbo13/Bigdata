%% Plotting graphs in Matlab



%% Show two plots on different y-axes
%% 300 data processed
x1Vals = [2, 3, 4, 5, 6,7, 8];
y1Vals = [31.4, 27.3, 28.46, 23.2, 22.6, 21.7, 21.1];
figure(1)
subplot(1,2,1)
%yyaxis right
plot(x1Vals, y1Vals, '-bd','Linewidth',1)
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
hold on 

%% 600 data processed
x2Vals = [2, 3, 4, 5, 6, 7, 8];
y2Vals = [31.94,28.67,26.14,24.52,23.48,22.88,22.48];
figure(1)
%yyaxis right
plot(x2Vals, y2Vals, '-rx','Linewidth',1)
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

legend('300 Data', '600 Data')


%% Show two plots on same y-axis
%% Mean processing time
y1MeanVals = y1Vals / 300;
y2MeanVals = y2Vals / 600;

subplot(1,2,2)
%yyaxis right
plot(x1Vals, y1MeanVals, '-bd','Linewidth',1)
hold on
%yyaxis right
plot(x2Vals, y2MeanVals, '-rx')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
legend('300 Data', '600 Data')

x3Vals = [2, 3, 4, 5, 6, 7, 8];
y3Vals = [40, 41.5, 34, 47, 46, 44, 42];
figure(2)

plot(x1Vals, y1Vals, '-bd','Linewidth',1)
hold on 

plot(x3Vals, y3Vals, '-rx','Linewidth',1)
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')
legend('Parallel processing', 'Sequential processing')
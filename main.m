clear all;

ExploreData; %Data table reading
PrepareData;  %Data pre-processing
ParallelProcessing; %The parallel processing data is used to evaluate the processing speed
TestNan;  %Test data validity
CreatTestData_Nan; %Replace invalid data Nan with an approximate average
Testsolutionswithlogfile；

%%You need to manually modify the coordinate value of graph. m to reflect the number of cores and speed

Graph 
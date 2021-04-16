diary 'E:/作业1/yourlogfile.txt' %打开记录log文件
diary on %开始记录log
%% 1.将损坏的数据替换

clear all
close all

OriginalFileName = 'E:\作业1\Model\o3_surface_20180701000000.nc';
NewFileName = 'E:\作业1\Model\TestFileNaN.nc';
copyfile(OriginalFileName, NewFileName);

C = ncinfo(NewFileName);
ModelNames = {C.Variables(1:8).Name};


%% Change data to NaN
BadData = NaN(700,400,1);

%% Write to *.nc file
Hour2Replace = 12;
for idx = 1:8
    ncwrite(NewFileName, ModelNames{idx}, BadData, [1, 1, Hour2Replace]);
end

%% 2.顺序执行代码
FileName = 'E:\作业1\Model\o3_surface_20180701000000.nc';

Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations

% Processing parameters provided by customer
RadLat = 30.2016; % cluster radius value for latitude
RadLon = 24.8032; % cluster radius value for longitude
RadO3 = 4.2653986e-08; % cluster radius value for the ozone data

% Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'NumHour' in our loop
% The section 'sequential processing' will process the data location one
% after the other, reporting on the time involved.

StartLat = 1; % latitude location to start laoding
NumLat = 400; % number of latitude locations ot load
StartLon = 1; % longitude location to start loading
NumLon = 700; % number of longitude locations ot load
tic
for seq_num = 1:7
    for NumHour = 1:25 % loop through each hour
        fprintf('Processing hour %i\n', NumHour)
        DataLayer = 1; % which 'layer' of the array to load the model data into
        for idx = [1, 3, 2, 5, 6, 7, 8] % model data to load
            % load the model data
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
                [StartLon, StartLat, NumHour], [NumLon, NumLat, 1]);
            DataLayer = DataLayer + 1; % step to the next 'layer'
        end

        % We need to prepare our data for processing. This method is defined by
        % our customer. You are not required to understand this method, but you
        % can ask your module leader for more information if you wish.
        [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);

        % Sequential analysis    
        t1 = toc;
        t2 = t1;
        for idx = 1: size(Data2Process,1) % step through each data location to process the data

            % The analysis of the data creates an 'ensemble value' for each
            % location. This method is defined by
            % our customer. You are not required to understand this method, but you
            % can ask your module leader for more information if you wish.
            [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);

            % To monitor the progress we will print out the status after every
            % 50 processes.
            if idx/50 == ceil( idx/50)
                tt = toc-t2;
                fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
                    idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
                t2 = toc;
            end
        end
        T2(NumHour) = toc - t1; % record the total processing time for this hour
        fprintf('Processing hour %i - %.2f s\n\n', NumHour, sum(T2));


    end
tSeq = toc;
seq_time(sq_num) = tSeq;
fprintf('Total time for sequential processing = %.2f s\n\n', tSeq)
end
%% 3.并行执行代码

NumHours = 25;


% Pre-allocate output array memory
% the '-4' value is due to the analysis method resulting in fewer output
% values than the input array.
NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours); % pre-allocate memory

% Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'NumHour' in our loop
% The section 'parallel processing' will process the data location one
% after the other, reporting on the time involved.
tic
for par_num = 1:7
    for idxTime = 1:NumHours

        % Load the data for each hour
        % Each hour we read the data from the required models, defined by the
        % index variable. Each model data are placed on a 'layer' of the 3D
        % array resulting in a 7 x 700 x 400 array.
        % We do this by indexing through the model names, then defining the
        % start position as the beginnning of the Lat, beginning of the Lon and
        % beginning of the new hour. We then define the number of elements
        % along each data dimension, so the total number of Lat, the total
        % number of Lon, but only 1 hour.
        % You can use these values to select a smaller sub-set of the data if
        % required to speed up testing o fthe functionality.

        DataLayer = 1;
        for idx = [1, 2, 3, 4, 5, 6, 7]
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
                [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
            DataLayer = DataLayer + 1;
        end

        % Pre-process the data for parallel processing
        % This takes the 3D array of data [model, lat, lon] and generates the
        % data required to be processed at each location.
        % ## This process is defined by the customer ##
        % If you want to know the details, please ask, but this is not required
        % for the module or assessment.
        [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);


    % Parallel Analysis
        % Create the parallel pool and attache files for use
        PoolSize = par_num ; % define the number of processors to use in parallel
        if isempty(gcp('nocreate'))
            parpool('local',PoolSize);
        end
        poolobj = gcp;
        % attaching a file allows it to be available at each processor without
        % passing the file each time. This speeds up the process. For more
        % information, ask your tutor.
        addAttachedFiles(poolobj,{'EnsembleValue'});

    %     %% 8: Parallel processing is difficult to monitor progress so we define a
    %     % special function to create a wait bar which is updated after each
    %     % process completes an analysis. The update function is defined at the
    %     % end of this script. Each time a parallel process competes it runs the
    %     % function to update the waitbar.
        DataQ = parallel.pool.DataQueue; % Create a variable in the parallel pool
    %     
    %     % Create a waitbar and handle top it:
        hWaitBar = waitbar(0, sprintf('Time period %i, Please wait ...', idxTime));
    %     % Define the function to call when new data is received in the data queue
    %     % 'DataQ'. See end of script for the function definition.
        afterEach(DataQ, @nUpdateWaitbar);
        N = size(Data2Process,1); % the total number of data to process
        p = 20; % offset so the waitbar shows some colour quickly.

        % The actual parallel processing!
        % Ensemble value is a function defined by the customer to calculate the
        % ensemble value at each location. Understanding this function is not
        % required for the module or the assessment, but it is the reason for
        % this being a 'big data' project due to the processing time (not the
        % pure volume of raw data alone).
        T4 = toc;
        parfor idx = 1: 100 % size(Data2Process,1)
            [EnsembleVectorPar(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
            send(DataQ, idx);
        end

        close(hWaitBar); % close the wait bar

        T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
        fprintf('Parallel processing time for hour %i : %.1f s\n', idxTime, T3(idxTime))

    end % end time loop
    T2 = toc;
    delete(gcp);

    % Reshape ensemble values to Lat, lon, hour format
    EnsembleVectorPar = reshape(EnsembleVectorPar, 696, 396, []);
    fprintf('Total processing time for %i workers = %.2f s\n', PoolSize, sum(T3));
    par_time(PoolSize) = sum(T3);
    % ### PROCESSING COMPLETE DATA NEEDS TO BE SAVED  ###
end
waitbar(p/N, hWaitBar,  sprintf('Hour %i, %.3f complete, %i out of %i', idxTime, p/N*100, p, N));
p = p + 1;
diary off;%停止记录log

%% 4.画出对比图
xVals = [1, 2, 3, 4, 5, 6, 7, 8];
y1Vals = [seq_time(1), seq_time(2), seq_time(3), seq_time(4), seq_time(5), seq_time(6), seq_time(7)];
y2Vals = [par_time(1), par_time(2), par_time(3), par_time(4), par_time(5), par_time(6), par_time(7)];
y1MeanVals = y1Vals;
y2MeanVals = y2Vals /300;

figure(1)
plot(xVals, y1MeanVals, '-bd')
hold on
plot(xVals, y2MeanVals, '-rx')

xlabel('Number of Processors')
ylabel('Processing time (s)')
title('sequential processing time vs parallel processing processors')
legend('parallel_processing', 'sequential_processing')


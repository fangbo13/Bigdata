FileName = 'E:\作业1\Model\o3_surface_20180701000000.nc';

%% Section 3: Loading all the data for a single hour from all the models
% We combine the aboce code to cycle through the names and load each model.
% We load the data into successive 'layers' using 'idx', and let the other
% two dimensions take care of themselves by using ':'
StartLat = 1; % starting latitude
NumLat = 400; % number of latitude positions
StartLon = 1; % starying longitude
NumLon = 700; % number of lingitude positions
StartHour = 1; % starting time for analyises
NumHour = 1; % Number of hours of data to load

% loop through the models loading *ALL* the data into an array
Models2Load = [1, 2, 4, 5, 6, 7, 8]; % list of models to load
idxModel = 0; % current modelFileName = '..\Model\o3_surface_20180701000000.nc'; % define the name of the file to be used, the path is included
function [HourMem,HourDataMem] = Reportresultsf()
%% Section 5: Print our results

fprintf('\nResults:\n')
fprintf('Memory used for all data: %.2f MB\n', AllDataMem)
fprintf('Memory used for hourly data: %.2f MB\n', HourDataMem)
fprintf('Maximum memory used hourly = %.2f MB\n', HourMem)
fprintf('Hourly memory as fraction of all data = %.2f\n\n', HourMem / AllDataMem)
end
for idx = 1:7
    idxModel = idxModel + 1; % move to next model index
    LoadModel = Models2Load(idx); % which model to load
    ModelData(idxModel,:,:,:) = ncread(FileName, Contents.Variables(LoadModel).Name,...
        [StartLon, StartLat, StartHour], [NumLon, NumLat, NumHour]);
    fprintf('Loading %s\n', Contents.Variables(LoadModel).Name); % display loading information
end

HourDataMem = whos('ModelData').bytes/1000000;
fprintf('Memory used for 1 hour of data: %.3f MB\n', HourDataMem)
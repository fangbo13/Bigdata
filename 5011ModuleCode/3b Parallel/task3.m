Path = 'E:\作业1\Model\o3_surface_20180701000000.nc'
File = dir(fullfile(Path,'*.nc'));
Filename = {File.name}';
Length_Names = size(FileNames,1);% Read the number of NC files in the folder
% At this point, we can see that we have summarized all the data set names under the folder into the file name array. For example, the file name (1) can display the file name (1) = {O 3_ surface_ 20180701000000.nc'}
% Loading data processing code normally
Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations


for nameNum = 1:Length_Names % Loop automatically processes each set of data in the folder
    FileName = strcat(Path,Filename(nameNum))
    for NumHour = 1:25 % loop through each hour
         fprintf('Processing hour %i\n', NumHour)
         DataLayer = 1; % which 'layer' of the array to load the model data into
         for idx = [1, 3, 2, 5, 6, 7, 8] % model data to load
             % load the model data
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,
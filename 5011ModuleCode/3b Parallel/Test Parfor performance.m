Startup code:
function [pool] = startmatlabpool(size)
pool=[];
isstart = 0;
if isempty(gcp('nocreate'))==1
    isstart = 1;
end
if isstart==1
    if nargin==0
        pool=parpool('local');
    else
        try
            pool=parpool('local',size);%matlabpool('open','local',size);
        catch ce
            pool=parpool('local');%matlabpool('open','local');
            size = pool.NumWorkers;
            display(ce.message);
            display(strcat('restart. wrong  size=',num2str(size)));
        end
    end
else
    display('matlabpool has started');
    if nargin==1
        closematlabpool;
        startmatlabpool(size);
    else
        startmatlabpool();
    end
end


	Close code：
		function [] = closematlabpool
if isempty(gcp('nocreate'))==0
 		   delete(gcp('nocreate'));
end

	Test code：
		pool = startmatlabpool(4);
N=1000;
M=100;
data = cell(1,N);
for kk = 1:N
  		 	data{kk} = rand(M);
end
display(strcat('datasize:',num2str(N*M*M/1024/1024),'M doubles'));
tic;
parfor ii = 1:N
     		c1(:,ii) = eig(data{ii});
end
t1 = toc; 
display(strcat('parafor:',num2str(t1),'seconds'));
 
tic;
for ii = 1:N
     		c2(:,ii) = eig(data{ii});
end
t2 = toc; 
display(strcat('for:',num2str(t2),'seconds'));
 
closematlabpool;

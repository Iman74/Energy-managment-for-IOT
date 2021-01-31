clc
clear
fclose all;
%%
fileContents = [];
idle_t = [];
active_t = [];

wl_names = ["/custom_workload_1.txt", "/custom_workload_2.txt" ...
    ,"/Generated_workload_1.1.txt", "/Generated_workload_1.2.txt" ...
    ,"/Generated_workload_1.3.txt","/Generated_workload_1.4.txt"...
    ,"/Generated_workload_1.5.txt"];
fullFileNames = "dpm_simulator/example" + wl_names;
for i =1:length(fullFileNames)
    fullFileName = fullFileNames(i);
    if isfile(fullFileName)
        % File exists.
        fileID = fopen(fullFileName,'r');
        fileContents = fscanf(fileID,'%f %f');
        fclose(fileID);
        start_t = fileContents(1:2:end);  % odd matrix
        end_t = fileContents(2:2:end);  % even matrix
        idle_t(i,:) = end_t - start_t;
        active_t(i,:)= start_t - [0;end_t(1:end-1)];
        %delete file
        %recycle on; % Send deleted files to recycle bin
        %delete(fullFileName);
    else
        disp("File does not exist!");
    end
end
clearvars -except idle_t active_t

%%
idleOld2_t = idle_t(:,1:end-2);
idleOld_t = idle_t(:,2:end-1);
idle_t = idle_t(:,3:end);
%%
N = 7;
x = idleOld_t(N,:);
y= idleOld2_t(N,:);
%y = active_t(N,1:end-2);
z = idle_t(N,:);
%z= a+ b*x+ c*x^2 + d*y+ e*y^2
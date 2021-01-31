clc
clear
%%
%Read_Custom_WorkLoads
fileContents = [];
c_idle_t = [];
c_active_t = [];

wl_names = ["/custom_workload_1.txt", "/custom_workload_2.txt"];
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
        c_idle_t(i,:) = end_t - start_t;
        c_active_t(i,:)= start_t - [0;end_t(1:end-1)];
        %delete file
        %recycle on; % Send deleted files to recycle bin
        %delete(fullFileName);
    else
        disp("File does not exist!");
    end
end
clearvars -except c_idle_t c_active_t


%%
%make random Lengths
s = rng;
% Uniform distribution, min = 1us, max = 500us, 5000 samples!
activeP(1,:) = randi([1 500],1,5000);
activeP(2,:) = randi([1 500],1,5000);
activeP(3,:) = randi([1 500],1,5000);
activeP(4,:) = randi([1 500],1,5000);
activeP(5,:) = randi([1 500],1,5000);
%Uniform distribution, min = 1us, max=100us (high utilization)
idleP(1,:) = randi([1 100],1,5000); 
%Uniform distribution, min=1us, max=400us (low utilization)
idleP(2,:) = randi([1 400],1,5000); 
%Normal distribution, mean=100us, standard deviation=20
idleP(3,:) = ceil(random('Normal',100,20,1,5000));
%Exponential distribution, mean=50us
idleP(4,:) = ceil(random('Exponential',50,1,5000)); 
%Tri-modal distribution – Mean = 50, 100, 150us – Standard deviation=10
for i = 1:5000
   rnd = unidrnd(3,1);
   idleP(5,i) = ceil(random('Normal',rnd*50,10));
end
%idleP(6,:) = [round(random('Normal',50,10,1,1666)) round(random('Normal',100,10,1,1668)) round(random('Normal',150,10,1,1666))]; 

%find any nonPositive element  <=0
nonPositive = numel((idleP)) - length(find(idleP>0));
if(nonPositive ==0)
    disp('all generated successfully.')
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Plot & Save Histograms
% Generated actives
figure
xaxis=2;
yaxis=3;
subplot(xaxis,yaxis,1)
    h0 = histogram(activeP(1,:),100);
    h0.FaceColor = 'green';
    title('1. Active #1 Uniform')
subplot(xaxis,yaxis,2)
    h0 = histogram(activeP(2,:),100);
    h0.FaceColor = 'green';
    title('2. Active #2 Uniform')
subplot(xaxis,yaxis,3)
    h0 = histogram(activeP(3,:),100);
    h0.FaceColor = 'green';
    title('3. Active #3 Uniform')
subplot(xaxis,yaxis,4)
    h0 = histogram(activeP(4,:),100);
    h0.FaceColor = 'green';
    title('4. Active #4 Uniform')
subplot(xaxis,yaxis,5)
    h0 = histogram(activeP(5,:),100);
    h0.FaceColor = 'green';
    title('5. Active #5 Uniform')
    
fname = sprintf('dpm_simulator/example/Results/Generated_Active_Histograms');
set(gcf, 'Units', 'Normalized','OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')
%close all

% Generated idles
figure
xaxis=2;
yaxis=3;

subplot(xaxis,yaxis,1)
    h0 = histogram(idleP(1,:),100);
    h0.FaceColor = 'magenta';
    title('1. Idle Uniform #1')
subplot(xaxis,yaxis,2)
    h0 = histogram(idleP(2,:),100);
    h0.FaceColor = 'yellow';
    title('2. Idle Uniform #2')
subplot(xaxis,yaxis,3)
    h0 = histogram(idleP(3,:),100);
    h0.FaceColor = 'cyan';
    title('3. Idle Normal')
subplot(xaxis,yaxis,4)
    h0 = histogram(idleP(4,:),100);
    h0.FaceColor = 'blue';
    title('4. Idle Exponential')
subplot(xaxis,yaxis,5)
    h0 = histogram(idleP(5,:),100);
    h0.FaceColor = 'red';
    title('5. Idle Tri-modal')
    
fname = sprintf('dpm_simulator/example/Results/Generated_Idle_Histograms');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')
%close all

%Custom Workloads
figure
xaxis=2;
yaxis=2;

subplot(xaxis,yaxis,1)
    h0 = histogram(idleP(1,:),100);
    h0.FaceColor = 'cyan';
    title('1. Custom Idle #1')
subplot(xaxis,yaxis,2)
    h0 = histogram(idleP(2,:),100);
    h0.FaceColor = 'blue';
    title('2. Custom Idle #2')
subplot(xaxis,yaxis,3)
    h0 = histogram(idleP(3,:),100);
    h0.FaceColor = 'green';
    title('3. Custom Active #1')
subplot(xaxis,yaxis,4)
    h0 = histogram(idleP(4,:),100);
    h0.FaceColor = 'magenta';
    title('4. Custom Active #2')
    
fname = sprintf('dpm_simulator/example/Results/Custom_Idle_Histograms');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')

close all

%%
% create timings
for j=1:size(idleP,1)
    idle = idleP(j,:);
    active = activeP;
    time = 0;
    for i= 1:length(active)
        time = time + active(i);
        output (j,i,1) = time;
        time = time + idle(i);
        output (j,i,2) = time;
    end
end
%%
index = ones(1,size(output,1));
for j=1:size(output,1)
    while (1)
        filename = sprintf('dpm_simulator/example/Generated_workload_%d.%d.txt',index(j),j);
        if isfile(filename)
            % File exists.
            index(j) = index(j) + 1;
        else
            % File does not exist.
            towrite = squeeze(output(j,:,:));
            dlmwrite(filename,towrite,'delimiter',' ')
            disp(['"',filename , '" has saved successfully.']);
            break;
        end
    end
end

%%


clear 
clc
%%
%Initilize

func = "./dpm_simulator";
%
time = " -t";
idle_t = 0; %us
idle_t_step = 3;
sleep_t = 0; %us
sleep_t_step = 5;

%
history = " -h";
coeff_h = zeros(1,5);
%
psm = " -psm ";
psm_name = ["example/psm_new.txt", "example/psm.txt"];
psm_idx = 0;
wl = " -wl ";
wl_name = ["example/custom_workload_1.txt", "example/custom_workload_2.txt" ...
    ,"example/Generated_workload_1.1.txt", "example/Generated_workload_1.2.txt" ...
    ,"example/Generated_workload_1.3.txt","example/Generated_workload_1.4.txt"...
    ,"example/Generated_workload_1.5.txt"];
wl_min_max = [1,500; 1,500; 1,100; 1,400; 1,500; 1,500; 1,500];
%wl_min_max = [1,110; 1,10; 1,10; 1,10; 1,10; 1,10; 1,10; 1,10];

wl_idx = 0;
%#1 unknown 1
%#2 unknown 2
%Active: Uniform distribution, min = 1us, max = 500us, 5000 samples!
%#3 Uniform distribution, min = 1us, max=100us (high utilization)
%#4 Uniform distribution, min=1us, max=400us (low utilization)
%#5 Normal distribution, mean=100us, standard deviation=20
%#6 Exponential distribution, mean=50us
%#7 Tri-modal distribution – Mean = 50, 100, 150us – Standard deviation=10



%%
%make file

% disp("timeout policy");
% fileID = fopen('dpm_simulator/Tio_Run.bash','w');
% disp("#1 only idle");
% sleep_t = 0; %us
% psm_idx = 2;
% for wl_idx = 1:size(wl_name,2)
%     disp(wl_idx);
%     for idle_t = wl_min_max(wl_idx,1):idle_t_step:wl_min_max(wl_idx,2)
%         fprintf(fileID,func + time + " %.5g %.5g"+psm +psm_name(psm_idx)+ wl + wl_name(wl_idx) + " &\n",idle_t , sleep_t);
%     end
% end
% 
% disp("#2 idle and sleep");
% fileID = fopen('dpm_simulator/Tis_Run.bash','w');
% psm_idx = 1;
% for wl_idx = 1:size(wl_name,2)
%     disp(wl_idx);
%     for idle_t = wl_min_max(wl_idx,1):idle_t_step:wl_min_max(wl_idx,2)
%         for sleep_t = idle_t+1:sleep_t_step:wl_min_max(wl_idx,2)
%             fprintf(fileID,func + time + " %.5g %.5g"+psm +psm_name(psm_idx)+ wl + wl_name(wl_idx) + " &\n",idle_t , sleep_t);
%         end
%     end
% end

disp("#3 history");
% if (H_Model == 0)
% //Tidle[i]= K0+ K1·Tidle[i-1]+ K2·Tidle[i-1]^2 + K3·Tactive[i]+ K4·Tactive[i]^2
% else if (H_Model == 1) 
% //Tidle[i]= K0+ K1·Tidle[i-1]+ K2·Tidle[i-1]^4 + K3·Tidle[i-2]+ K4·Tidle[i-2]^5

%read Coeff
fullFileName = "dpm_simulator/example/Coeff_h.2.txt" ;
fID = fopen(fullFileName,'r');
data = fscanf(fID,'%f');
coeff= reshape(data,[],7);
fclose(fID); 
%generate history code 1
fileID = fopen('dpm_simulator/H_Run.bash','w');
psm_idx = 1;
for wl_idx = 1:size(wl_name,2)
    disp(wl_idx);
    coeff_h = coeff(:,wl_idx);
    for idle_t = wl_min_max(wl_idx,1):idle_t_step:wl_min_max(wl_idx,2)
        for sleep_t = idle_t+1:sleep_t_step:wl_min_max(wl_idx,2)
            fprintf(fileID,func + history + " %.3e %.3e %.3e %.3e %.3e %.5g %.5g"+psm +psm_name(psm_idx)+ wl + wl_name(wl_idx) + " &\n",...
                        coeff_h,idle_t , sleep_t);
        end
    end
end



fclose(fileID);

%./dpm_simulator -h 46.61 0.1357 -0.001201 0.007415 -1.574e-05 5.0 50.0 -psm example/psm_new.txt -wl example/custom_workload_1.txt














%%
% printf("\n******************************************************************************\n");
% printf(" DPM simulator: \n");
% printf("\t-t <timeout>: timeout of the timeout policy\n");
% printf("\t-h <Value1> …<Value5> <Threshold1> <Threshold2>: history-based policy \n");
% printf("\t   <Value1-5> value of coefficients\n");
% printf("\t   <Threshold1-2> predicted time thresholds\n");
% printf("\t-psm <psm filename>: the power state machine file\n");
% printf("\t-wl <wl filename>: the workload file\n");
% printf("******************************************************************************\n\n");
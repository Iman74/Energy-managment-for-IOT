clc
clear

%%
%make random Lengths
s = rng;
% Uniform distribution, min = 1us, max = 500us, 5000 samples!
activeP = randi([1 500],1,5000);
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
   idleP(5,i) = random('Normal',rnd*50,10);
end
%idleP(6,:) = [round(random('Normal',50,10,1,1666)) round(random('Normal',100,10,1,1668)) round(random('Normal',150,10,1,1666))]; 

%find any nonPositive element  <=0
nonPositive = numel((idleP)) - length(find(idleP>0));
if(nonPositive ==0)
    disp('all generated successfully.')
end
%histogram(idleP(5,:),500);


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




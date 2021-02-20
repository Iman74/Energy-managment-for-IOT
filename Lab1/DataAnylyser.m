%%
clc
%clear all
%z = cell(7,4)

clearvars -except sortedFileContents z


idleTimout = sortedFileContents(:,1);
sleepTimeout = sortedFileContents(:,2);
% activeTime = sortedFileContents(:,3);
% idleTime= sortedFileContents(:,4);
% totalTime = sortedFileContents(:,5);
% timeoutWaitnigTime = sortedFileContents(:,6);
% timeInActive = sortedFileContents(:,7);
% timeInIdle = sortedFileContents(:,8);
% timeInSleep = sortedFileContents(:,9);
% timeOverHead = sortedFileContents(:,10);
% numOfTrans = sortedFileContents(:,11);
energyOfTrans = sortedFileContents(:,12);
% energyWithTrans = sortedFileContents(:,13);
% energyWithoutTrans = sortedFileContents(:,14);
energySavedPercent = sortedFileContents(:,15);

z(7,:) = {idleTimout, energyOfTrans, energySavedPercent,sleepTimeout};
clearvars -except z
%%
baseAddress = "dpm_simulator/example/Mdata/history file method 2/Results/";
z2=z;
save (baseAddress+"Res_T_idleTimout",'z2');
clearvars -except z baseAddress
%% 2D
close all
%plot(idleTimout,energySavedPercent);
figure
linewidth = 1.5;
plot(cell2mat(z(1,1)),cell2mat(z(1,2)),'x-b','LineWidth', 2);
xlabel('Idle Timout')
ylabel('Transitions Energy Overhead')
hold on
plot(cell2mat(z(2,1)),cell2mat(z(2,2)),'*-r','LineWidth', linewidth);
plot(cell2mat(z(3,1)),cell2mat(z(3,2)),'+-g','LineWidth', linewidth);
plot(cell2mat(z(4,1)),cell2mat(z(4,2)),'^-c','LineWidth',linewidth);
plot(cell2mat(z(5,1)),cell2mat(z(5,2)),'v-m','LineWidth', linewidth);
plot(cell2mat(z(6,1)),cell2mat(z(6,2)),'p-y','LineWidth', linewidth);
plot(cell2mat(z(7,1)),cell2mat(z(7,2)),'s-k','LineWidth', linewidth);

legend ('custom_1','custom_2','Uniform_1', 'Uniform_2','Normall','Exponential','Tri-modal')

fname = sprintf(baseAddress+ 'Res_T_idlesleepTimout(Energy Overhead)');
set(gcf, 'Units', 'Normalized','OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')
saveas(gcf,fname)

%
figure
plot(cell2mat(z(1,1)),cell2mat(z(1,3)),'x-b','LineWidth', linewidth);

xlabel('Idle Timout')
ylabel('Energy Saved Percent')

hold on
plot(cell2mat(z(2,1)),cell2mat(z(2,3)),'*-r','LineWidth', linewidth);
plot(cell2mat(z(3,1)),cell2mat(z(3,3)),'+-g','LineWidth', linewidth);
plot(cell2mat(z(4,1)),cell2mat(z(4,3)),'^-c','LineWidth', linewidth);
plot(cell2mat(z(5,1)),cell2mat(z(5,3)),'v-m','LineWidth', linewidth);
plot(cell2mat(z(6,1)),cell2mat(z(6,3)),'p-y','LineWidth', linewidth);
plot(cell2mat(z(7,1)),cell2mat(z(7,3)),'s-k','LineWidth', linewidth);

legend ('custom_1','custom_2','Uniform_1', 'Uniform_2','Normall','Exponential','Tri-modal')

fname = sprintf(baseAddress+ 'Res_T_idlesleepTimout(Energy Saved Percent)');
set(gcf, 'Units', 'Normalized','OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')
saveas(gcf,fname)


%plot(x,y1,'g',x,y2,'b--o',x,y3,'c*')

%close all
%% 3D
close all
clc
figure
xaxis=2;
yaxis=4;

subplot(xaxis,yaxis,1)
    plotwhole(1,z);
    title('1. Custom #1')
subplot(xaxis,yaxis,2)
    plotwhole(2,z);
    title('2. Custom #2')
subplot(xaxis,yaxis,3)
    plotwhole(3,z);
    title('3. Idle Uniform #1')
subplot(xaxis,yaxis,4)
    plotwhole(4,z);
    title('4. Idle Uniform #2')
subplot(xaxis,yaxis,5)
    plotwhole(5,z);
    title('5. Idle Normal')
subplot(xaxis,yaxis,6)
    plotwhole(6,z);
    title('6. Idle Exponential')
subplot(xaxis,yaxis,7)
    plotwhole(7,z);
    title('7. Idle Tri-modal')
    
mod = 3; %2 for energy overhead 3 for Energy Saved Percent
if (mod==2)
    fname = sprintf(baseAddress+ 'Res_T_idlesleepTimout (Energy Overhead)');
else
    fname = sprintf(baseAddress+ 'Res_T_idlesleepTimout (Energy Saved Percent)');
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')
saveas(gcf,fname)



%%
clearvars -except sortedFileContents
close all
function []=plotwhole (Num,z)
    mod = 3; %2 for energy overhead 3 for Energy Saved Percent
    x= (cell2mat(z(Num,1)));
    s= (cell2mat(z(Num,4)));
    y = (cell2mat(z(Num,mod)));
    x_old = x(1);
    index= 1 ;
    i=1;
    while (i <= size(x,1))
        if (x(i) ~= x_old)
            x_old = x(i);
            index = [index,i];
        end
        i=i+1;
    end
    for i = 1:size(index,2)-1
        y_l = y(index(i):index(i+1)-1);
        s_l = s(index(i):index(i+1)-1);
        if (~isempty (find(y_l > y_l(end))))
            %i
        end
        plot(s_l,y_l);
        xlabel('Sleep Timout')
        if (mod==2)
            ylabel('Energy Overhead')
        else
            ylabel('Energy Saved Percent')
        end
        hold on
    end
    hold off
end
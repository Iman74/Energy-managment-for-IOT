%%
clc
%clear all
%z = cell(7,3)

clearvars -except sortedFileContents z


idleTimout = sortedFileContents(:,1);
%sleepTimeout = sortedFileContents(:,2);
% activeTime = sortedFileContents(:,3);
% idleTime= sortedFileContents(:,4);
% totalTime = sortedFileContents(:,5);
% timeoutWaitnigTime = sortedFileContents(:,6);
% timeInActive = sortedFileContents(:,7);
% timeInIdle = sortedFileContents(:,8);
% timeInSleep = sortedFileContents(:,9);
%timeOverHead = sortedFileContents(:,10);
% numOfTrans = sortedFileContents(:,11);
energyOfTrans = sortedFileContents(:,12);
% energyWithTrans = sortedFileContents(:,13);
% energyWithoutTrans = sortedFileContents(:,14);
energySavedPercent = sortedFileContents(:,15);

z(7,:) = {idleTimout, energyOfTrans, energySavedPercent};
%%
baseAddress = "dpm_simulator/example/Mdata/only idle/Results/";
save (baseAddress+"Res_T_idleTimout",'z');
%%
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

fname = sprintf(baseAddress+ 'Res_T_idleTimout(time Over Head)');
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

fname = sprintf(baseAddress+ 'Res_T_idleTimout(Energy Saved Percent)');
set(gcf, 'Units', 'Normalized','OuterPosition', [0 0 1 1]);
saveas(gcf,fname,'png')
saveas(gcf,fname)


%plot(x,y1,'g',x,y2,'b--o',x,y3,'c*')

%close all

%%
clearvars -except sortedFileContents
close all

clc
clear
fclose all;
%%
fileDetails = {};
fileContents = [];

while(1)
    files = dir('dpm_simulator/example/Rdata');
    if (length(files)<=2)
        disp ("no more file!!")
        break;
    end
    
    
    for k=1:length(files)
       fileName=files(k).name;
       if (fileName ~= "." && fileName ~= ".." )
            %read file Details
            fileDetail = strsplit(fileName,'~');
            %check for new set of files
            if (~isempty(fileDetails) && ~isequal(fileDetails(end,[1,4,5]) , fileDetail([1,4,5])))
                    %sava read results
                    %sFileName= strjoin(convertCharsToStrings(fileDetails(end,[1,4,5])),"~");
                    %sFileName = char(strcat("dpm_simulator/example/Mdata/" ,sFileName + ".mat"))
                    %sortedFileContents = sortrows(fileContents',[1,2]);
                    %save (sFileName,'sortedFileContents' );
                    %clear data sets
                    %fileDetails = {};
                    %fileContents = [];
                    continue;
            else
                %still old set
                fileDetails =[fileDetails ; fileDetail];


                %read files
                fullFileName = "dpm_simulator/example/Rdata/" + fileName;
                if isfile(fullFileName)
                    % File exists.
                    fileID = fopen(fullFileName,'r');
                    fileContents = [fileContents,[str2double(fileDetail(2));str2double(fileDetail(3));fscanf(fileID,'%f')]];
                    fclose(fileID);
                    %delete file
                    %recycle on; % Send deleted files to recycle bin
                    delete(fullFileName);
                else
                    disp("File does not exist!");
                end
            end
       end
    end


    %sava read results
    sFileName= strjoin(convertCharsToStrings(fileDetails(end,[1,4,5])),"~");
    sFileName = char(strcat("dpm_simulator/example/Mdata/" ,sFileName + ".mat"))
    sortedFileContents = sortrows(fileContents',[1,2]);
    %plot
    %figure('Name',sFileName);
    %plot(sortedFileContents(:,1),sortedFileContents(:,15));

    save (sFileName,'sortedFileContents' );
    %clear data sets
    fileDetails = {};
    fileContents = [];
end
%%
plot3(sortedFileContents(:,1),sortedFileContents(:,2),sortedFileContents(:,15))







%%
% printf("[sim] Active time in profile = %.6lfs \n", (curr_time - t_idle_ideal) * PSM_TIME_UNIT);
% printf("[sim] Idle time in profile = %.6lfs\n", t_idle_ideal * PSM_TIME_UNIT);
% printf("[sim] Total time = %.6lfs\n", curr_time * PSM_TIME_UNIT);
% printf("[sim] Timeout waiting time = %.6lfs\n", t_waiting * PSM_TIME_UNIT);
% for(int i = 0; i < PSM_N_STATES; i++) {
%     printf("[sim] Total time in state %s = %.6lfs\n", PSM_STATE_NAME(i),
%         t_state[i] * PSM_TIME_UNIT);
% }
% printf("[sim] Time overhead for transition = %.6lfs\n",t_tran_total * PSM_TIME_UNIT);
% printf("[sim] N. of transitions = %d\n", n_tran_total);
% printf("[sim] Energy for transitions = %.6fJ\n", e_tran_total * PSM_ENERGY_UNIT);
% printf("[sim] Energy w/o DPM = %.6fJ, Energy w DPM = %.6fJ\n",e_total_no_dpm * PSM_ENERGY_UNIT, e_total * PSM_ENERGY_UNIT);
% printf("[sim] %2.1f percent of energy saved.\n", 100*(e_total_no_dpm - e_total) /e_total_no_dpm);


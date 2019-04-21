function runOrientation(fileFolder)
    logs = dir(strcat(fileFolder,'\Logs\*.txt'));
    for i = 1:length(logs)
        data = reader(strcat(logs(i).folder,'\', logs(i).name));
        sessionName = strcat("Orientation_",num2str(i));
%         sessionName = logs(i).name;
        plotOrientation(data.orientation,sessionName,fileFolder);
    end
    disp("end of plotting function");
end

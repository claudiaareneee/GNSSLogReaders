function runOrientationAndCN0(fileFolder)
    logs = dir(strcat(fileFolder,'\Logs\*.txt'));
    for i = 1:length(logs)
        data = reader(strcat(logs(i).folder,'\', logs(i).name));
        sessionName = strcat("session_",num2str(i));
        plotOrientationAndCN0(data.measurements,data.orientation,sessionName,fileFolder);
    end
    disp("end of plotting function");
end

function plotOrientationAndCN0(measurements,orientation,sessionName,fileFolder)
    mapKeys = cell2mat(keys(measurements));
    
    ori_time = [orientation.time]/1000;
    ori_az = [orientation.azimuth];
    ori_roll = [orientation.roll];
    ori_pitch = [orientation.pitch];
    
    % If I want it in degrees
%     ori_az = radtodeg(ori_az);
%     ori_roll = radtodeg(ori_roll);
%     ori_pitch = radtodeg(ori_pitch);

    initial_time = ori_time(1);
    ori_time = ori_time - initial_time;
    
    for i = 1:length(keys(measurements))
        fig = configurePlot();
        
        % Azimuth info
        plot(ori_time,ori_az, 'k');
        legend_strings = ["Azimuth"];
        
        % Roll and Pitch info -- comment this out if you don't have it
        plot(ori_time,ori_roll, 'r');
        legend_strings = [legend_strings; "Roll"];
        plot(ori_time,ori_pitch, 'g');
        legend_strings = [legend_strings; "Pitch"];
        
        % Reading the measurements by satellite
        currentMap = measurements(mapKeys(i));
        currentKeys = cell2mat(keys(currentMap));
        
        for j = 1:length(currentKeys)
            signaltype = getInfo(mapKeys(i),currentKeys(j));
            title = signaltype.id;
            signaltype = signaltype.signalType;
            legend_strings = [legend_strings; signaltype];
            data = currentMap(currentKeys(j));
            time = data(:, 1);
            time = time/1000;
            time = time - initial_time;
            cn0 = data(:, 2);
            plot(time, cn0);
        end
        
        postPlot(legend_strings,strcat(sessionName, " ", title));
        ylim([-2*pi 60]);
        file_name = strcat(sessionName,"_",num2str(mapKeys(i)));
        saveGraphs(fileFolder,file_name,fig);
    end
end

function plotCN0andRinex(gnss_initial_time,gnss,rinex,sessionName,fileFolder)
gnssMapKeys = cell2mat(keys(gnss));

for i = 1:length(keys(gnss))
    fig = configurePlot();
    legend_strings = [];
    
    % Reading the measurements by satellite
    currentMap = gnss(gnssMapKeys(i));
    currentKeys = cell2mat(keys(currentMap));
    
    if(isKey(rinex,gnssMapKeys(i)))
        currentRinexMap = rinex(gnssMapKeys(i));
        currentRinexKeys = cell2mat(keys(currentRinexMap));
        for j = 1:length(currentRinexKeys)
            legend_strings = [legend_strings; strcat("Rinex L",num2str(currentRinexKeys(j)))];
            data = currentRinexMap(currentRinexKeys(j));
            time = data(:, 1);
            cn0 = data(:, 2);
            plot(time, cn0);
        end
    end
    
    for j = 1:length(currentKeys)
        signaltype = getInfo(gnssMapKeys(i),currentKeys(j));
        title = signaltype.id;
        signaltype = signaltype.signalType;
        legend_strings = [legend_strings; strcat("GNSS ", signaltype)];
        data = currentMap(currentKeys(j));
        time = data(:, 1);
        time = time - gnss_initial_time;
        time = time/1000;
        cn0 = data(:, 2);
        plot(time, cn0);
    end
    
    postPlot(legend_strings,title);
    
    file_name = strcat(sessionName,"_",num2str(gnssMapKeys(i)));
    saveGraphs(fileFolder,file_name,fig);
    
end

rinexMapKeys = cell2mat(keys(rinex));
for i = 1:length(keys(rinex))
    if ~isKey(gnss,rinexMapKeys(i))
        fig = configurePlot();
        
        legend_strings = [];
        
        % Reading the measurements by satellite
        currentMap = rinex(rinexMapKeys(i));
        currentKeys = cell2mat(keys(currentMap));
        for j = 1:length(currentKeys)
            legend_strings = [legend_strings; strcat("Rinex L", num2str(currentKeys(j)))];
            data = currentMap(currentKeys(j));
            time = data(:, 1);
            cn0 = data(:, 2);
            plot(time, cn0);
        end
        
        postPlot(legend_strings, num2str(rinexMapKeys(i)));
        
        file_name = strcat(sessionName,"_",num2str(gnssMapKeys(i)));
        saveGraphs(fileFolder,file_name,fig);
    end
end
end


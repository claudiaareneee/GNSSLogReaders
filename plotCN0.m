function plotDualCN0(gnss,initial_time,sessionName,fileFolder)
gnssMapKeys = cell2mat(keys(gnss));

for i = 1:length(keys(gnss))
    fig = configurePlot();
    legend_strings = [];
    
    % Reading the measurements by satellite
    currentMap = gnss(gnssMapKeys(i));
    currentKeys = cell2mat(keys(currentMap));
    
    for j = 1:length(currentKeys)
        signaltype = getSignalType(floor(gnssMapKeys(i)/100.0),currentKeys(j));
        legend_strings = [legend_strings; signaltype];
        data = currentMap(currentKeys(j));
        time = data(:, 1);
        time = time - initial_time;
        time = time/1000;
        cn0 = data(:, 2);
        plot(time, cn0);
    end
    
    postPlot(legend_strings,num2str(gnssMapKeys(i)));
    
    file_name = strcat(sessionName,"_",num2str(gnssMapKeys(i)));
    saveGraphs(fileFolder,file_name,fig);
    
end
end
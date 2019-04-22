function runCN0(gnssFile)
fileFolder = strsplit(gnssFile, '/');
fileFolder = fileFolder{end-1};
gnss_data = reader(gnssFile);
sessionName = strcat("gnss");
plotCN0(gnss_data.measurements, gnss_data.initial_time, sessionName,fileFolder);

disp("end of plotting function");
end

function plotCN0(gnss,initial_time,sessionName,fileFolder)
gnssMapKeys = cell2mat(keys(gnss));

for i = 1:length(keys(gnss))
    fig = configurePlot();
    legend_strings = [];
    
    % Reading the measurements by satellite
    currentMap = gnss(gnssMapKeys(i));
    currentKeys = cell2mat(keys(currentMap));
    
    for j = 1:length(currentKeys)
        signaltype = getInfo(gnssMapKeys(i),currentKeys(j));
        title = signaltype.id;
        signaltype = signaltype.signalType;
        legend_strings = [legend_strings; signaltype];
        data = currentMap(currentKeys(j));
        time = data(:, 1);
        time = time - initial_time;
        time = time/1000;
        cn0 = data(:, 2);
        plot(time, cn0);
    end
    
    postPlot(legend_strings,title);
    
    file_name = strcat(sessionName,"_",num2str(gnssMapKeys(i)));
    saveGraphs(fileFolder,file_name,fig);
    
end
end
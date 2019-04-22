function run2cn0s(AFile, BFile)

fileFolder = strsplit(AFile, '/');
fileFolder = fileFolder{end-1};

a_data = reader(AFile);
gnss_initial_time = a_data.initial_time;

b_data = reader(BFile);
sessionName = strcat("session");
plotCN0andRinex(gnss_initial_time,a_data.measurements,b_data.measurements,sessionName,fileFolder);

disp("end of plotting function");
end

function plotCN0andRinex(gnss_initial_time,A,B,sessionName,fileFolder)
AmapKeys = cell2mat(keys(A));

for i = 1:length(keys(A))
    fig = configurePlot();
    legend_strings = [];
    
    % Reading the measurements by satellite
    currentMap = A(AmapKeys(i));
    currentKeys = cell2mat(keys(currentMap));
    
    if(isKey(B,AmapKeys(i)))
        currentBmap = B(AmapKeys(i));
        currentBkeys = cell2mat(keys(currentBmap));
        for j = 1:length(currentBkeys)
            signaltype = getInfo(AmapKeys(i),currentKeys(j));
            signaltype = signaltype.signalType;
            legend_strings = [legend_strings; strcat("B ", signaltype)];
            data = currentBmap(currentBkeys(j));
            time = data(:, 1);
            time = time - gnss_initial_time;
            time = time/1000;
            cn0 = data(:, 2);
            plot(time, cn0);
        end
    end
    
    for j = 1:length(currentKeys)
        signaltype = getInfo(AmapKeys(i),currentKeys(j));
        title = signaltype.id;
        signaltype = signaltype.signalType;
        legend_strings = [legend_strings; strcat("A ", signaltype)];
        data = currentMap(currentKeys(j));
        time = data(:, 1);
        time = time - gnss_initial_time;
        time = time/1000;
        cn0 = data(:, 2);
        plot(time, cn0);
    end
    
    postPlot(legend_strings,title);
    
    file_name = strcat(sessionName,"_",num2str(AmapKeys(i)));
    saveGraphs(fileFolder,file_name,fig);
    
end

BmapKeys = cell2mat(keys(B));
for i = 1:length(keys(B))
    if ~isKey(A,BmapKeys(i))
        fig = configurePlot();
        
        legend_strings = [];
        
        % Reading the measurements by satellite
        currentMap = B(BmapKeys(i));
        currentKeys = cell2mat(keys(currentMap));
        for j = 1:length(currentKeys)
            signaltype = getInfo(AmapKeys(i),currentKeys(j));
            title = signaltype.id;
            signaltype = signaltype.signalType;
            legend_strings = [legend_strings; strcat("B ", signaltype)];
            data = currentMap(currentKeys(j));
            time = data(:, 1);
            time = time - gnss_initial_time;
            time = time/1000;
            cn0 = data(:, 2);
            plot(time, cn0);
        end
        
        postPlot(legend_strings, num2str(BmapKeys(i)));
        
        file_name = strcat(sessionName,"_",num2str(AmapKeys(i)));
        saveGraphs(fileFolder,file_name,fig);
    end
end
end

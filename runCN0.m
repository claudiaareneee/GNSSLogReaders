function runCN0(fileFolder, gnssFile)
    gnss_data = reader(gnssFile);
    sessionName = strcat("gnss");
    plotCN0(gnss_data.measurements, gnss_data.initial_time, sessionName,fileFolder);
  
    disp("end of plotting function");
end
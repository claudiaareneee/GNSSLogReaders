function runCN0andRinex(fileFolder, gnssFile, rinexFile)
    gnss_data = reader(gnssFile);
    gnss_initial_time = gnss_data.initial_time;

    rinex_data = readerRinex(rinexFile);
    sessionName = strcat("session");
    plotCN0andRinex(gnss_initial_time,gnss_data.measurements,rinex_data,sessionName,fileFolder);
    
    disp("end of plotting function");
end

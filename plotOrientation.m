function plotOrientation(orientation,sessionName,fileFolder)
% Putting time in seconds
ori_time = [orientation.time]/1000;
ori_az = [orientation.azimuth];
ori_roll = [orientation.roll];
ori_pitch = [orientation.pitch];

% If I want it in degrees
ori_az = rad2deg(ori_az);
ori_roll = rad2deg(ori_roll);
ori_pitch = rad2deg(ori_pitch);

initial_time = ori_time(1);
ori_time = ori_time - initial_time;

fig = configurePlot();

% Azimuth info
plot(ori_time,ori_az, 'r');
legend_strings = ["Azimuth"];

% Roll and Pitch info -- comment this out if you don't have it
plot(ori_time,ori_roll, 'g');
legend_strings = [legend_strings; "Roll"];
plot(ori_time,ori_pitch, 'm');
legend_strings = [legend_strings; "Pitch"];


postPlot(legend_strings, strcat(sessionName, "_Orientation"));
% Additional plot configurations
ylim([-200 200]);
yticks(-180:30:180)
ytickformat('degrees');

saveGraphs(fileFolder,strcat(sessionName, "_Orientation"), fig);
end
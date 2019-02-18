% function [SignalData, time_arr, pos, date] = readRinexObs303(filename)
function [SignalData, time_arr, pos, date] = readRinexObs303()

% TODO Read RINEX Obs File and Output PRN and signal strength
%  will eventually be used with skyplot info

% vars
filename = "GNSSReader\AGEOP032Q.19o"; % Rinex 3.03 O file

% only returns data at times of multiples of 15 minutes -> coincide with
% SP3 files

% open the file
fid = fopen(filename);
line = fgetl(fid);

%find approx position for calculations, this'll be fine for our purposes
while ~contains(line, 'APPROX')
    line = fgetl(fid);
end
pos = sscanf(line, '%f', [1 3]);

% find start of data
while (line ~= -1)
    if contains(line, ">")
        
        break
    end
    line = fgetl(fid);
        
end
% gettin info
init_data = sscanf(line(2:length(line)), '%f', [1 8]);
time = init_data(4:5); % this is the starting time
date = init_data(1:3);
% if not a multiple of 15, find next multiple of 15
%trying to make this compatible with the sp3 files
if ( mod(time(2), 15) ~= 0)
    % if not a multiple of 15, find next multiple of 15
    % 0 through 15
    if ( time(2) < 15 && time(2) > 0)
        time(2) = 15;
    end
    % 15 through 30
    if ( time(2) < 30 && time(2) > 15)
        time(2) = 30;
    end
    % 30 through 45
    if ( time(2) < 45 && time(2) > 30)
        time(2) = 45;
    end
    % 45 through 60
    if ( time(2) < 60 && time(2) > 45)
        time(1) = time(1) + 1;
        time(2) = 0;
    end 
end

% now need to find the next section that has that time

while (line ~= -1)
    if contains(line, ">")
         data = sscanf(line(2:length(line)), '%f', [1 8]);
         time_check = init_data(4:5);
         if ( time_check == time)
             break
         end
    end
    line = fgetl(fid);
end 
% now at the line where time is 
% date = init_data(1:3); % year, month, day
x = 1;
time_arr = [time];
while( line ~= -1)
   % get signal data
   line = fgetl(fid);
   
   while (~contains(line, ">") && line(1) == 'G')
       len = length(line);
       info = str2num(line(2:len));
    SignalData(x).PRN = info(1);
    SignalData(x).Strength = info(5);
    SignalData(x).Time = time;
    line = fgetl(fid);
    x = x + 1;
   end
   % get next time
   time(2) = time(2) + 15;
   if( time(2) > 59)
      time(1) = time(1) + 1;
      time(2) = time(2) - 60;
   end
   time_arr = [time_arr, time];
   
   % find next section
   line = fgetl(fid);
   current = str2num(line(3:length(line)));
   while (~isequal(current(4:5), time) & (line ~= -1))
       line = fgetl(fid);
       if(line ~=-1)
        current = str2num(line(3:length(line)));
       end
       
   end
end

end
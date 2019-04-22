function GNSS_data = reader(fileName)

fid = fopen(fileName);

% read header
lineNum = 1;
line = fgetl(fid);
while ~(strcmp(line(1:1),'#'))
    lineNum = lineNum+1;
    line = fgetl(fid);
end

% initialize variables
status_index = 1;
status = [];

orientation_index = 1;
orientation = [];

fix_index = 1;
fix = [];

measurements_index = 1;
measurements = [];

% read body
while (~(feof(fid)))
    lineNum = lineNum+1;
    line = fgetl(fid);
    
    % Empty line
    if (isempty(line) || length(line) == 0)
        continue;
        
    % Status line
    elseif (isequal(line(1),'S'))
        %format string and pull data
        line = line(8:length(line)-1);
        line = textscan(line, '%32f,%d,%d,%f,%f,%f');
        
        status(status_index).time = cell2mat(line(1));
        status(status_index).unique_id = cell2mat(line(2))*100 + cell2mat(line(3));
        status(status_index).constellation = cell2mat(line(2));
        status(status_index).svid = cell2mat(line(3));
        status(status_index).cn0 = cell2mat(line(4));
        status(status_index).carrierFreq = cell2mat(line(5));
        
        status_index = status_index + 1;
        
    % Orientation line
    elseif (isequal(line(1),'O'))
        %format string and pull data
        line = line(13:end);
        line = textscan(line, '%32f%f%f%f','delimiter', ',');
        
        orientation(orientation_index).time = cell2mat(line(1));
        orientation(orientation_index).azimuth = cell2mat(line(2));
        orientation(orientation_index).pitch = cell2mat(line(3));
        orientation(orientation_index).roll = cell2mat(line(4));
        
        orientation_index = orientation_index + 1;
    
    % Fix location line
    elseif (isequal(line(1),'F'))
        %format string and pull data
        line = line(5:end);
        line = textscan(line, '%32f%s%f','delimiter', ',');
        
        fix(fix_index).time = cell2mat(line(1));
        fix(fix_index).constellation = string(line(2));
        fix(fix_index).svid = cell2mat(line(3));
        
        fix_index = fix_index + 1;
        
    % Raw measurements line
    elseif (isequal(line(1),'R'))
        %format string and pull data
        line = line(5:length(line)-1);
        line = textscan(line, '%32f,%d,%d,%32f,%f');
        
        measurements(measurements_index).time = cell2mat(line(1));
        measurements(measurements_index).unique_id = cell2mat(line(2))*100 + cell2mat(line(3));
        measurements(measurements_index).constellation = cell2mat(line(2));
        measurements(measurements_index).svid = cell2mat(line(3));
        measurements(measurements_index).cn0 = cell2mat(line(4));
        measurements(measurements_index).carrierFreq = cell2mat(line(5));
        
        measurements_index = measurements_index + 1;
    end
    

end

% finished reading file
fclose(fid);
if(~isempty(measurements) && ~isempty(status))
    if(measurements(1).time > status(1).time)
        initial_time = status.time;
    else
        initial_time = measurements.time;
    end
elseif(~isempty(measurements))
    initial_time = measurements.time;
elseif(~isempty(status))
    initial_time = status.time;
else
    initial_time = 0;
end

GNSS_data.initial_time = initial_time;

% Reorganizing satellite recordings by satellite ID's by converting cell
% array to Map
if ~isempty(measurements)
    GNSS_data.measurements = organizing_data(measurements);
end
if ~isempty(status)
    GNSS_data.status = organizing_data(status);
end
GNSS_data.fix = fix;
GNSS_data.orientation = orientation;
end

function data = organizing_data(gnss_data)
initial_time = 0; % OR initial_time = gnss_data.time;

% Sort rows by satellite ID's
gnss_data = reorder_struct(gnss_data);

% Initial satellite ID
satellite = cell2mat(gnss_data(1, 2));
start_index = 1;

% Map our data will populate
data = containers.Map('KeyType','double','ValueType','any');

% If column 6 is empty, that means that the phone did not record carrier
% frequencies and therefore is probably not dual frequency
if isempty(cell2mat(gnss_data(:,6)))
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            cn0 = cell2mat(gnss_data(start_index:(i-1),5));
            
            data_by_frequency = containers.Map('KeyType','double','ValueType','any');
            for j = 1:length(time)
                if~(isKey(data_by_frequency, 1))
                    data_by_frequency(1) = [time(j) cn0(j)];
                    continue;
                end
                
                data_by_frequency(1) = [data_by_frequency(1); [time(j) cn0(j)]];
            end
            
            data(current_satellite) = data_by_frequency;
            start_index = i;
            satellite = current_satellite;
        end
    end
% Else: this phone recorded dual frequencies - so we need to diferentiate
% between L1 and L5 by carrier frequencies
else
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            cn0 = cell2mat(gnss_data(start_index:(i-1),5));
            frequencies = cell2mat(gnss_data(start_index:(i-1),6));
            
            % A map to specify between frequencies 
            data_by_frequency = containers.Map('KeyType','double','ValueType','any');
            for j = 1:length(time)
                if~(isKey(data_by_frequency, frequencies(j)))
                    data_by_frequency(frequencies(j)) = [time(j) cn0(j)];
                    continue;
                end
                
                data_by_frequency(frequencies(j)) = [data_by_frequency(frequencies(j)); [time(j) cn0(j)]];
            end
            
            data(current_satellite) = data_by_frequency;
            start_index = i;
            satellite = current_satellite;
        end
    end
end
end

function data_set = reorder_struct(gnss_data)
fields = fieldnames(gnss_data);
cells = struct2cell(gnss_data);
sz = size(cells);

% Convert to a matrix
cells = reshape(cells, sz(1), []);      % Px(MxN)

% Make each field a column
cells = cells';                         % (MxN)xP

% Sort by first field "name"
data_set = sortrows(cells, 2);

end

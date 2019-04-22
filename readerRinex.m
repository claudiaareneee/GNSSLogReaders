function data = readerRinex(fileName)
% Reads v3.03 rinex files and stores the values the same way reader.m
% stores them

fid = fopen(fileName);

% read headers
line = fgetl(fid);
while ~(contains(line,">"))
    line = fgetl(fid);
end

% read data
data = [];
data_index = 1;
initial_time_line = cell2mat(textscan(line(3:end), '%f '));
initial_time = initial_time_line(6);
initial_time = initial_time + 60 * initial_time_line(5) + 3600 * initial_time_line(4);

while (~feof(fid))
    if (contains(line,">"))
        line = cell2mat(textscan(line(3:end), '%f '));
        if ~(isempty(line))
            current_time = line(6);
            current_time = current_time + 60 * line(5) + 3600 * line(4);
        end
    else
        svid = str2num(line(2:3));
        % Constellations: 1. GPS, 2. SBAS, 3. GLONASS, 4. QZSS, 5. BEIDUO, 6.Galileo
        % See Rinex documentation for any additional information
        switch line(1)
            case 'G' % GPS
                svid = 1*100 + svid;
            case 'R' % GLONASS
                svid = 3*100 + svid;
            case 'S' % SBAS
                svid = 2*100 + svid;
            case 'E' % Galileo
                svid = 6*100 + svid;
            case 'C' % Beidou
                svid = 5*100 + svid;
            case 'J' % QZSS
                svid = 4*100 + svid;
            case 'I' % IRNSS
                svid = 7*100 + svid;
            otherwise
                svid = 8*100 + svid;
        end
        line = cell2mat(textscan(line(4:end), '%f '));
        if length(line >= 4)
            cn0 = line(4);
            data(data_index).time = current_time - initial_time;
            data(data_index).svid = svid;
            data(data_index).cn0 = cn0;
            data(data_index).carrierFreq = 1; % for L1
            if(length(line)>4)
                data_index = data_index + 1;
                cn0 = line(8);
                data(data_index).time = current_time - initial_time;
                data(data_index).svid = svid;
                data(data_index).cn0 = cn0;
                data(data_index).carrierFreq = 5; % for L5
            end
            data_index = data_index + 1;

        end
    end
    
    line = fgetl(fid);
    
    
    if( current_time < initial_time)
        break;
    end
end

data = organizing_data(data);
end

function data = organizing_data(gnss_data)
initial_time = 0; %gnss_data.time;
gnss_data = reorder_struct(gnss_data);

%     Getting the index
satellite = cell2mat(gnss_data(1, 2));
start_index = 1;

data = containers.Map('KeyType','double','ValueType','any');

if size(gnss_data,2)== 3
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            cn0 = cell2mat(gnss_data(start_index:(i-1),3));
            
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
else
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            cn0 = cell2mat(gnss_data(start_index:(i-1),3));
            frequencies = cell2mat(gnss_data(start_index:(i-1),4));
            
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

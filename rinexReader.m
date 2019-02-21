function data = rinexReader(fileName)

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
%                 current_time = current_time + 60 * line(5) + 3600 * line(4) + 604800 * line(3);
            end
        else
            svid = str2num(line(2:3));
            %3 14 16 16 16 16 17 15 16 16 16 16 16
            switch line(1)
                case 'G'
                    svid = 1*100 + svid;
                case 'R'
                    svid = 2*100 + svid;
                case 'E'
                    svid = 3*100 + svid;
                case 'C'
                    svid = 4*100 + svid;
                case 'J'
                    svid = 5*100 + svid;
                otherwise
                    svid = 6*100 + svid;
            end
%             line = cell2mat(textscan(line(50:end), '%f '));
%             
%             cn0 = line(1);
            line = cell2mat(textscan(line(4:end), '%f '));            
%             if (length(line) <= 3)
            cn0 = line(4); 
            data(data_index).time = current_time;
            data(data_index).svid = svid;
            data(data_index).cn0 = cn0;
            data_index = data_index + 1;
%             end
           
        end
       
        
        line = fgetl(fid);
        
        
        if( current_time < initial_time)
            break;
        end
    end
%     gnss_status = struct2cell(data);
%     
%     time = gnss_status(1,:);
%     svid = gnss_status(2,:);
%     cn0  = gnss_status(3,:);
    
    
end

% =========================================================================
function [ fid, rec_xyz, observables ] = read_rinex_header( file_name )

% Initialize the observables variable.
observables={};

% Assign a file ID and open the given header file.
fid=fopen(file_name);

% If the file does not exist, scream bloody murder!
if fid == -1
    display('Error!  Header file does not exist.');
else    
    % Set up a flag for when the header file is done.
    end_of_header=0;
    
    % Get the first line of the file.
    current_line = fgetl(fid);
    
    % If not at the end of the file, search for the desired information.
    while end_of_header ~= 1        
        % Search for the approximate receiver location line.
        if strfind(current_line,'APPROX POSITION XYZ')
            
            % Read xyz coordinates into a matrix.
            [rec_xyz] = sscanf(current_line,'%f');
        end
        
        % Search for the number/types of observables line.
        if strfind(current_line,'# / TYPES OF OBSERV')            
            % Read the non-white space characters into a temp variable.
            [observables_temp] = sscanf(current_line,'%s');            
            
            % Read the number of observables space and then create
            % a matrix containing the actual observables.
            for ii = 1:str2num(observables_temp(1))                
                observables{ii} = observables_temp( 2*ii : 2*ii+1 );
            end          
        end
                  
        % Get the next line of the header file.
        current_line = fgetl(fid);
        
        %Check if this line is at the end of the header file.
        if strfind(current_line,'END OF HEADER')
            end_of_header=1;
        end        
    end
end
end

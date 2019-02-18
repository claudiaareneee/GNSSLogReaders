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

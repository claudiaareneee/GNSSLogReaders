function GNSS_data = reader(fileName)

    fid = fopen(fileName);

    % read header
    line = fgetl(fid);
    while ~(strcmp(line(1:1),'#'))
       line = fgetl(fid);
    end

    status_index = 1;
    status = [];

    orientation_index = 1;
    orientation = [];

    fix_index = 1;
    fix = [];

    % read body
    while (~(feof(fid)))
        line = fgetl(fid);

        if (isempty(line) || length(line) == 0)
            continue;
%         elseif (contains(line,">"))
%             time = cell2mat(textscan(line(2:end), '%f '));
        elseif (isequal(line(1),'S'))
            %format string and pull data
            line = line(8:length(line)-1);

            line = textscan(line, '%32f,%d,%d,%f,%f,%f');

            status(status_index).time = cell2mat(line(1));
%             status(status_index).time = time;
            status(status_index).unique_id = cell2mat(line(2))*100 + cell2mat(line(3));
            status(status_index).constellation = cell2mat(line(2));
            status(status_index).svid = cell2mat(line(3));
            status(status_index).cn0 = cell2mat(line(4));
            status(status_index).elevation = cell2mat(line(5));
            status(status_index).azimuth = cell2mat(line(6));


            status_index = status_index + 1;

        elseif (isequal(line(1),'O'))
            %format string and pull data
            line = textscan(line, '%s,%32f,%f,%f,%f');

            orientation(orientation_index).time = cell2mat(line(2));
            orientation(orientation_index).roll = cell2mat(line(3));
            orientation(orientation_index).pitch = cell2mat(line(4));
            orientation(orientation_index).azimuth = cell2mat(line(5));

            orientation_index = orientation_index + 1;
        elseif (isequal(line(1),'F'))
            line = textscan(line, '%s,%32f,%s,%f');

            fix(fix_index).time = cell2mat(line(2));
            fix(fix_index).constellation = cell2mat(line(3));
            fix(fix_index).svid = cell2mat(line(4));


            fix_index = fix_index + 1;

        else

        end

    end

    fclose(fid);

    GNSS_data.status = status;
    GNSS_data.fix = fix;
    GNSS_data.orientation = orientation;
end
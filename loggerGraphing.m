function loggerGraphing(fname1,fname2)
    hold on
    legend_strings = {};
    A_gnss = loggerReader(fname1);
    B_gnss = loggerReader(fname2);

    A_gnss = A_gnss.status;
    B_gnss = B_gnss.status;
    
    time_A = A_gnss.time;
    time_B = B_gnss.time;
    
    if(time_A <= time_B)
       initial_time = time_A;
    else
       initial_time = time_B;
    end
    
%     initial_time = time_A;



%     legend_strings = graph_all_data(A_gnss,initial_time,"A",legend_strings);
   
%     graph_all_data(B_gnss,initial_time,"B",legend_strings);

    
    data1 = organizing_data(A_gnss, initial_time);
    data2 = organizing_data(B_gnss, initial_time);
    
    graph_matching(data1,data2);

%     graph_data_seperately(A_gnss,initial_time,"A");
%     
%     graph_data_seperately(B_gnss,initial_time,"B");
end



function data = organizing_data(gnss_data, initial_time)
%     data.time = gnss_data.time;
%     data.id = gnss_data.uniqueId;
%     data.cn0 = gnss_data.cn0;
%     
%     gnss_data = data;
    
    gnss_data = reorder_struct(gnss_data);

%     Getting the index
    satellite = cell2mat(gnss_data(1, 2));
    start_index = 1;
   
    data = containers.Map('KeyType','double','ValueType','any');
    
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            
            cn0 = cell2mat(gnss_data(start_index:(i-1),5));  
            
            data(current_satellite) = [time, cn0];            
            start_index = i;
            satellite = current_satellite;
        end
    end
end


function graph_matching(A_data, B_data)
    A_keys = keys(A_data);
    B_keys = keys(B_data);
    
    hold on;
        
    for i= 1:length(A_keys)
        key = cell2mat(A_keys(i));
        if isKey(B_data,key)
            figure;
            hold on;
            A_values = A_data(key);
            B_values = B_data(key);
            
            plot(A_values(:,1),A_values(:,2));
            plot(B_values(:,1),B_values(:,2));
            
            legend('A','B');
            title(num2str(key));
            
            hold off;
        end
        
        
    end
end





function legend_strings = graph_all_data(gnss_data, initial_time, graph_title, legend_strings)
    gnss_data = reorder_struct(gnss_data);
%     figure1 = figure;
%     Getting the index
    satellite = cell2mat(gnss_data(1, 2));
    start_index = 1;
%     legend_strings = {};
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            cn0 = cell2mat(gnss_data(start_index:(i-1),5));
            if(satellite == 609)
            plot(time,cn0);
            
%             hold on;
            
%             legend_strings{end+1} = num2str(satellite);
            legend_strings{end + 1} = graph_title + num2str(satellite);
            end
            
            start_index = i;
            satellite = current_satellite;
        end
    end
    title(graph_title);
    legend(legend_strings);
%     hold off;
end


function graph_data_seperately(gnss_data, initial_time, graph_title)
    gnss_data = reorder_struct(gnss_data);
%     Getting the index
    satellite = cell2mat(gnss_data(1, 2));
    start_index = 1;
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            figure();
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            cn0 = cell2mat(gnss_data(start_index:(i-1),5));
            plot(time,cn0);
            
            hold on;
            start_index = i;
            satellite = current_satellite;
            
            title(graph_title + num2str(satellite));
            hold off;
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
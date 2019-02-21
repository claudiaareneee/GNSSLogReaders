function rinexGrapher(fname1, fname2)
    obs1= rinexReader(fname1);
    obs2= rinexReader(fname2);
    
    time_A = obs1.time;
    time_B = obs2.time;
    
    if(time_A <= time_B)
       initial_time = time_A;
    else
       initial_time = time_B;
    end
    
    obs1 = organizing_data(obs1,initial_time);
    obs2 = organizing_data(obs2,initial_time);
   
    graph_matching(obs1,obs2);
end

function rinexGrapher4(fname1, fname2, fname3, fname4)
    obs1= rinexReader(fname1);
    obs2= rinexReader(fname2);
    obs3= rinexReader(fname3);
    obs4= rinexReader(fname4);
    
    time_1 = obs1.time;
    time_2 = obs2.time;
    time_3 = obs3.time;
    time_4 = obs4.time;
    
    initial_time = min([time_1 time_2 time_3 time_4]);
    
    obs1 = organizing_data(obs1,initial_time);
    obs2 = organizing_data(obs2,initial_time);
    obs3 = organizing_data(obs3,initial_time);
    obs4 = organizing_data(obs4,initial_time);
   
    graph_matching4(obs1,obs2,obs3,obs4);
end


function data = organizing_data(gnss_data, initial_time)
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
            
            cn0 = cell2mat(gnss_data(start_index:(i-1),3));  
            
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

function graph_matching4(data1, data2, data3, data4)
    data1_keys = keys(data1);
%     data2_keys = keys(data2);
%     data3_keys = keys(data3);
%     data4_keys = keys(data4);
    
    for i= 1:length(data1)
        figure;
        hold on;
        
        legend_strings = ["data1"];
        
        key = cell2mat(data1_keys(i));
        data1_values = data1(key);
        plot(data1_values(:,1),data1_values(:,2));

        
        if isKey(data2,key)    
            data2_values = data2(key);
            plot(data2_values(:,1),data2_values(:,2));
            
            legend_strings = [legend_strings, "data2"];
        end
        
        if isKey(data3,key)    
            data3_values = data3(key);
            plot(data3_values(:,1),data3_values(:,2));
            
            legend_strings = [legend_strings, "data3"];
        end
        
        if isKey(data4,key)    
            data4_values = data4(key);
            plot(data4_values(:,1),data4_values(:,2));
            
            legend_strings = [legend_strings, "data4"];
        end
        
        legend(legend_strings);
        title(num2str(key));
            
        hold off;
    end
end


function legend_strings = graph_all_data(gnss_data, graph_title, legend_strings, initial_time)
%     initial_time = gnss_data.time;
    gnss_data = reorder_struct(gnss_data);
%     figure1 = figure;
    hold on;
%     
%     Getting the index
    satellite = cell2mat(gnss_data(1, 2));
    start_index = 1;
%     legend_strings = {};
    for i = 1:length(gnss_data)
        current_satellite = cell2mat(gnss_data(i, 2));
        if(current_satellite ~= satellite)
            time = cell2mat(gnss_data(start_index:(i-1),1));
            time = time - initial_time;
            
            cn0 = cell2mat(gnss_data(start_index:(i-1),3));
%             plot(time,cn0);
%             legend_strings{end + 1} = graph_title + num2str(satellite);
            
            if(satellite == 109)
                plot(time,cn0);

                hold on;
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

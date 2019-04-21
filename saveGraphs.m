function saveGraphs(fileFolder,file_name,fig)
% Saving figures
file_path = strcat(fileFolder,"\Figs\");
if ~exist(file_path, 'dir')
    mkdir(file_path)
end
% savefig(strcat(file_path, file_name));

% Saving PNGs
file_path = strcat(fileFolder,"\Pngs\");
if ~exist(file_path, 'dir')
    mkdir(file_path)
end
% saveas(fig, strcat(file_path,file_name, ".png"));

end

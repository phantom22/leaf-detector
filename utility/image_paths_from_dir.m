function [num_images,paths,names] = image_paths_from_dir(directory, extension)
    arguments
        directory; % Ensure directory is passed as a character array
        extension = 'jpg'; % Default extension
    end

    sz = length(directory);

    if sz == 1 && (ischar(directory) || isstring(directory))
        [num_images,paths,names] = retrieve_data(directory, extension);
        return;
    end

    num_images = zeros(sz,1,'double');
    paths = cell(sz,1);
    names = cell(sz,1);

    for i=1:sz
        [t_num_images,t_paths,t_names] = retrieve_data(directory{i}, extension);
        num_images(i) = t_num_images;
        paths{i} = t_paths;
        names{i} = t_names;
    end
end

function [num_images,paths,names] = retrieve_data(directory, extension)
    files = dir(fullfile(directory, strcat('*.', extension))); % Use fullfile for platform compatibility
    files = files(~[files.isdir]); % Remove directories from results
    num_images = length(files);
    names = {files.name}; % Extract file names into a cell array
    paths = fullfile(directory, names);
end
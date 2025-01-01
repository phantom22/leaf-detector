function [num_images,paths,names] = image_paths_from_dir(directory, extension, ordered_numbers_as_names)
    % [num_images,fullpaths,filenames] = image_paths_from_dir(directory, extension='jpg', ordered_numbers_as_names=true)
    %
    % ordered_numbers_as_names assumes that the directory contents are, for example:
    %    { '1.jpg', '2.jpg', ..., '30.jpg' }
    % this orders correctly the images.
    %
    % es. dove directory è una stringa
    %   [num_images,fullpaths,filenames] = image_paths_from_dir("images/A");
    %   % num_images è un numero.
    %   % fullpaths e filenames sono due cell array di stringhe.
    %
    % es. dove directory è un array di stringhe
    %   [num_images,fullpaths,filenames] = image_paths_from_dir(["images/A","images/B"]);
    %   % num_images è un array di due numeri.
    %   % fullpaths e filenames sono due cell array di array di stringhe.
    arguments
        directory; % Ensure directory is passed as a character array
        extension = 'jpg'; % Default extension
        ordered_numbers_as_names = true;
    end

    if (ischar(directory) || (isstring(directory) && isscalar(directory)))
        [num_images,paths,names] = retrieve_data(directory, extension, ordered_numbers_as_names);
        return;
    end

    sz = length(directory);

    num_images = zeros(sz,1,'double');
    paths = cell(sz,1);
    names = cell(sz,1);

    for i=1:sz
        [t_num_images,t_paths,t_names] = retrieve_data(directory{i}, extension, ordered_numbers_as_names);
        num_images(i) = t_num_images;
        paths{i} = t_paths;
        names{i} = t_names;
    end
end

    function [num_images,paths,names] = retrieve_data(directory, extension, ordered_numbers_as_names)
    if ~isfolder(directory)
        error("'%s' is not a valid directory!", directory);
    end

    files = dir(fullfile(directory, strcat('*.', extension))); % Use fullfile for platform compatibility
    files = files(~[files.isdir]); % Remove directories from results
    num_images = length(files);
    if num_images == 0
        error("the '%s' directory has no '.%s' files!", directory, extension);
    end

    if ordered_numbers_as_names
        names = 1:num_images;
        names = arrayfun(@(x) char(strcat(num2str(x), '.', extension)), names, 'UniformOutput', false);
    else
        names = {files.name}; % Extract file names into a cell array
    end
    paths = fullfile(directory, names);
end
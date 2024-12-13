function [num_images,paths,names] = image_paths_from_dir(directory, extension)
    arguments
        directory char; % Ensure directory is passed as a character array
        extension = 'jpg'; % Default extension
    end
    files = dir(fullfile(directory, strcat('*.', extension))); % Use fullfile for platform compatibility
    files = files(~[files.isdir]); % Remove directories from results
    num_images = length(files);
    names = {files.name}; % Extract file names into a cell array
    paths = fullfile(directory, names);
end
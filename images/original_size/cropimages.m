function cropimages()
    prev_pwd = pwd;
    
    script_full_path = mfilename('fullpath');
    script_dir = fileparts(script_full_path);
    target_dir = dir(fullfile(script_dir, '..\reduced_size')).folder;
    
    cd(script_dir);
    
    files = dir(fullfile('*.jpg'));
    
    input_res = [4000 3000];
    reduced_res = input_res / 10;
    
    for k = 1:length(files)
        fname = files(k).name;
        imwrite(imresize(imread(fname), reduced_res), fullfile(target_dir, fname));
    end
    
    cd(prev_pwd);
end
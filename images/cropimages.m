function cropimages()
    prev_pwd = pwd;
    dopo="\pianta3t";
    prima="\pianta3";
    script_full_path = mfilename('fullpath');
    script_dir = fileparts(script_full_path);
    mkdir(fullfile(script_dir, dopo));
    target_dir = dir(fullfile(script_dir, dopo)).folder;
    cd(fullfile(script_dir,prima));
    files = dir(fullfile('*.jpg'));
    
    
    input_res = [4000 3000];
    reduced_res = input_res / 10;
    
    for k = 1:length(files)
        fname = files(k).name;
        im=imread(fname);
        [m,n,~]=size(im);
        centern=ceil(n/2)+250;
        centerm=ceil(m/2)+70;
        dimensionem=1020;
        dimensionen=1360;
        dm=ceil(dimensionem/2);
        dn=ceil(dimensionen/2);
        pezzo=im(centerm-dm:centerm+dm,centern-dn:centern+dn,1:3);
        % figure;imshow(pezzo);
        imwrite(imresize(pezzo,[300,400]), fullfile(target_dir, strcat(int2str(k),'.jpg')));
    end
    
    cd(prev_pwd);
end
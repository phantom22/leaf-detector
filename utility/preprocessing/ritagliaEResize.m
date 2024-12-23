function cropimages(from, to, dcm, dcn, target_width, target_height, dimm, dimn)
    arguments
        from;
        to;
        dcm=60;
        dcn=-500;
        target_width = 400;
        target_height = 300;
        dimm=1200;
        dimn=1600;
    end
    %settaggi per [dcm,dcn] per le varie classi
    % A=[60,-500]
    % B=[-60,-500]
    % C=[60,-800]
    % D=[-80,-200]
    % E=[-100,-200]
    
    if ~exist(from, 'dir')
        error('non existent directory passed as input folder.');
    elseif strcmp(from,to)
        error('the otput folder cannot be equal to the input folder.');
    end
    
    images = dir(fullfile(from, '*.jpg'));
    images = images(~[images.isdir]);
    num_images = length(images);
    
        mkdir(to);
    % if ~exist(to, 'dir')
    %     mkdir(to);
    % else
    %     disp('the output folder already exists!');
    %     user_input = input('Override folder? (Y/N): ', 's');
    %     if ~ismember(user_input, {'Y', 'y'})
    %         disp('operation aborted.');
    %         return;
    %     end
    % end
    
    target_dir = dir(fullfile(to)).folder;

    for k=1:num_images
        fname = images(k).name;
        dimhm=ceil(dimm/2);
        dimhn=ceil(dimn/2);
        im=imread((fullfile(from,fname)));
        [m,n,~]=size(im);
        dm=ceil((m+dcm)/2);
        dn=ceil((n+dcn)/2);
        imwrite(imresize(im(dm-dimhm:dm+dimhm,dn-dimhn:dn+dimhm,1:3),[target_height,target_width]), fullfile(target_dir, strcat(int2str(k),'.jpg')));
        fprintf("%d/%d '%s' done.\n", k, num_images, fname);
    end
end

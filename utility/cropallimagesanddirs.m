function cropallimagesanddirs(from, to, fisso, target_width, target_height)
    arguments
        from;
        to;
        fisso=1;
        target_width = 400;
        target_height = 300;
    end

    if ~exist(from, 'dir')
        error('non existent directory passed as input folder.');
    elseif strcmp(from,to)
        error('the otput folder cannot be equal to the input folder.');
    end
              %[    1,    2,    3,   4,    5,    6,   7,   8,   9,  10, 11,   12
    dcmh=ceil( [   60, -300, -150,-300, -300, -500, -300, -150,-300,-180,-180,-180]/2);
    dcnh=ceil( [-1500,-1500,-2000,-500,-900, -500,-1600,-1250,-300,180,180,-700]/2);
    dimmh=ceil([ 1100, 1100, 1200,1000,  600, 1900, 1800,  700, 1000,1600,1600,650]/2);
    dimmfh=max(dimmh);
    
    dirs = dir(from);
    dirs = dirs([dirs.isdir]);
    num_dirs = length(dirs);
    
    for d=1:num_dirs
        dirName= strcat("pianta",int2str(d-2));
        images = dir(fullfile(from,dirName, '*.jpg'));
        images = images(~[images.isdir]);
        num_images = length(images);
        
        mkdir(fullfile(to,dirName));
        
        target_dir = fullfile(to,dirName);
    
        for k=1:num_images
            fname = images(k).name;
            im=imread((fullfile(from,dirName,fname)));
            [m,n,~]=size(im);
            if(fisso==0)
                dimmfh=dimmh(d-2);
            end
            dm=ceil((m+dcmh(d-2))/2);
            dn=ceil((n+dcnh(d-2))/2);

            dimnfh=dimmfh/size(im,1)*size(im,2);
            imwrite(imresize(im(dm-dimmfh:dm+dimmfh,dn-dimnfh:dn+dimnfh,1:3),[target_height,target_width]), fullfile(target_dir, strcat(int2str(k),'.jpg')));
        end
        fprintf("%d/%d '%s' done.\n", d, num_dirs,target_dir);
        
    end
end

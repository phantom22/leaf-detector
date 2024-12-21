function partiziona_sfondo_foglia()
    target_dir="pezzi1/";
    target_dirs="pezzis1/";
    dirs=["A/","B/","C/","D/","E/"];
    dcm=[-40,-20,-40,-20,-40];
    dcn=[40,-30,40,0,50];
    num_dirs = length(dirs);
    disp(num_dirs);
    target_dir = dir(fullfile(target_dir)).folder;
    for d=1:num_dirs
        images = dir(fullfile(dirs(d), '*.jpg'));
        images = images(~[images.isdir]);
        num_images = length(images);
        for k=1:num_images
            fname = images(k).name;
            dimhm=ceil(30/2);
            dimhn=ceil(30/2);
            im=imread((fullfile(dirs(d),fname)));
            [m,n,~]=size(im);
            dm=ceil((m+dcm(d))/2);
            dn=ceil((n+dcn(d))/2);
            imwrite(im(dm-dimhm:dm+dimhm,dn-dimhn:dn+dimhm,1:3), fullfile(target_dir, strcat(int2str(d),"_",int2str(k),'.jpg')));
            imwrite(im(1:60,1:60,1:3), fullfile(target_dirs, strcat(int2str(d),"_",int2str(k),'.jpg')));
            fprintf("%d/%d '%s' done.\n", k, num_images, fname);
        end
    end
end

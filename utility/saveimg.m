function saveimg(BW,path,ext)
    arguments
        BW;
        path {mustBeText};
        ext {mustBeText} = '.jpg';
    end

    imwrite(BW, strcat(path,ext), 'Quality', 100);
end
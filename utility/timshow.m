function h = timshow(im, title_txt)
    arguments
        im;
        title_txt {mustBeText} = "";
    end
    h = imshow(im);
    if title_txt ~= ""
        title(char(title_txt));
    end
end
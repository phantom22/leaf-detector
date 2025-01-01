function h = timshow(im, title_txt)
    arguments
        im;
        title_txt {mustBeTextScalar} = "";
    end
    h = imshow(im);
    if title_txt ~= ""
        title(title_txt);
    end
end
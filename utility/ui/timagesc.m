function h = timagesc(im, title_txt)
    arguments
        im;
        title_txt {mustBeTextScalar} = "";
    end
    h = imagesc(im);
    colormap(turbo);
    axis image;
    axis off;
    if title_txt ~= ""
        title(title_txt);
    end
end
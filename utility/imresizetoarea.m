function R = imresizetoarea(im, area)
    in_area = size(im,1) * size(im,2);
    if in_area == area
        R = im;
        return;
    end

    f = sqrt(in_area / area);
    R = imresize(im, size(im,1:2) / f);
end
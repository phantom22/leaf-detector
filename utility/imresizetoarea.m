function R = imresizetoarea(im, tarea, iarea)
    arguments
        im;
        tarea;
        iarea = NaN;
    end

    if isempty(tarea)
        R = im;
        return;
    end

    if size(tarea,2)  == 2
        tarea = tarea(1) * tarea(2);
    end

    in_area = size(im,1) * size(im,2);
    if in_area == tarea || in_area == iarea
        R = im;
        return;
    end

    f = sqrt(in_area / tarea);
    R = imresize(im, size(im,1:2) / f);
end
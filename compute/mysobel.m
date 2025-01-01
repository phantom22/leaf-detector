function [sob,dir] = mysobel(im, dir_angle_tolerance)
    a = [1 2 1];
    b = [1 0 -1];
    pim = padarray(im,[1 1],'symmetric');
    out_x = conv2(a,b,pim,'valid');
    out_y = conv2(b,a,pim,'valid');
    sob = sqrt(out_x.^2 + out_y.^2);
    dir = atan2(out_y, out_x); % remap sobel_dir to [0,2pi]
    dirm = sum(sum(dir)) / numel(dir) * dir_angle_tolerance;
    dir(dir < dirm) = 0;
end
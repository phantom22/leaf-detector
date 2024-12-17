function [sob,dir] = mysobel(im, dir_mean_tolerance)
    a = [1 2 1];
    b = [1 0 -1];
    pim = padarray(im,[1 1],'symmetric');
    out_x = conv2(a,b,pim,'valid');
    out_y = conv2(b,a,pim,'valid');
    sob = sqrt(out_x.^2 + out_y.^2);
    dir = atan2(out_y, out_x);
    dir(dir < (sum(sum(dir)) / numel(dir)) * dir_mean_tolerance) = 0;
end
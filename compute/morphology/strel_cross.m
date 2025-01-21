function n = strel_cross(r)
    w = 2*r + 1;
    n = false(w, w);
    n(r+1, :) = true;
    n(:, r+1) = true;
end
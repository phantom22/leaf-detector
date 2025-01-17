function sig = signature_interp(bw, res)
    % Calculate the centroid of the boundary
    tmp = regionprops(bw, double(bw), 'Area', 'WeightedCentroid', 'Orientation');
    [~,max_area_idx] = max([tmp.Area]);

    bd = bwboundaries(bw);
    b = bd{max_area_idx};

    c = [tmp(max_area_idx).WeightedCentroid(2), tmp(max_area_idx).WeightedCentroid(1)];

    tau = 2*pi;
    phase = tmp(max_area_idx).Orientation * (pi/180);

    % Compute distances and angles from the centroid
    diffs = b - c;
    ud = sqrt(sum(diffs.^2, 2));  % Distances
    ua = mod(atan2(diffs(:, 2), diffs(:, 1)) - phase + pi, tau);  % Angles in radians, adjusted by phase

    % Normalize angles to [0, 2*pi]
    na = mod(ua + pi, tau);

    % Sort angles and distances
    [sa, sort_inds] = sort(na);
    sd = ud(sort_inds);

    % Remove duplicated angles - else, interp1 will throw an error
    [sa, unique_inds] = unique(sa);
    sd = sd(unique_inds);

    % Interpolate distances for high-resolution signatures
    angles_interp = linspace(0, tau, res);  % Uniformly spaced angles

    sig = interp1(sa, sd, angles_interp, 'linear', 'extrap')';

    m = min(sig);
    M = max(sig);

    if m == M
        sig(:) = 0;
        return;
    end

    sig(:) = (sig(:) - m) / (M - m);
end

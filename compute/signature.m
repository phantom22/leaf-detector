function sig = signature(bw, res)
    bd = bwboundaries(bw);

    b = bd{1};

    tmp_c = regionprops(bw, double(bw),'WeightedCentroid').WeightedCentroid;
    c = [tmp_c(2) tmp_c(1)]; % re-arrange centroid
    diffs = b - c;
    ud = sqrt(sum(diffs.^2, 2)); % unsorted distances
    ua = atan2(diffs(:, 2), diffs(:, 1));  % unsorted angles

    tau = 2*pi;
    na = mod(ua + pi, tau); % map unsorted angles from [-pi, pi] to [0, 2*pi]
    
    [sa, sort_inds] = sort(na);

    sd = ud(sort_inds);

    stepsz = tau/res;

    sig = zeros(res, 1, 'double');
    maxind = length(b);
    
    sig(1) = sd(1);
    angle = stepsz;
    step = res-1;

    ind = 2;

    % TODO add sampling when res > maxind
    % TODO resolve cases where dist_a >= 0 && dist_b <=0

    while step > 0 && ind < maxind
        dist_a = angle - sa(ind);
        dist_b = sa(ind+1) - angle;

        if dist_a >= 0 && dist_b >= 0
            if dist_a <= dist_b
                sig(res-step+1) = sd(ind);
            else
                sig(res-step+1) = sd(ind+1);
            end

            angle = angle + stepsz;

            step = step - 1;
        end
        ind = ind + 1;
    end

    m = min(sig);
    M = max(sig);

    if m == M
        sig(:) = 0;
        return;
    end

    sig(:) = (sig(:) - m) / (M - m);
end
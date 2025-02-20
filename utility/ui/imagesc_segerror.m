function imagesc_segerror(segmented, gt)
    diff = gt - segmented;

    colors = uint8([ ...
        128 240 128; ... % light-green - false positives
        0 0 0; ...
        240 128 128 ... % light-coral - false negatives
    ]);

    if max(max(diff)) == 0
        colors = colors(1:2,:);
    end

    imagesc(diff);
    colormap(gca, colors);
    axis image;
    axis off;
end
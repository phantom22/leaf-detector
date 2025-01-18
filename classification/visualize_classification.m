function visualize_classification(C)
    cmap = [
        hex2rgb('#454545'); % very light purple
        hex2rgb('#ff4d4d'); % red
        hex2rgb('#ff794d'); % dark orange
        hex2rgb('#ffa64d'); % light orange
        hex2rgb('#ffff4d'); % yellow
        hex2rgb('#a6ff4d'); % light green
        hex2rgb('#4dff79'); % dark green
        hex2rgb('#4dffd2'); % cyan
        hex2rgb('#4dd2ff'); % light celeste
        hex2rgb('#4d79ff'); % dark celeste
        hex2rgb('#4d4dff'); % blue
        hex2rgb('#794dff'); % purple
        hex2rgb('#ff4d79'); % magenta
    ] .* 0.7;

    cmap(1,:) = cmap(1,:) .* 0.4;

    timagesc(C); colormap(cmap);

end
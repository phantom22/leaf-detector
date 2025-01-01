function sp = tsubplot(m, n, p, vertical_padding, horizontal_padding)
    % tsubplot(m, n, p, vertical_padding=0.2, horizontal_padding=0.15)
    %
    % equivalent to subplot(m, n, p) but results in a tight subplot grid.
    % vertical_padding and horizontal_padding are optional and control the tightness.
    arguments
        m {mustBeInteger,mustBePositive};
        n {mustBeInteger,mustBePositive};
        p {mustBeInteger,mustBePositive};
        vertical_padding = 0.2;    % 20%
        horizontal_padding = 0.15; % 15%
    end

    if p > m*n
        error("Index exceeds number of subplots.");
    end

    sp = subplot('Position', [ ...
        horizontal_padding/(2*n) + mod(p-1,n)/n, ...
        (2*(m-1)+vertical_padding)/(2*m) - floor((p-1)/n)/m, ...
        (1 - horizontal_padding) / n, ...
        (1 - vertical_padding) / m]);

    % width = (1 - horizontal_padding) / n;
    % height = (1 - vertical_padding) / m;
    % 
    % for y=(2*(m-1)+vertical_padding)/(2*m):-1/m:0
    %     for x=horizontal_padding/(2*n):1/n:1
    %         if p > num_images
    %             return;
    %         end
    % 
    %         ax_positions(1,p) = x;
    %         ax_positions(2,p) = y;
    %         ax_positions(3,p) = width;
    %         ax_positions(4,p) = height;
    % 
    %         p = p + 1;
    %     end
    % end
end
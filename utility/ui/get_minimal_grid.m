function ax_positions = get_minimal_grid(num_images, vertical_padding, horizontal_padding)
    % get_minimal_grid(num_images, vertical_padding=0.2, horizontal_padding=0.15)
    %
    % vertical_padding and horizontal_padding are optional and control the tightness.
    %
    % es.
    %   ax_positions = get_minimal_grid(num_images);
    %
    %   subplot('Position', ax_positions(:,1));
    %   imshow(images(:,:,1));
    arguments
        num_images;
        vertical_padding = 0.2;    % 10%
        horizontal_padding = 0.15; % 15%
    end

    ax_positions = zeros(4,num_images); 

    [m,n] = calcola_ingombro_minimo_subplot(num_images);
    p = 1;

    width = (1 - horizontal_padding) / n;
    height = (1 - vertical_padding) / m;

    for y=(2*(m-1)+vertical_padding)/(2*m):-1/m:0
        for x=horizontal_padding/(2*n):1/n:1
            if p > num_images
                return;
            end

            ax_positions(1,p) = x;
            ax_positions(2,p) = y;
            ax_positions(3,p) = width;
            ax_positions(4,p) = height;

            p = p + 1;
        end
    end
end
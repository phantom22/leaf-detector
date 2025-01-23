function huMoments = hu_moments(image)
    % Compute Hu Moments for a binary or grayscale image
    % Input:
    %   image - Grayscale or binary image
    % Output:
    %   huMoments - A 7-element vector of Hu Moments

    % Ensure the image is double precision for calculations
    image = double(image);

    % Compute spatial moments
    m00 = sum(image(:)); % Zero-order moment
    [X, Y] = meshgrid(1:size(image, 2), 1:size(image, 1));
    m10 = sum(sum(X .* image)); % First-order moment (x)
    m01 = sum(sum(Y .* image)); % First-order moment (y)

    % Compute centroid (x̄, ȳ)
    xBar = m10 / m00;
    yBar = m01 / m00;

    % Compute central moments (up to 3rd order)
    xPrime = X - xBar;
    yPrime = Y - yBar;
    mu00 = m00; % Redundant with m00
    mu20 = sum(sum((xPrime.^2) .* image));
    mu02 = sum(sum((yPrime.^2) .* image));
    mu11 = sum(sum((xPrime .* yPrime) .* image));
    mu30 = sum(sum((xPrime.^3) .* image));
    mu03 = sum(sum((yPrime.^3) .* image));
    mu21 = sum(sum((xPrime.^2 .* yPrime) .* image));
    mu12 = sum(sum((xPrime .* yPrime.^2) .* image));

    % Scale-invariant central moments (ηpq)
    eta20 = mu20 / mu00^(2);
    eta02 = mu02 / mu00^(2);
    eta11 = mu11 / mu00^(2);
    eta30 = mu30 / mu00^(2.5);
    eta03 = mu03 / mu00^(2.5);
    eta21 = mu21 / mu00^(2.5);
    eta12 = mu12 / mu00^(2.5);

    % Compute Hu Moments (7 features)
    huMoments = zeros(1, 7);
    huMoments(1) = eta20 + eta02;
    huMoments(2) = (eta20 - eta02)^2 + 4*eta11^2;
    huMoments(3) = (eta30 - 3*eta12)^2 + (3*eta21 - eta03)^2;
    huMoments(4) = (eta30 + eta12)^2 + (eta21 + eta03)^2;
    huMoments(5) = (eta30 - 3*eta12) * (eta30 + eta12) * ...
                   ((eta30 + eta12)^2 - 3*(eta21 + eta03)^2) + ...
                   (3*eta21 - eta03) * (eta21 + eta03) * ...
                   (3*(eta30 + eta12)^2 - (eta21 + eta03)^2);
    huMoments(6) = (eta20 - eta02) * ((eta30 + eta12)^2 - (eta21 + eta03)^2) + ...
                   4*eta11 * (eta30 + eta12) * (eta21 + eta03);
    huMoments(7) = (3*eta21 - eta03) * (eta30 + eta12) * ...
                   ((eta30 + eta12)^2 - 3*(eta21 + eta03)^2) - ...
                   (eta30 - 3*eta12) * (eta21 + eta03) * ...
                   (3*(eta30 + eta12)^2 - (eta21 + eta03)^2);
end

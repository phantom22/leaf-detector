function curv = compute_curvature(coords)
    % Calcola la differenza tra i punti adiacenti
    dx = diff(coords(:,1));
    dy = diff(coords(:,2));
    
    % Calcola le differenze seconde
    ddx = diff(dx);
    ddy = diff(dy);
    
    % Calcola la curvatura
    curv = (dx(2:end) .* ddy - dy(2:end) .* ddx) ./ (dx(2:end).^2 + dy(2:end).^2).^(3/2);
end
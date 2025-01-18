function out=calcolaMomenti(mask)

    % Calcola proprietà con regionprops
    props = regionprops(mask, 'Centroid', 'Orientation');
    
    [m, n] = size(mask);
    [X, Y] = meshgrid(1:n, 1:m);
    
    % Traslazione: porta l'origine al baricentro
    X_c = X - props.Centroid(1); % Coordinate traslate (X centrato)
    Y_c = Y -  props.Centroid(2); % Coordinate traslate (Y centrato)
    
    % Conversione dell'angolo da gradi a radianti
    theta = deg2rad(props.Orientation)*-1;
    
    % Rotazione: elimina la rotazione
    X_r = X_c * cos(theta) - Y_c * sin(theta); % Coordinate ruotate (X)
    Y_r = X_c * sin(theta) + Y_c * cos(theta); % Coordinate ruotate (Y)
    
    % Calcolo dei momenti centrati e non ruotati
    M20 = sum((X_r(:).^2) .* mask(:)); % Momento M20
    M02 = sum((Y_r(:).^2) .* mask(:)); % Momento M02
    
    out=zeros(2,1);
    out(1)=M20;
    out(2)=M02;

end
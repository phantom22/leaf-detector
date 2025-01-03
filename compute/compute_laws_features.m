function features = extractLawsFeatures(image)
    % Funzione che estrae le 9 caratteristiche basate sulle maschere di Laws
    % INPUT:
    %   - image: immagine in scala di grigi
    % OUTPUT:
    %   - features: un array 3D, dove ogni layer contiene la risposta a una maschera
    
    % Controlla se l'immagine è RGB, converte in scala di grigi se necessario
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    % Converti in double per operazioni precise
    image = double(image);
    
    % Definizione dei kernel di Law
    L5 = [1 4 6 4 1]; 
    E5 = [-1 -2 0 2 1];
    S5 = [-1 0 2 0 -1];
    R5 = [1 -4 6 -4 1];

    kernels = {L5'*E5, L5'*S5, L5'*R5, 
               E5'*E5, E5'*S5, E5'*R5, 
               S5'*S5, S5'*R5, R5'*R5};

    
    % Inizializzazione del volume delle feature
    [rows, cols] = size(image);
    features = zeros(rows, cols, 9); % 9 layer per le 9 maschere
    for k = 1:numel(kernels)
        features(:,:,k) =abs(conv2(image, kernels{k}, 'same'));
    end
end

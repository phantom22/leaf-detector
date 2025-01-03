
img = im2double( imread("images\segmented\A\10.png"));
% Carica l'immagine

% Converti in scala di grigi
grayImg = rgb2gray(img);

% Migliora il contrasto con equalizzazione dell'istogramma
enhancedImg = histeq(grayImg);

% Rileva i bordi usando il metodo di Canny con soglie personalizzate
lowThreshold = 0.0;  % Soglia bassa
highThreshold = 0.2; % Soglia alta
edges = edge(enhancedImg, 'Canny', [lowThreshold, highThreshold]);

% Visualizza il risultato
figure;
imshow(edges);
title('Venature della foglia (Bordi rilevati)');

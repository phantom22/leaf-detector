function [immagineSistemata,maskSistemata]= sistemaImmagine(im,mask,angoloP,punto_rotazione)
    s=round(size(im,1:2)/2);
    angolo=angoloP;
    % Crea una matrice di trasformazione affine
    t1 = affine2d([1 0 0; 0 1 0; -punto_rotazione(1) -punto_rotazione(2) 1]); % Traslazione iniziale
    t2 = affine2d([cosd(angolo) sind(angolo) 0; -sind(angolo) cosd(angolo) 0; 0 0 1]); % Rotazione

    try   
        t4 = affine2d([1 0 0; 0 1 0; s(2) s(1) 1]); % Traslazione inversa
        % Componi le trasformazioni
        t_completa = affine2d(t1.T * t2.T * t4.T);
        % Applica la trasformazione all'immagine
        img_rotata = imwarp(im, t_completa, 'OutputView', imref2d(size(im)));
        mask_rotata = imwarp(mask, t_completa, 'OutputView', imref2d(size(mask)));
        box=round(regionprops(mask_rotata,"BoundingBox").BoundingBox);
        immagineSistemata=img_rotata(box(2):box(2)+box(4),box(1):box(1)+box(3));
        maskSistemata=mask_rotata(box(2):box(2)+box(4),box(1):box(1)+box(3));
    catch e
        t4 = affine2d([1 0 0; 0 1 0; punto_rotazione(1) punto_rotazione(2) 1]); % Traslazione inversa
        % Componi le trasformazioni
        t_completa = affine2d(t1.T * t2.T * t4.T);
        % Applica la trasformazione all'immagine
        img_rotata = imwarp(im, t_completa, 'OutputView', imref2d(size(im)));
        mask_rotata = imwarp(mask, t_completa, 'OutputView', imref2d(size(mask)));
        box=ceil(regionprops(mask_rotata,"BoundingBox").BoundingBox);
        windth=min(max(box(2)+box(4),0),size(im,1)-1);
        height=min(max(box(1)+box(3),0),size(im,2)-1);
        immagineSistemata=img_rotata(box(2):windth,box(1):height);
        maskSistemata=mask_rotata(box(2):windth,box(1):height);
    end
end
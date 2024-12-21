function [righe,colonne]= calcola_imgombro_minimo_subplot(numImage)
    lato=ceil(sqrt(numImage));
    righe=lato;
    colonne=lato;
    if((righe-1)*colonne>=numImage)
        righe=righe-1;
    end
end
function [righe,colonne]= calcolaImgombroMinimoSubplot(numImage)
    lato=ceil(sqrt(numImage));
    righe=lato;
    colonne=lato;
    if((righe-1)*colonne>=numImage)
        righe=righe-1;
    end
end
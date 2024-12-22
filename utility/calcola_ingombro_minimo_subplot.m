function [righe,colonne] = calcola_ingombro_minimo_subplot(num_images)
    lato = ceil(sqrt(num_images));
    righe = lato;
    colonne = lato;
    if (righe-1)*colonne >= num_images
        righe=righe-1;
    end
end
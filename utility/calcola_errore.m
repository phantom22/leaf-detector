function [falsi_positivi,falsi_negativi,inverti]=calcola_errore(mashera, ground_truth)
    differenze=ground_truth-mashera;
    differenzeInv=ground_truth-(1-mashera);
    falsi_positivi=sum(sum(differenze==-1));
    falsi_negativi=sum(sum(differenze==1));
    falsi_positiviinv=sum(sum(differenzeInv==-1));
    falsi_negativiinv=sum(sum(differenzeInv==1));
    if falsi_negativiinv+falsi_positiviinv<falsi_negativi+falsi_positivi
        inverti=1;
        falsi_positivi=falsi_positiviinv;
        falsi_negativi=falsi_negativiinv;
    else
        inverti=0;
    end
end
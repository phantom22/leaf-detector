function [falsi_positivi,falsi_negativi]=calcola_errore(mashera, ground_truth)
    differenze=ground_truth-mashera;
    falsi_positivi=sum(sum(differenze==-1));
    falsi_negativi=sum(sum(differenze==1));
end
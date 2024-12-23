function [fp,fn,invertiti] = calcola_errore(mask, gt_mask,gestisci_inverso)
    diff = gt_mask-mask;

    fp = sum(sum(diff == -1));
    fn = sum(sum(diff == 1));
    if gestisci_inverso
        diff_inv = gt_mask-(1-mask);
        fp_inv = sum(sum(diff_inv == -1));
        fn_inv = sum(sum(diff_inv == 1));
    
        if fn_inv+fp_inv < fn+fp
            invertiti=1;
            fp=fp_inv;
            fn=fn_inv;
        else
            invertiti=0;
        end
    end
end
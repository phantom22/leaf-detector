function [tp,tn,fp,fn] = compute_seg_error(mask, gt_mask)
    diff = gt_mask-mask;

    tp = nnz(gt_mask & mask);
    tn = nnz(~gt_mask & ~mask);
    fp = nnz(diff == -1);
    fn = nnz(diff == 1);

    % if gestisci_inverso
    %     diff_inv = gt_mask-(1-mask);
    %     fp_inv = sum(sum(diff_inv == -1));
    %     fn_inv = sum(sum(diff_inv == 1));
    % 
    %     if fn_inv+fp_inv < fn+fp
    %         invertiti=1;
    %         fp=fp_inv;
    %         fn=fn_inv;
    %     else
    %         invertiti=0;
    %     end
    % end
end
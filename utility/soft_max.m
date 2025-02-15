function v = soft_max(x) 
    v = exp(x) ./ sum(exp(x), 2);
end
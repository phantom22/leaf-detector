% zeros(300, 400, num_images, 'single');

[A,ni_a,nsp_a] = slic_batch(450,10,'images/A',1); % num_features x num_superpixels x num_images
[B,ni_b,nsp_b] = slic_batch(450,10,'images/B',2); % 5 x nsp_<class> x ni<class>
[C,ni_c,nsp_c] = slic_batch(450,10,'images/C',3);
[D,ni_d,nsp_d] = slic_batch(450,10,'images/D',4);
[E,ni_e,nsp_e] = slic_batch(450,10,'images/E',5);

max_ni = max([ni_a, ni_b, ni_c, ni_d, ni_e]);
max_nsp = max([nsp_a, nsp_b, nsp_c, nsp_d, nsp_e]);

data_all = ; % total_num_images x max_nsp*num_features + 1
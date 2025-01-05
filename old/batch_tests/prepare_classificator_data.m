[A,ni_a,nsp_a] = slic_batch(450,10,'images/A'); % num_features x num_superpixels x num_images
[B,ni_b,nsp_b] = slic_batch(450,10,'images/B'); % 4 x nsp_<class> x ni<class>
[C,ni_c,nsp_c] = slic_batch(450,10,'images/C');
[D,ni_d,nsp_d] = slic_batch(450,10,'images/D');
[E,ni_e,nsp_e] = slic_batch(450,10,'images/E');

num_features = size(C,1);
max_ni = max([ni_a, ni_b, ni_c, ni_d, ni_e]);
max_nsp = max([nsp_a, nsp_b, nsp_c, nsp_d, nsp_e]);
tot_ni = ni_a + ni_b + ni_c + ni_d + ni_e;

data_all = zeros(max_nsp * num_features + 1, tot_ni); %  max_nsp*num_features + 1 x total_num_images

im_index = 1;
for a=1:ni_a
    label = 1;

    data_all(1:nsp_a*4,im_index) = reshape(A(:,:,a),[],1);
    data_all(end,im_index) = label;
    im_index = im_index + 1;
end

for b=1:ni_b
    label = 2;
    data_all(1:nsp_b*4,im_index) = reshape(B(:,:,b),[],1);
    data_all(end,im_index) = label;
    im_index = im_index + 1;
end

for c=1:ni_c
    label = 3;
    data_all(1:nsp_c*4,im_index) = reshape(C(:,:,c),[],1);
    data_all(end,im_index) = label;
    im_index = im_index + 1;
end

for d=1:ni_d
    label = 4;
    data_all(1:nsp_d*4,im_index) = reshape(D(:,:,d),[],1);
    data_all(end,im_index) = label;
    im_index = im_index + 1;
end

for e=1:ni_e
    label = 5;
    data_all(1:nsp_e*4,im_index) = reshape(E(:,:,e),[],1);
    data_all(end,im_index) = label;
    im_index = im_index + 1;
end

ready_data = data_all';
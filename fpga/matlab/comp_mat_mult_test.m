a_re0 = (rand(4,4) - 0.5);
a_im0 = (rand(4,4) - 0.5);
b_re0 = (rand(4,4) - 0.5);
b_im0 = (rand(4,4) - 0.5);

a_re1 = (rand(4,4) - 0.5);
a_im1 = (rand(4,4) - 0.5);
b_re1 = (rand(4,4) - 0.5);
b_im1 = (rand(4,4) - 0.5);

[result_re0, result_im0] = comp_mat_mult(a_re0, a_im0, b_re0, b_im0);
[result_re1, result_im1] = comp_mat_mult(a_re1, a_im1, b_re1, b_im1);
function [result_re, result_im] = comp_mat_mult(a_re, a_im, b_re, b_im)
result = (a_re + 1j * a_im) * (b_re + 1j * b_im);
result_re = real(result);
result_im = imag(result);
end
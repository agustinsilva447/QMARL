#include "QGT.h"

void QGT(int rotAx1, int rotAy2, int rotAx3, int rotBx1,
		 int rotBy2, int rotBx3, float *p00, float *p01, float *p10,
         float *p11)
{
#pragma HLS INTERFACE mode=s_axilite port=p11
#pragma HLS INTERFACE mode=s_axilite port=p10
#pragma HLS INTERFACE mode=s_axilite port=p01
#pragma HLS INTERFACE mode=s_axilite port=p00
#pragma HLS INTERFACE mode=s_axilite port=rotBx3
#pragma HLS INTERFACE mode=s_axilite port=rotBy2
#pragma HLS INTERFACE mode=s_axilite port=rotBx1
#pragma HLS INTERFACE mode=s_axilite port=rotAx3
#pragma HLS INTERFACE mode=s_axilite port=rotAy2
#pragma HLS INTERFACE mode=s_axilite port=rotAx1
#pragma HLS INTERFACE mode=s_axilite port=return
  static const creal_T a[16] = {{
                                    0.707107, /* re */
                                    0.0       /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    -0.0,     /* re */
                                    -0.707107 /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.707107, /* re */
                                    0.0       /* im */
                                },
                                {
                                    -0.0,     /* re */
                                    -0.707107 /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    -0.0,     /* re */
                                    -0.707107 /* im */
                                },
                                {
                                    0.707107, /* re */
                                    0.0       /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    -0.0,     /* re */
                                    -0.707107 /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.707107, /* re */
                                    0.0       /* im */
                                }};
  static const creal_T b[4] = {{
                                   0.707107, /* re */
                                   0.0       /* im */
                               },
                               {
                                   0.0, /* re */
                                   0.0  /* im */
                               },
                               {
                                   0.0, /* re */
                                   0.0  /* im */
                               },
                               {
                                   0.0,     /* re */
                                   0.707107 /* im */
                               }};
  static const float dv[8] = {0.0, 0.382683, 0.707107, 0.92388,
                               1.0, 0.92388,  0.707107, 0.382683};
  static const float dv1[8] = {1.0, 0.92388,   0.707107,  0.382683,
                                0.0, -0.382683, -0.707107, -0.92388};
  creal_T b_a[16];
  creal_T c_a[16];
  creal_T dcv[16];
  creal_T state[4];

  float G_Rx1_tmp_im;
  float G_Rx1_tmp_re_tmp;
  float G_Rx3_tmp_im;
  float G_Rx3_tmp_re_tmp;
  float b_G_Rx1_tmp_im;
  float b_G_Rx1_tmp_re_tmp;
  float b_G_Rx3_tmp_im;
  float b_G_Rx3_tmp_re_tmp;
  float b_im_tmp;
  float c_im_tmp;
  float d;
  float d1;
  float d10;
  float d11;
  float d12;
  float d2;
  float d3;
  float d4;
  float d5;
  float d6;
  float d7;
  float d8;
  float d9;
  float d_im_tmp;
  float im_tmp;
  int G_Rx1_tmp_re;
  int G_Rx3_tmp_re;
  int a_re_tmp;
  int b_G_Rx1_tmp_re;
  int b_G_Rx3_tmp_re;
  int i;
  im_tmp = dv[rotAx1];
  G_Rx1_tmp_re_tmp = dv1[rotBx1];
  G_Rx1_tmp_re = 0;
  G_Rx1_tmp_im = G_Rx1_tmp_re_tmp * -im_tmp;
  b_im_tmp = -dv[rotBx1];
  b_G_Rx1_tmp_re_tmp = dv1[rotAx1];
  b_G_Rx1_tmp_re = 0;
  b_G_Rx1_tmp_im = b_G_Rx1_tmp_re_tmp * b_im_tmp;
  c_im_tmp = dv[rotAx3];
  G_Rx3_tmp_re_tmp = dv1[rotBx3];
  G_Rx3_tmp_re = 0;
  G_Rx3_tmp_im = G_Rx3_tmp_re_tmp * -c_im_tmp;
  d_im_tmp = -dv[rotBx3];
  b_G_Rx3_tmp_re_tmp = dv1[rotAx3];
  b_G_Rx3_tmp_re = 0;
  b_G_Rx3_tmp_im = b_G_Rx3_tmp_re_tmp * d_im_tmp;
  d = G_Rx3_tmp_re_tmp * b_G_Rx3_tmp_re_tmp;
  dcv[0].re = d;
  dcv[0].im = 0.0;
  dcv[4].re = G_Rx3_tmp_re;
  dcv[4].im = G_Rx3_tmp_im;
  dcv[8].re = b_G_Rx3_tmp_re;
  dcv[8].im = b_G_Rx3_tmp_im;
  d1 = d_im_tmp * c_im_tmp;
  dcv[12].re = d1;
  dcv[12].im = 0.0;
  dcv[1].re = G_Rx3_tmp_re;
  dcv[1].im = G_Rx3_tmp_im;
  dcv[5].re = d;
  dcv[5].im = 0.0;
  dcv[9].re = d1;
  dcv[9].im = 0.0;
  dcv[13].re = b_G_Rx3_tmp_re;
  dcv[13].im = b_G_Rx3_tmp_im;
  dcv[2].re = b_G_Rx3_tmp_re;
  dcv[2].im = b_G_Rx3_tmp_im;
  dcv[6].re = d1;
  dcv[6].im = 0.0;
  dcv[10].re = d;
  dcv[10].im = 0.0;
  dcv[14].re = G_Rx3_tmp_re;
  dcv[14].im = G_Rx3_tmp_im;
  dcv[3].re = d1;
  dcv[3].im = 0.0;
  dcv[7].re = b_G_Rx3_tmp_re;
  dcv[7].im = b_G_Rx3_tmp_im;
  dcv[11].re = G_Rx3_tmp_re;
  dcv[11].im = G_Rx3_tmp_im;
  dcv[15].re = d;
  dcv[15].im = 0.0;
  for (G_Rx3_tmp_re = 0; G_Rx3_tmp_re < 4; G_Rx3_tmp_re++) {
    d = a[G_Rx3_tmp_re].re;
    d1 = a[G_Rx3_tmp_re].im;
    d2 = a[G_Rx3_tmp_re + 4].re;
    d3 = a[G_Rx3_tmp_re + 4].im;
    d4 = a[G_Rx3_tmp_re + 8].re;
    d5 = a[G_Rx3_tmp_re + 8].im;
    d6 = a[G_Rx3_tmp_re + 12].re;
    d7 = a[G_Rx3_tmp_re + 12].im;
    for (b_G_Rx3_tmp_re = 0; b_G_Rx3_tmp_re < 4; b_G_Rx3_tmp_re++) {
      a_re_tmp = b_G_Rx3_tmp_re << 2;
      i = G_Rx3_tmp_re + a_re_tmp;
      d8 = dcv[a_re_tmp].re;
      d9 = dcv[a_re_tmp].im;
      d10 = dcv[a_re_tmp + 1].re;
      d11 = dcv[a_re_tmp + 1].im;
      d_im_tmp = dcv[a_re_tmp + 2].re;
      G_Rx3_tmp_im = dcv[a_re_tmp + 2].im;
      b_G_Rx3_tmp_im = dcv[a_re_tmp + 3].re;
      d12 = dcv[a_re_tmp + 3].im;
      b_a[i].re = (((d * d8 - d1 * d9) + (d2 * d10 - d3 * d11)) +
                   (d4 * d_im_tmp - d5 * G_Rx3_tmp_im)) +
                  (d6 * b_G_Rx3_tmp_im - d7 * d12);
      b_a[i].im = (((d * d9 + d1 * d8) + (d2 * d11 + d3 * d10)) +
                   (d4 * G_Rx3_tmp_im + d5 * d_im_tmp)) +
                  (d6 * d12 + d7 * b_G_Rx3_tmp_im);
    }
  }
  d = dv1[rotBy2];
  d1 = dv1[rotAy2];
  d2 = d * d1;
  dcv[0].re = d2;
  dcv[0].im = 0.0;
  d3 = dv[rotAy2];
  d4 = -d3 * d;
  dcv[4].re = d4;
  dcv[4].im = 0.0;
  d5 = dv[rotBy2];
  d6 = -d5 * d1;
  dcv[8].re = d6;
  dcv[8].im = 0.0;
  d7 = d5 * d3;
  dcv[12].re = d7;
  dcv[12].im = 0.0;
  d *= d3;
  dcv[1].re = d;
  dcv[1].im = 0.0;
  dcv[5].re = d2;
  dcv[5].im = 0.0;
  d3 *= -dv[rotBy2];
  dcv[9].re = d3;
  dcv[9].im = 0.0;
  dcv[13].re = d6;
  dcv[13].im = 0.0;
  d1 *= d5;
  dcv[2].re = d1;
  dcv[2].im = 0.0;
  dcv[6].re = d3;
  dcv[6].im = 0.0;
  dcv[10].re = d2;
  dcv[10].im = 0.0;
  dcv[14].re = d4;
  dcv[14].im = 0.0;
  dcv[3].re = d7;
  dcv[3].im = 0.0;
  dcv[7].re = d1;
  dcv[7].im = 0.0;
  dcv[11].re = d;
  dcv[11].im = 0.0;
  dcv[15].re = d2;
  dcv[15].im = 0.0;
  for (G_Rx3_tmp_re = 0; G_Rx3_tmp_re < 4; G_Rx3_tmp_re++) {
    d = b_a[G_Rx3_tmp_re].re;
    d1 = b_a[G_Rx3_tmp_re].im;
    d2 = b_a[G_Rx3_tmp_re + 4].re;
    d3 = b_a[G_Rx3_tmp_re + 4].im;
    d4 = b_a[G_Rx3_tmp_re + 8].re;
    d5 = b_a[G_Rx3_tmp_re + 8].im;
    d6 = b_a[G_Rx3_tmp_re + 12].re;
    d7 = b_a[G_Rx3_tmp_re + 12].im;
    for (b_G_Rx3_tmp_re = 0; b_G_Rx3_tmp_re < 4; b_G_Rx3_tmp_re++) {
      a_re_tmp = b_G_Rx3_tmp_re << 2;
      i = G_Rx3_tmp_re + a_re_tmp;
      d8 = dcv[a_re_tmp].re;
      d9 = dcv[a_re_tmp + 1].re;
      d10 = dcv[a_re_tmp + 2].re;
      d11 = dcv[a_re_tmp + 3].re;
      c_a[i].re = (((d * d8 - d1 * 0.0) + (d2 * d9 - d3 * 0.0)) +
                   (d4 * d10 - d5 * 0.0)) +
                  (d6 * d11 - d7 * 0.0);
      c_a[i].im = (((d * 0.0 + d1 * d8) + (d2 * 0.0 + d3 * d9)) +
                   (d4 * 0.0 + d5 * d10)) +
                  (d6 * 0.0 + d7 * d11);
    }
  }
  d = G_Rx1_tmp_re_tmp * b_G_Rx1_tmp_re_tmp;
  dcv[0].re = d;
  dcv[0].im = 0.0;
  dcv[4].re = G_Rx1_tmp_re;
  dcv[4].im = G_Rx1_tmp_im;
  dcv[8].re = b_G_Rx1_tmp_re;
  dcv[8].im = b_G_Rx1_tmp_im;
  d1 = b_im_tmp * im_tmp;
  dcv[12].re = d1;
  dcv[12].im = 0.0;
  dcv[1].re = G_Rx1_tmp_re;
  dcv[1].im = G_Rx1_tmp_im;
  dcv[5].re = d;
  dcv[5].im = 0.0;
  dcv[9].re = d1;
  dcv[9].im = 0.0;
  dcv[13].re = b_G_Rx1_tmp_re;
  dcv[13].im = b_G_Rx1_tmp_im;
  dcv[2].re = b_G_Rx1_tmp_re;
  dcv[2].im = b_G_Rx1_tmp_im;
  dcv[6].re = d1;
  dcv[6].im = 0.0;
  dcv[10].re = d;
  dcv[10].im = 0.0;
  dcv[14].re = G_Rx1_tmp_re;
  dcv[14].im = G_Rx1_tmp_im;
  dcv[3].re = d1;
  dcv[3].im = 0.0;
  dcv[7].re = b_G_Rx1_tmp_re;
  dcv[7].im = b_G_Rx1_tmp_im;
  dcv[11].re = G_Rx1_tmp_re;
  dcv[11].im = G_Rx1_tmp_im;
  dcv[15].re = d;
  dcv[15].im = 0.0;
  for (G_Rx3_tmp_re = 0; G_Rx3_tmp_re < 4; G_Rx3_tmp_re++) {
    d = c_a[G_Rx3_tmp_re].re;
    d1 = c_a[G_Rx3_tmp_re].im;
    d2 = c_a[G_Rx3_tmp_re + 4].re;
    d3 = c_a[G_Rx3_tmp_re + 4].im;
    d4 = c_a[G_Rx3_tmp_re + 8].re;
    d5 = c_a[G_Rx3_tmp_re + 8].im;
    d6 = c_a[G_Rx3_tmp_re + 12].re;
    d7 = c_a[G_Rx3_tmp_re + 12].im;
    d8 = 0.0;
    d9 = 0.0;
    for (b_G_Rx3_tmp_re = 0; b_G_Rx3_tmp_re < 4; b_G_Rx3_tmp_re++) {
      a_re_tmp = b_G_Rx3_tmp_re << 2;
      d10 = dcv[a_re_tmp].re;
      d11 = dcv[a_re_tmp].im;
      d_im_tmp = dcv[a_re_tmp + 1].re;
      G_Rx3_tmp_im = dcv[a_re_tmp + 1].im;
      b_G_Rx3_tmp_im = dcv[a_re_tmp + 2].re;
      d12 = dcv[a_re_tmp + 2].im;
      G_Rx3_tmp_re_tmp = dcv[a_re_tmp + 3].re;
      b_G_Rx3_tmp_re_tmp = dcv[a_re_tmp + 3].im;
      c_im_tmp = (((d * d10 - d1 * d11) + (d2 * d_im_tmp - d3 * G_Rx3_tmp_im)) +
                  (d4 * b_G_Rx3_tmp_im - d5 * d12)) +
                 (d6 * G_Rx3_tmp_re_tmp - d7 * b_G_Rx3_tmp_re_tmp);
      G_Rx3_tmp_re_tmp =
          (((d * d11 + d1 * d10) + (d2 * G_Rx3_tmp_im + d3 * d_im_tmp)) +
           (d4 * d12 + d5 * b_G_Rx3_tmp_im)) +
          (d6 * b_G_Rx3_tmp_re_tmp + d7 * G_Rx3_tmp_re_tmp);
      d10 = b[b_G_Rx3_tmp_re].re;
      d11 = b[b_G_Rx3_tmp_re].im;
      d8 += c_im_tmp * d10 - G_Rx3_tmp_re_tmp * d11;
      d9 += c_im_tmp * d11 + G_Rx3_tmp_re_tmp * d10;
    }
    state[G_Rx3_tmp_re].im = d9;
    state[G_Rx3_tmp_re].re = d8;
  }
  *p00 = state[0].re * state[0].re + state[0].im * state[0].im;
  *p01 = state[1].re * state[1].re + state[1].im * state[1].im;
  *p10 = state[2].re * state[2].re + state[2].im * state[2].im;
  *p11 = state[3].re * state[3].re + state[3].im * state[3].im;
}

/* End of code generation (QGT.c) */

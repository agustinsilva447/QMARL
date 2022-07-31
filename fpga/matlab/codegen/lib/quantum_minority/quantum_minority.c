/*
 * quantum_minority.c
 *
 * Code generation for function 'quantum_minority'
 *
 */

/* Include files */
#include "quantum_minority.h"
#include "quantum_minority_data.h"
#include "quantum_minority_initialize.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Declarations */
static float rt_hypotd_snf(float u0, float u1);

/* Function Definitions */
static float rt_hypotd_snf(float u0, float u1)
{
  float a;
  float y;
  a = fabs(u0);
  y = fabs(u1);
  if (a < y) {
    a /= y;
    y *= sqrt(a * a + 1.0);
  } else if (a > y) {
    y /= a;
    y = a * sqrt(y * y + 1.0);
  } else if (!rtIsNaN(y)) {
    y = a * 1.4142135623730951;
  }
  return y;
}

void quantum_minority(float rx0, float ry0, float rz0, float rx1,
		float ry1, float rz1, float prob[4])
{
#pragma HLS TOP name=quantum_minority
#pragma HLS INTERFACE mode=s_axilite port=rx0
#pragma HLS INTERFACE mode=s_axilite port=ry0
#pragma HLS INTERFACE mode=s_axilite port=rz0
#pragma HLS INTERFACE mode=s_axilite port=rx1
#pragma HLS INTERFACE mode=s_axilite port=ry1
#pragma HLS INTERFACE mode=s_axilite port=rz1
#pragma HLS INTERFACE mode=s_axilite port=prob
#pragma HLS INTERFACE mode=s_axilite port=return
  static const creal_T a[16] = {{
                                    0.70710678118654746, /* re */
                                    0.0                  /* im */
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
                                    0.0,                /* re */
                                    0.70710678118654746 /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.70710678118654746, /* re */
                                    0.0                  /* im */
                                },
                                {
                                    0.0,                /* re */
                                    0.70710678118654746 /* im */
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
                                    0.0,                /* re */
                                    0.70710678118654746 /* im */
                                },
                                {
                                    0.70710678118654746, /* re */
                                    0.0                  /* im */
                                },
                                {
                                    0.0, /* re */
                                    0.0  /* im */
                                },
                                {
                                    0.0,                /* re */
                                    0.70710678118654746 /* im */
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
                                    0.70710678118654746, /* re */
                                    0.0                  /* im */
                                }};
  static const creal_T dcv[16] = {{
                                      0.70710678118654746, /* re */
                                      -0.0                 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.0,                 /* re */
                                      -0.70710678118654746 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.70710678118654746, /* re */
                                      -0.0                 /* im */
                                  },
                                  {
                                      0.0,                 /* re */
                                      -0.70710678118654746 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.0,                 /* re */
                                      -0.70710678118654746 /* im */
                                  },
                                  {
                                      0.70710678118654746, /* re */
                                      -0.0                 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.0,                 /* re */
                                      -0.70710678118654746 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.0, /* re */
                                      -0.0 /* im */
                                  },
                                  {
                                      0.70710678118654746, /* re */
                                      -0.0                 /* im */
                                  }};
  static const signed char iv[4] = {1, 0, 0, 0};
  creal_T Rot_x[16];
  creal_T Rot_z[16];
  creal_T dcv1[16];
  creal_T dcv2[16];
  creal_T Rot_x0[4];
  creal_T Rot_x1[4];
  creal_T Rot_z0[4];
  creal_T Rot_z1[4];
  float Rot_y[16];
  float Rot_y0[4];
  float Rot_y1[4];
  float Rot_x0_tmp_im;
  float Rot_x0_tmp_re;
  float Rot_x0_tmp_re_tmp;
  float Rot_y0_tmp;
  float Rot_y_tmp;
  float b_Rot_y_tmp;
  float c_Rot_y_tmp;
  float d;
  float d1;
  float d10;
  float d11;
  float d2;
  float d3;
  float d4;
  float d5;
  float d6;
  float d7;
  float d8;
  float d9;
  float r;
  int b_j1;
  int b_kidx;
  int c_kidx;
  int i;
  int j2;
  int kidx;
  if (!isInitialized_quantum_minority) {
    quantum_minority_initialize();
  }
  Rot_x0_tmp_re_tmp = sin(rx0 / 2.0);
  Rot_x0_tmp_re = Rot_x0_tmp_re_tmp * 0.0;
  d = cos(rx0 / 2.0);
  Rot_x0[0].re = d;
  Rot_x0[0].im = 0.0;
  Rot_x0[2].re = Rot_x0_tmp_re;
  Rot_x0[2].im = -Rot_x0_tmp_re_tmp;
  Rot_x0[1].re = Rot_x0_tmp_re;
  Rot_x0[1].im = -Rot_x0_tmp_re_tmp;
  Rot_x0[3].re = d;
  Rot_x0[3].im = 0.0;
  Rot_x0_tmp_re_tmp = sin(rx1 / 2.0);
  Rot_x0_tmp_re = Rot_x0_tmp_re_tmp * 0.0;
  d = cos(rx1 / 2.0);
  Rot_x1[0].re = d;
  Rot_x1[0].im = 0.0;
  Rot_x1[2].re = Rot_x0_tmp_re;
  Rot_x1[2].im = -Rot_x0_tmp_re_tmp;
  Rot_x1[1].re = Rot_x0_tmp_re;
  Rot_x1[1].im = -Rot_x0_tmp_re_tmp;
  Rot_x1[3].re = d;
  Rot_x1[3].im = 0.0;
  Rot_x0_tmp_re_tmp = sin(ry0 / 2.0);
  Rot_y0_tmp = cos(ry0 / 2.0);
  Rot_y0[0] = Rot_y0_tmp;
  Rot_y0[2] = -Rot_x0_tmp_re_tmp;
  Rot_y0[1] = Rot_x0_tmp_re_tmp;
  Rot_y0[3] = Rot_y0_tmp;
  Rot_x0_tmp_re_tmp = sin(ry1 / 2.0);
  Rot_y0_tmp = cos(ry1 / 2.0);
  Rot_y1[0] = Rot_y0_tmp;
  Rot_y1[2] = -Rot_x0_tmp_re_tmp;
  Rot_y1[1] = Rot_x0_tmp_re_tmp;
  Rot_y1[3] = Rot_y0_tmp;
  Rot_y0_tmp = 0.0 * rz0;
  if (-rz0 == 0.0) {
    Rot_x0_tmp_re = Rot_y0_tmp / 2.0;
    Rot_x0_tmp_im = 0.0;
  } else if (Rot_y0_tmp == 0.0) {
    Rot_x0_tmp_re = 0.0;
    Rot_x0_tmp_im = -rz0 / 2.0;
  } else {
    Rot_x0_tmp_re = rtNaN;
    Rot_x0_tmp_im = -rz0 / 2.0;
  }
  if (rz0 == 0.0) {
    Rot_y0_tmp /= 2.0;
    Rot_x0_tmp_re_tmp = 0.0;
  } else if (Rot_y0_tmp == 0.0) {
    Rot_y0_tmp = 0.0;
    Rot_x0_tmp_re_tmp = rz0 / 2.0;
  } else {
    Rot_y0_tmp = rtNaN;
    Rot_x0_tmp_re_tmp = rz0 / 2.0;
  }
  if (Rot_x0_tmp_im == 0.0) {
    Rot_x0_tmp_re = exp(Rot_x0_tmp_re);
    Rot_x0_tmp_im = 0.0;
  } else {
    r = exp(Rot_x0_tmp_re / 2.0);
    Rot_x0_tmp_re = r * (r * cos(Rot_x0_tmp_im));
    Rot_x0_tmp_im = r * (r * sin(Rot_x0_tmp_im));
  }
  if (Rot_x0_tmp_re_tmp == 0.0) {
    Rot_y0_tmp = exp(Rot_y0_tmp);
    Rot_x0_tmp_re_tmp = 0.0;
  } else {
    r = exp(Rot_y0_tmp / 2.0);
    Rot_y0_tmp = r * (r * cos(Rot_x0_tmp_re_tmp));
    Rot_x0_tmp_re_tmp = r * (r * sin(Rot_x0_tmp_re_tmp));
  }
  Rot_z0[0].re = Rot_x0_tmp_re;
  Rot_z0[0].im = Rot_x0_tmp_im;
  Rot_z0[2].re = 0.0;
  Rot_z0[2].im = 0.0;
  Rot_z0[1].re = 0.0;
  Rot_z0[1].im = 0.0;
  Rot_z0[3].re = Rot_y0_tmp;
  Rot_z0[3].im = Rot_x0_tmp_re_tmp;
  Rot_y0_tmp = 0.0 * rz1;
  if (-rz1 == 0.0) {
    Rot_x0_tmp_re = Rot_y0_tmp / 2.0;
    Rot_x0_tmp_im = 0.0;
  } else if (Rot_y0_tmp == 0.0) {
    Rot_x0_tmp_re = 0.0;
    Rot_x0_tmp_im = -rz1 / 2.0;
  } else {
    Rot_x0_tmp_re = rtNaN;
    Rot_x0_tmp_im = -rz1 / 2.0;
  }
  if (rz1 == 0.0) {
    Rot_y0_tmp /= 2.0;
    Rot_x0_tmp_re_tmp = 0.0;
  } else if (Rot_y0_tmp == 0.0) {
    Rot_y0_tmp = 0.0;
    Rot_x0_tmp_re_tmp = rz1 / 2.0;
  } else {
    Rot_y0_tmp = rtNaN;
    Rot_x0_tmp_re_tmp = rz1 / 2.0;
  }
  if (Rot_x0_tmp_im == 0.0) {
    Rot_x0_tmp_re = exp(Rot_x0_tmp_re);
    Rot_x0_tmp_im = 0.0;
  } else {
    r = exp(Rot_x0_tmp_re / 2.0);
    Rot_x0_tmp_re = r * (r * cos(Rot_x0_tmp_im));
    Rot_x0_tmp_im = r * (r * sin(Rot_x0_tmp_im));
  }
  if (Rot_x0_tmp_re_tmp == 0.0) {
    Rot_y0_tmp = exp(Rot_y0_tmp);
    Rot_x0_tmp_re_tmp = 0.0;
  } else {
    r = exp(Rot_y0_tmp / 2.0);
    Rot_y0_tmp = r * (r * cos(Rot_x0_tmp_re_tmp));
    Rot_x0_tmp_re_tmp = r * (r * sin(Rot_x0_tmp_re_tmp));
  }
  Rot_z1[0].re = Rot_x0_tmp_re;
  Rot_z1[0].im = Rot_x0_tmp_im;
  Rot_z1[2].re = 0.0;
  Rot_z1[2].im = 0.0;
  Rot_z1[1].re = 0.0;
  Rot_z1[1].im = 0.0;
  Rot_z1[3].re = Rot_y0_tmp;
  Rot_z1[3].im = Rot_x0_tmp_re_tmp;
  kidx = -1;
  b_kidx = -1;
  c_kidx = -1;
  for (b_j1 = 0; b_j1 < 2; b_j1++) {
#pragma HLS PIPELINE
    i = b_j1 << 1;
    d = Rot_x0[i].re;
    Rot_y0_tmp = Rot_x0[i].im;
    Rot_x0_tmp_re_tmp = Rot_y0[i];
    r = Rot_z0[i].re;
    Rot_x0_tmp_im = Rot_z0[i].im;
    Rot_x0_tmp_re = Rot_x0[i + 1].re;
    d1 = Rot_x0[i + 1].im;
    Rot_y_tmp = Rot_y0[i + 1];
    d2 = Rot_z0[i + 1].re;
    d3 = Rot_z0[i + 1].im;
    for (j2 = 0; j2 < 2; j2++) {
#pragma HLS PIPELINE
      i = j2 << 1;
      d4 = Rot_x1[i].re;
      d5 = Rot_x1[i].im;
      Rot_x[kidx + 1].re = d * d4 - Rot_y0_tmp * d5;
      Rot_x[kidx + 1].im = d * d5 + Rot_y0_tmp * d4;
      b_Rot_y_tmp = Rot_y1[i];
      Rot_y[b_kidx + 1] = Rot_x0_tmp_re_tmp * b_Rot_y_tmp;
      d6 = Rot_z1[i].re;
      d7 = Rot_z1[i].im;
      Rot_z[c_kidx + 1].re = r * d6 - Rot_x0_tmp_im * d7;
      Rot_z[c_kidx + 1].im = r * d7 + Rot_x0_tmp_im * d6;
      d8 = Rot_x1[i + 1].re;
      d9 = Rot_x1[i + 1].im;
      Rot_x[kidx + 2].re = d * d8 - Rot_y0_tmp * d9;
      Rot_x[kidx + 2].im = d * d9 + Rot_y0_tmp * d8;
      c_Rot_y_tmp = Rot_y1[i + 1];
      Rot_y[b_kidx + 2] = Rot_x0_tmp_re_tmp * c_Rot_y_tmp;
      d10 = Rot_z1[i + 1].re;
      d11 = Rot_z1[i + 1].im;
      Rot_z[c_kidx + 2].re = r * d10 - Rot_x0_tmp_im * d11;
      Rot_z[c_kidx + 2].im = r * d11 + Rot_x0_tmp_im * d10;
      kidx += 2;
      b_kidx += 2;
      c_kidx += 2;
      Rot_x[kidx + 1].re = Rot_x0_tmp_re * d4 - d1 * d5;
      Rot_x[kidx + 1].im = Rot_x0_tmp_re * d5 + d1 * d4;
      Rot_y[b_kidx + 1] = Rot_y_tmp * b_Rot_y_tmp;
      Rot_z[c_kidx + 1].re = d2 * d6 - d3 * d7;
      Rot_z[c_kidx + 1].im = d2 * d7 + d3 * d6;
      Rot_x[kidx + 2].re = Rot_x0_tmp_re * d8 - d1 * d9;
      Rot_x[kidx + 2].im = Rot_x0_tmp_re * d9 + d1 * d8;
      Rot_y[b_kidx + 2] = Rot_y_tmp * c_Rot_y_tmp;
      Rot_z[c_kidx + 2].re = d2 * d10 - d3 * d11;
      Rot_z[c_kidx + 2].im = d2 * d11 + d3 * d10;
      kidx += 2;
      b_kidx += 2;
      c_kidx += 2;
    }
  }
  for (i = 0; i < 4; i++) {
#pragma HLS PIPELINE
    d = dcv[i].re;
    Rot_y0_tmp = dcv[i].im;
    r = dcv[i + 4].re;
    Rot_x0_tmp_im = dcv[i + 4].im;
    Rot_x0_tmp_re = dcv[i + 8].re;
    d1 = dcv[i + 8].im;
    d2 = dcv[i + 12].re;
    d3 = dcv[i + 12].im;
    for (c_kidx = 0; c_kidx < 4; c_kidx++) {
#pragma HLS PIPELINE
      kidx = c_kidx << 2;
      b_j1 = i + kidx;
      d4 = Rot_z[kidx].re;
      d5 = Rot_z[kidx].im;
      d6 = Rot_z[kidx + 1].re;
      d7 = Rot_z[kidx + 1].im;
      d8 = Rot_z[kidx + 2].re;
      d9 = Rot_z[kidx + 2].im;
      d10 = Rot_z[kidx + 3].re;
      d11 = Rot_z[kidx + 3].im;
      dcv1[b_j1].re =
          (((d * d4 - Rot_y0_tmp * d5) + (r * d6 - Rot_x0_tmp_im * d7)) +
           (Rot_x0_tmp_re * d8 - d1 * d9)) +
          (d2 * d10 - d3 * d11);
      dcv1[b_j1].im =
          (((d * d5 + Rot_y0_tmp * d4) + (r * d7 + Rot_x0_tmp_im * d6)) +
           (Rot_x0_tmp_re * d9 + d1 * d8)) +
          (d2 * d11 + d3 * d10);
    }
  }
  for (i = 0; i < 16; i++) {
#pragma HLS PIPELINE
    Rot_z[i].re = Rot_y[i];
    Rot_z[i].im = 0.0;
  }
  for (i = 0; i < 4; i++) {
#pragma HLS PIPELINE
    d = dcv1[i].re;
    Rot_y0_tmp = dcv1[i].im;
    r = dcv1[i + 4].re;
    Rot_x0_tmp_im = dcv1[i + 4].im;
    Rot_x0_tmp_re = dcv1[i + 8].re;
    d1 = dcv1[i + 8].im;
    d2 = dcv1[i + 12].re;
    d3 = dcv1[i + 12].im;
    for (c_kidx = 0; c_kidx < 4; c_kidx++) {
#pragma HLS PIPELINE
      kidx = c_kidx << 2;
      b_j1 = i + kidx;
      d4 = Rot_z[kidx].re;
      d5 = Rot_z[kidx].im;
      d6 = Rot_z[kidx + 1].re;
      d7 = Rot_z[kidx + 1].im;
      d8 = Rot_z[kidx + 2].re;
      d9 = Rot_z[kidx + 2].im;
      d10 = Rot_z[kidx + 3].re;
      d11 = Rot_z[kidx + 3].im;
      dcv2[b_j1].re =
          (((d * d4 - Rot_y0_tmp * d5) + (r * d6 - Rot_x0_tmp_im * d7)) +
           (Rot_x0_tmp_re * d8 - d1 * d9)) +
          (d2 * d10 - d3 * d11);
      dcv2[b_j1].im =
          (((d * d5 + Rot_y0_tmp * d4) + (r * d7 + Rot_x0_tmp_im * d6)) +
           (Rot_x0_tmp_re * d9 + d1 * d8)) +
          (d2 * d11 + d3 * d10);
    }
    d = dcv2[i].re;
    Rot_y0_tmp = dcv2[i].im;
    r = dcv2[i + 4].re;
    Rot_x0_tmp_im = dcv2[i + 4].im;
    Rot_x0_tmp_re = dcv2[i + 8].re;
    d1 = dcv2[i + 8].im;
    d2 = dcv2[i + 12].re;
    d3 = dcv2[i + 12].im;
    for (c_kidx = 0; c_kidx < 4; c_kidx++) {
#pragma HLS PIPELINE
      kidx = c_kidx << 2;
      b_j1 = i + kidx;
      d4 = Rot_x[kidx].re;
      d5 = Rot_x[kidx].im;
      d6 = Rot_x[kidx + 1].re;
      d7 = Rot_x[kidx + 1].im;
      d8 = Rot_x[kidx + 2].re;
      d9 = Rot_x[kidx + 2].im;
      d10 = Rot_x[kidx + 3].re;
      d11 = Rot_x[kidx + 3].im;
      dcv1[b_j1].re =
          (((d * d4 - Rot_y0_tmp * d5) + (r * d6 - Rot_x0_tmp_im * d7)) +
           (Rot_x0_tmp_re * d8 - d1 * d9)) +
          (d2 * d10 - d3 * d11);
      dcv1[b_j1].im =
          (((d * d5 + Rot_y0_tmp * d4) + (r * d7 + Rot_x0_tmp_im * d6)) +
           (Rot_x0_tmp_re * d9 + d1 * d8)) +
          (d2 * d11 + d3 * d10);
    }
    d = dcv1[i].re;
    Rot_y0_tmp = dcv1[i].im;
    r = dcv1[i + 4].re;
    Rot_x0_tmp_im = dcv1[i + 4].im;
    Rot_x0_tmp_re = dcv1[i + 8].re;
    d1 = dcv1[i + 8].im;
    d2 = dcv1[i + 12].re;
    d3 = dcv1[i + 12].im;
    for (c_kidx = 0; c_kidx < 4; c_kidx++) {
#pragma HLS PIPELINE
      kidx = c_kidx << 2;
      b_j1 = i + kidx;
      d4 = a[kidx].re;
      d5 = a[kidx].im;
      d6 = a[kidx + 1].re;
      d7 = a[kidx + 1].im;
      d8 = a[kidx + 2].re;
      d9 = a[kidx + 2].im;
      d10 = a[kidx + 3].re;
      d11 = a[kidx + 3].im;
      dcv2[b_j1].re =
          (((d * d4 - Rot_y0_tmp * d5) + (r * d6 - Rot_x0_tmp_im * d7)) +
           (Rot_x0_tmp_re * d8 - d1 * d9)) +
          (d2 * d10 - d3 * d11);
      dcv2[b_j1].im =
          (((d * d5 + Rot_y0_tmp * d4) + (r * d7 + Rot_x0_tmp_im * d6)) +
           (Rot_x0_tmp_re * d9 + d1 * d8)) +
          (d2 * d11 + d3 * d10);
    }
    Rot_x0[i].re = iv[i];
    Rot_x0[i].im = 0.0;
  }
  i = (int)Rot_x0[0].re;
  d = Rot_x0[0].im;
  c_kidx = (int)Rot_x0[1].re;
  Rot_y0_tmp = Rot_x0[1].im;
  b_j1 = (int)Rot_x0[2].re;
  r = Rot_x0[2].im;
  kidx = (int)Rot_x0[3].re;
  Rot_x0_tmp_im = Rot_x0[3].im;
  for (b_kidx = 0; b_kidx < 4; b_kidx++) {
#pragma HLS PIPELINE
    Rot_x0_tmp_re = dcv2[b_kidx].re;
    d1 = dcv2[b_kidx].im;
    d2 = dcv2[b_kidx + 4].re;
    d3 = dcv2[b_kidx + 4].im;
    d4 = dcv2[b_kidx + 8].re;
    d5 = dcv2[b_kidx + 8].im;
    d6 = dcv2[b_kidx + 12].re;
    d7 = dcv2[b_kidx + 12].im;
    Rot_x0_tmp_re = rt_hypotd_snf((((Rot_x0_tmp_re * (float)i - d1 * d) +
                                    (d2 * (float)c_kidx - d3 * Rot_y0_tmp)) +
                                   (d4 * (float)b_j1 - d5 * r)) +
                                      (d6 * (float)kidx - d7 * Rot_x0_tmp_im),
                                  (((Rot_x0_tmp_re * d + d1 * (float)i) +
                                    (d2 * Rot_y0_tmp + d3 * (float)c_kidx)) +
                                   (d4 * r + d5 * (float)b_j1)) +
                                      (d6 * Rot_x0_tmp_im + d7 * (float)kidx));
    prob[b_kidx] = Rot_x0_tmp_re * Rot_x0_tmp_re;
  }
}

/* End of code generation (quantum_minority.c) */

/*
 * _coder_QGT_api.h
 *
 * Code generation for function 'QGT'
 *
 */

#ifndef _CODER_QGT_API_H
#define _CODER_QGT_API_H

/* Include files */
#include "emlrt.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void QGT(real_T rotAx1, real_T rotAy2, real_T rotAx3, real_T rotBx1,
         real_T rotBy2, real_T rotBx3, real_T *p00, real_T *p01, real_T *p10,
         real_T *p11);

void QGT_api(const mxArray *const prhs[6], int32_T nlhs,
             const mxArray *plhs[4]);

void QGT_atexit(void);

void QGT_initialize(void);

void QGT_terminate(void);

void QGT_xil_shutdown(void);

void QGT_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_QGT_api.h) */

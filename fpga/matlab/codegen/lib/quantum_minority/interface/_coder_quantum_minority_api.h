/*
 * _coder_quantum_minority_api.h
 *
 * Code generation for function 'quantum_minority'
 *
 */

#ifndef _CODER_QUANTUM_MINORITY_API_H
#define _CODER_QUANTUM_MINORITY_API_H

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
void quantum_minority(real_T rx0, real_T ry0, real_T rz0, real_T rx1,
                      real_T ry1, real_T rz1, real_T prob[4]);

void quantum_minority_api(const mxArray *const prhs[6], const mxArray **plhs);

void quantum_minority_atexit(void);

void quantum_minority_initialize(void);

void quantum_minority_terminate(void);

void quantum_minority_xil_shutdown(void);

void quantum_minority_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_quantum_minority_api.h) */

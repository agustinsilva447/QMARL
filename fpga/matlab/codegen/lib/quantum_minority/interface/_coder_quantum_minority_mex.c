/*
 * _coder_quantum_minority_mex.c
 *
 * Code generation for function 'quantum_minority'
 *
 */

/* Include files */
#include "_coder_quantum_minority_mex.h"
#include "_coder_quantum_minority_api.h"

/* Function Definitions */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&quantum_minority_atexit);
  /* Module initialization. */
  quantum_minority_initialize();
  /* Dispatch the entry-point. */
  unsafe_quantum_minority_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  quantum_minority_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2021a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL);
  return emlrtRootTLSGlobal;
}

void unsafe_quantum_minority_mexFunction(int32_T nlhs, mxArray *plhs[1],
                                         int32_T nrhs, const mxArray *prhs[6])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 6) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 6, 4,
                        16, "quantum_minority");
  }
  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 16,
                        "quantum_minority");
  }
  /* Call the function. */
  quantum_minority_api(prhs, &outputs);
  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, &plhs[0], &outputs);
}

/* End of code generation (_coder_quantum_minority_mex.c) */

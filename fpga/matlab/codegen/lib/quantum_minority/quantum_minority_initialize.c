/*
 * quantum_minority_initialize.c
 *
 * Code generation for function 'quantum_minority_initialize'
 *
 */

/* Include files */
#include "quantum_minority_initialize.h"
#include "quantum_minority_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void quantum_minority_initialize(void)
{
  rt_InitInfAndNaN();
  isInitialized_quantum_minority = true;
}

/* End of code generation (quantum_minority_initialize.c) */

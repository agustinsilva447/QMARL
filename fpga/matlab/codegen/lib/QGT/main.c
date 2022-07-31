#include <stdio.h>
#include "main.h"
#include "QGT.h"
#include "QGT_terminate.h"

/* Function Declarations */
static void main_QGT(void);

static void main_QGT(void)
{
  float p00;
  float p01;
  float p10;
  float p11;
  QGT(7,6,5,4,3,2, &p00, &p01, &p10, &p11);
  printf("p00 = %f. p01 = %f. p10 = %f. p11 = %f.\n",p00,p01,p10,p11);

}

int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  main_QGT();
  QGT_terminate();
  return 0;
}

/* End of code generation (main.c) */

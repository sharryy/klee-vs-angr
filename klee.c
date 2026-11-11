#include <klee/klee.h>

char buf[8] = "AAAAAAA";
char secret[8] = "SECRET!";

int main(void) {
  unsigned char i;

  klee_make_symbolic(&i, sizeof(i), "i");
  klee_assume(i < 16);

  buf[i] = 'X'; // in bounds only for i < 8
  return 0;
}

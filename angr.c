#include <stdio.h>
#include <unistd.h>

char buf[8];
char secret[8] = "SECRET!";

int main(void) {
  unsigned char i;

  if (read(0, &i, 1) != 1)
    return 1;
  if (i > 16)
    return 1;

  buf[i] = 'X';
  puts(secret);

  return 0;
}

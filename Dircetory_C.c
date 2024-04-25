#include <stdio.h>

unsigned int check_dir(char* a);

int main()
{
	char tab[100] = "C:\\WINDOWS\\system32";
	unsigned int a;
	a = check_dir(tab);

	printf("w1 = %u\n", a);

	return 0;
}
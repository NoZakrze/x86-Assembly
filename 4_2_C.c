#include <stdio.h>
void liczba_przeciwna(int* a);
int main()
{
	int m;
	m = 9;
	liczba_przeciwna(&m);
	printf("\n m = %d\n", m);
	return 0;
}
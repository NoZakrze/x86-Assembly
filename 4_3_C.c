#include <stdio.h>

void odejmij_jeden(int** a);

int main()
{
	int k;
	int* wsk;
	wsk = &k;
	scanf_s("%d", &k, 12);

	odejmij_jeden(&wsk);

	printf("k = %d", k);

	return 0;
}
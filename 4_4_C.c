#include <stdio.h>

void przestaw(int* tablica, int n);

int main()
{
	int tab[5] = { 32,4,-4,3,-222 };

	for (int i = 1; i < 5; i++)
	{
		przestaw(tab, 5 - i);
	}
	for (int i = 0; i < 5; i++)
	{
		printf("%d\n", tab[i]);
	}


	return 0;
}
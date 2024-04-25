#include <stdio.h>


int swapik(int*, unsigned int, int, int);

int main()
{
	int tab[] = { 1,2,3,4,5 };
	int w=swapik(tab, 5, 1, 4);
	printf("return %d\n", w);
	for (int i = 0; i < 5; i++)
	{
		printf("%d\n", tab[i]);
	}
	int tab2[] = { 1,2,3,4,5 };
	w = swapik(tab2, 5, 1, 5);
	printf("return %d\n", w);
	for (int i = 0; i < 5; i++)
	{
		printf("%d\n", tab2[i]);
	}

	return 0;
}
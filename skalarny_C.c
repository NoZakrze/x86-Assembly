#include <stdio.h>
#include<Windows.h>

int iloczyn(int*,int*,int);

int main()
{
	int tab1[3] = { 1,2,3 };
	int tab2[3] = { 1,-2,5 };
	int n = 3;
	int wynik;
	wynik = iloczyn(tab1, tab2, n);
	printf("%d", wynik);
	

	return 0;
}
#include <stdio.h>

int szukaj_maxa_4(int a, int b, int c);

int main()
{
	int w, x, y, z, wynik;
	printf("\nProsze podac cztery liczby calkowite ze znakiem: ");
	scanf_s("%d %d %d %d", &w, &x, &y, &z, 32);

	wynik = szukaj_maxa_4(w, x, y, z);

	printf(" Najwieksza liczba z podanych to: %d\n", wynik);

	return 0;
}
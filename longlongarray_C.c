#include <stdio.h>

long long* c_array(char* tekst);

int main()
{
	char tab[256];
	fgets(tab, 256, stdin);
	long long* a;
	a = c_array(tab);

	for (int i = 0; i < 4; i++)
	{
		printf("%lld\n", a[i]);
	}

	return 0;
}
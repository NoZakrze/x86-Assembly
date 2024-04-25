#include <stdio.h>

int palindrom(wchar_t* tab, unsigned int n);

int main()
{
	int w1, w2;
	w1 = palindrom(u"kajak", 5);
	w2 = palindrom(u"woda", 4);


	printf("w1 = %d\nw2 = %d", w1, w2);

	return 0;
}
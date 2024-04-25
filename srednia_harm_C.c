#include <stdio.h>

float srednia_harm(float* tab, unsigned int n);

int main()
{

	float tab[] = { 1.5, 2.0, 3.2 };
	float w = srednia_harm(tab, 3);
	printf("%f", w);


	return 0;
}
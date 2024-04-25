#include <stdio.h>
#include<Windows.h>

unsigned int fibonacci(unsigned char);

int main()
{
	unsigned int w;
	w = fibonacci(7);
	printf("%d\n", w);
	w = fibonacci(8);
	printf("%d\n", w);
	w = fibonacci(48);
	printf("%d\n", w);
	w = fibonacci(0);
	printf("%d\n", w);

	return 0;
}
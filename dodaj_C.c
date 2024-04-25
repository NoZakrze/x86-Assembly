#include <stdio.h>
extern __int64 suma(unsigned int n,...);

int main()
{

	__int64 v1, v2, v3, v4, v5, v6, v7;
	v1 = -15;
	v2 = 4000000;
	v3 = -345679;
	v4 = 88046592;
	v5 = -1;
	v6 = 2297645;
	v7 = 444444444444444;

	__int64 wartosc;

	wartosc = suma(6, v2, v3, v4, v5, v6, v7);
	printf("\nSuma liczb wynosi %I64d\n", wartosc);

	wartosc = suma(4, 100000000LL, 2LL, 3LL, 4LL);
	printf("\nSuma liczb wynosi %I64d\n", wartosc);

	wartosc = suma(0);
	printf("\nSuma liczb wynosi %I64d\n", wartosc);

	wartosc = suma(1, 4LL);
	printf("\nSuma liczb wynosi %I64d\n", wartosc);

	return 0;
}
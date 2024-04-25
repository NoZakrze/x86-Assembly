#include <stdio.h>
extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64 v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);

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

	wartosc = suma_siedmiu_liczb(v1, v2, v3, v4, v5, v6, v7);
	printf("\nSuma liczb wynosi %I64d\n", wartosc);


	return 0;
}
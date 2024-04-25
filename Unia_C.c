#include <stdio.h>
#include <xmmintrin.h>
__m128 mul_at_once(__m128 one, __m128 two);
int main()
{
	__m128 jeden, dwa;
	jeden.m128_i32[0] = 4;
	jeden.m128_i32[1] = 5;
	jeden.m128_i32[2] = 6;
	jeden.m128_i32[3] = 7;

	dwa.m128_i32[0] = 3;
	dwa.m128_i32[1] = 10;
	dwa.m128_i32[2] = 20;
	dwa.m128_i32[3] = 30;

	__m128 wynik = mul_at_once(jeden, dwa);

	for (int i = 0; i < 4; i++)
	{
		printf("%d\n", wynik.m128_i32[i]);
	}
	return 0;
}
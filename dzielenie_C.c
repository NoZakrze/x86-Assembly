#include <stdio.h>
#include<Windows.h>

int dzielenie(int*, int**);

int main()
{
	int a = 35, b = -4;
	int* wsk1, * wsk2, ** wsk3;
	wsk1 = &a;
	wsk2 = &b;
	wsk3 = &wsk2;
	int w = dzielenie(wsk1, wsk3);
	printf("%d", w);

	return 0;
}
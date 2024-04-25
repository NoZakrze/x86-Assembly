#include <stdio.h>
float findmaxrange(float, int);
int main()
{
	float v= 15.2,v1=20.0;
	int a= 45, a1=30, a2=80;
	float w = findmaxrange(v, a),w1,w2;
	w1 = findmaxrange(v1, a1);
	w2 = findmaxrange(v1, a2);
	printf("%f\n%f\n%f\n", w,w1,w2);

	return 0;
}
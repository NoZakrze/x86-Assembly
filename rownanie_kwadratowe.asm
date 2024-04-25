.686
.model flat
public _main

.data
wsp_a	dd	+2.0
wsp_b	dd	-1.0
wsp_c	dd	-15.0

dwa		dd	2.0
cztery	dd	4.0
x1		dd	?
x2		dd	?

.code

_main PROC

		finit
		fld		wsp_a
		fld		wsp_b
		fst		st(2)			;st(0) kopiuj do st(2)
		
								;stos:	b,a,b

		fmul	st(0), st(0)
		fld		cztery

								;stos:	4.0, b^2 , a , b

		fmul	st(0), st(2)
		fmul	wsp_c

								;stos:	4ac, b^2, a , b

		fsubp	st(1), st(0)

								;stos: b^2-4ac, a , b

		fldz					;ST(0) = 0
		fcomi	st(0), st(1)
		fstp	st(0)			;usuniecie 0 ze stosu
		ja		delta_ujemna
		fxch	st(1)			;zamiana st(0) i st(1)

		fadd	st(0), st(0)	;2*a
								;stos:	2*a, delta, b
		fstp	st(3)			; st(0) do st(3), usun st(0)
								;stos:	delta, b, 2a
		fsqrt
		fst		st(3)			
								;stos: sqrt(delta), b, 2a, sqrt(delta)
		fchs					;zmiana znaku
		fsub	st(0), st(1)	;-sqrt(delta) - b
		fdiv	st(0), st(2)
		fstp	x1
								;stos:	b, 2a, sqrt(delta)
		fchs
		fadd	st(0), st(2)
		fdiv	st(0), st(1)
		fstp	x2
								;stos: 2a, sqrt(delta)
		fstp	st(0)
		fstp	st(0)
		jmp		koniec

delta_ujemna:
		fstp	st(0)
		fstp	st(0)
		fstp	st(0)
koniec:

_main ENDP
END
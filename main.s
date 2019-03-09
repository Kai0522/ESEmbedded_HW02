.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	mov    r0,#001
    mov    r1,#002
    mov    r2,#003
    
    push   {r0,r1,r2} //pushing forward
    pop    {r3,r4,r5} //poping forward

    mov    r3,0
    mov    r4,0
    mov    r5,0

    push   {r0,r1,r2}
    pop    {r3}       //testing pop 
    pop    {r4}
    pop    {r5}

    push   {r2,r1,r0} //pushing backward
    pop    {r5,r4,r3} //poping backward

	//
	//branch w/o link
	//
	b	label01

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.

.global _start
_start:
    addi x1, x0, 5
    addi x2, x0, 10
    addi x3, x0, 20
    add  x3, x1, x2
    add  x4, x2, x3
    nop
    nop
    nop

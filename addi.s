# Constants
PRINT_STR   = 4

    .data
pass:   .asciiz "Pass\n"
fail:   .asciiz "Fail\n"

    .text
main:
    li      $t0, 2147483647
    addi    $t0, $t0, 23        # Overflow

    bne     $t0, 42, L1
    la      $a0, pass
    j       L2
L1:
    la      $a0, fail
L2:
    li      $v0, PRINT_STR
    syscall
    jr      $ra

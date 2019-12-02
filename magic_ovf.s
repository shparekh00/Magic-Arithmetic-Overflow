# Constants
MAGIC_NUMBER = 42
PRINT_INT = 1
PRINT_STR = 4

# System data
    .kdata
backup:     .space      116         # save all user registers
unhandled:  .asciiz     "Unhandled exception\n"

# System code
    .ktext  0x80000180
main:
# Prologue
    # back up all user registers
    .set noat           # Allow temporary access to $at
    move    $k1, $at    # Copy $at
    .set at             # Revert access
    la      $k0, backup	
    sw		$k1, 0($k0)	# save $at
    sw      $v0, 4($k0)
    sw      $v1, 8($k0)
    sw      $a0, 12($k0)
    sw      $a1, 16($k0) 
    sw      $a2, 20($k0)
    sw      $a3, 24($k0) 
    sw      $t0, 28($k0)
    sw      $t1, 32($k0)
    sw      $t2, 36($k0)
    sw      $t3, 44($k0)
    sw      $t4, 48($k0)
    sw      $t5, 52($k0)
    sw      $t6, 56($k0)
    sw      $t7, 60($k0)
    sw      $s0, 64($k0)
    sw      $s1, 68($k0)
    sw      $s2, 72($k0)
    sw      $s3, 76($k0)
    sw      $s4, 80($k0)
    sw      $s5, 84($k0)
    sw      $s6, 88($k0)
    sw      $s7, 92($k0)
    sw      $t8, 96($k0)
    sw      $t9, 100($k0)
    sw      $gp, 104($k0)
    sw      $sp, 108($k0)
    sw      $fp, 112($k0)
    sw      $ra, 116($k0)

# Body
    mfc0 $k0, $13           # cause register
    srl  $a0, $a0, 2
    andi $a0, $a0, 0x1F     # extract ExcCode
    li   $t1, 12            # arithmetic overflow code
    bne  $a0,               # check if code matches ovf code

    # Display ExcCode
    li   $v0, PRINT_INT
    syscall








# Startup routine for user code
    .text
    .globl __start
__start:
        jal main            # main()
        li  $v0, 10
        syscall             # exit()
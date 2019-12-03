# Constants
PRINT_STR = 4

# System data
    .kdata
backup:     .space      116         # save all user registers
unhandled:  .asciiz     "Unhandled exception\n"

# System code
    .ktext  0x80000180

# Prologue
    # back up all user registers
.set noat               # Allow temporary access to $at
    move    $k1, $at    # Copy $at
.set at                 # Revert access
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
    sw      $t3, 40($k0)
    sw      $t4, 44($k0)
    sw      $t5, 48($k0)
    sw      $t6, 52($k0)
    sw      $t7, 56($k0)
    sw      $s0, 60($k0)
    sw      $s1, 64($k0)
    sw      $s2, 68($k0)
    sw      $s3, 72($k0)
    sw      $s4, 76($k0)
    sw      $s5, 80($k0)
    sw      $s6, 84($k0)
    sw      $s7, 88($k0)
    sw      $t8, 92($k0)
    sw      $t9, 96($k0)
    sw      $gp, 100($k0)
    sw      $sp, 104($k0)
    sw      $fp, 108($k0)
    sw      $ra, 112($k0)

# Body
    mfc0    $t0, $13            # move cause cause register into $t0
    srl     $t0, $t0, 2
    andi    $t0, $t0, 0x1F      # extract ExcCode in $t0
    li      $t1, 12             # arithmetic overflow code
    bne     $a0, $t1, notOvf    # check if code matches ovf code
    
    mfc0    $a1, $14            # move EPC address of faulty instruction into $t0
    lw		$t2, 0($a1)		    # load contents of faulty instruction into $t2
    addiu   $a1, $a1, 4         # move to next instruction
    
    # determine if Type R or Type I
    srl     $t3, $t2, 26        # get opcode of instruction into $t3
    bne		$t3, $zero, TypeI	# if $t2 !=zero then TypeI
    
    # Get value of $rd, and store magic number
    srl     $t4, $t2, 16
    sll     $t4, $t4, 11        # access bits 11-15 of instruction for $rd
    sll	    $t4, $t4, 2			# multiply by 4
    li      $t3, 4
    sub     $t4,$t4, $t3        # subtract 4 from address
    addu    $t5, $k0, $t4       # move to $rd address in backup
    li      $t6, 42             # load magic number
    sw      $t6, 0($t5)         # save magic number in register "$rd"
    j       continue
 
 TypeI:
    srl     $t4, $t2, 22
    sll     $t4, $t4, 16        # access bits 11-15 of instruction for $rd
    sll	    $t4, $t4, 2			# multiply by 4
    li      $t1, 4
    sub     $t4,$t4, $t1        # subtract 4 from address
    addu    $t5, $k0, $t4       # move to $rd address in backup
    li      $t6, 42             # load magic number
    sw      $t6, 0($t5)         # save magic number in $rt
    j       continue

notOvf:
    # Display ExcCode
    la		$a0, unhandled      # print unhandled exception message 
    li      $v0, PRINT_STR
    syscall
    li      $a0, 1              # exit with error code 1
    li      $v0, 17
    syscall
    #j 		continue			# jump to $ra
    
continue:
# Epilogue              
    la      $k0, backup	
    lw      $ra, 112($k0)
    lw      $fp, 108($k0)
    lw      $sp, 104($k0)
    lw      $gp, 100($k0)
    lw      $t9, 96($k0)
    lw      $t8, 92($k0)
    lw      $s7, 88($k0)
    lw      $s6, 84($k0)
    lw      $s5, 80($k0)
    lw      $s4, 76($k0)
    lw      $s3, 72($k0)
    lw      $s2, 68($k0)
    lw      $s1, 64($k0)
    lw      $s0, 60($k0)
    lw      $t7, 56($k0)
    lw      $t6, 52($k0)
    lw      $t5, 48($k0)
    lw      $t4, 44($k0)
    lw      $t3, 40($k0)
    lw      $t2, 36($k0)
    lw      $t1, 32($k0)
    lw      $t0, 28($k0)
    lw      $a3, 24($k0) 
    lw      $a2, 20($k0)
    lw      $a1, 16($k0) 
    lw      $a0, 12($k0)
    lw      $v1, 8($k0)
    lw      $v0, 4($k0)
    lw		$k1, 0($k0)	        
    
.set noat           
    move    $k1, $at            # restore $at
.set at
    eret                        # return from exception





# Startup routine for user code
    .text
    .globl __start
__start:
        jal main            # main()
        li  $v0, 10
        syscall             # exit()
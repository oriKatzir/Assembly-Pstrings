

    .section    .rodata

invalid_choice_msg_format:  .string "invalid option!\n"

length_printing_format:	.string	"first pstring length: %d, second pstring length: %d\n"

char_replacing_format:	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"

pstring_printing_format:   .string "length: %d, string: %s\n"

comparison_result_format:   .string "compare result: %d\n"

get_char_from_user_format:  .string "%c%c"

get_char_from_buffer_format:  .string "%c"

get_index_from_user_format: .string "%d"

    .align 8
.JMP_TABLE:
         .quad  .INVALID_CHOICE_CASE    # in case the user chose 30, this case index in the jump table is: 0
         .quad  .LENGTH_PRINTING_CASE   # in case the user chose 31, this case index in the jump table is: 1
         .quad  .CHAR_REPLACING_CASE    # in case the user chose 32, this case index in the jump table is: 2
         .quad  .CHAR_REPLACING_CASE    # in case the user chose 33, this case index in the jump table is: 3
         .quad  .INVALID_CHOICE_CASE    # in case the user chose 34, this case index in the jump table is: 4
         .quad  .INTERVAL_CPY_CASE      # in case the user chose 35, this case index in the jump table is: 5
         .quad  .CASE_SWAPPING_CASE     # in case the user chose 36, this case index in the jump table is: 6
         .quad  .INTERVAL_CMP_CASE      # in case the user chose 37, this case index in the jump table is: 7

    .text

# A function that useses a jump table to controle the flow of this program
# Input:
#        an integer represrnting a choice of the user (stored in %rdi)
#        an adress of the first pstring that is in the stack frame of run_main function (the adress is stored in %rsi)
#        an adress of the second pstring that is in the stack frame of run_main function (the adress is stored in %rdx)
# Output:
#        0 (%rax = 0 in the end of this function)

.globl run_func    # making the function run_fung global so it could be reached frome other files
    .type   run_func, @function
run_func:

        # setting up the function

     pushq	%rbp         # save the old frame pointer. pushing 8 bytes into the stack.
     movq	%rsp, %rbp	 # create the new frame pointer.
     pushq   %r12        # saving a callee save register in this function stack frame. pushing 8 bytes into the stack
     pushq   %r13        # saving a callee save register in this function stack frame. pushing 8 bytes into the stack
     pushq   %r14        # saving a callee save register in this function stack frame. pushing 8 bytes into the stack

     subq    $30, %rdi   # (%rdi = %rdi - 30), creating an index that is in the range of [1,7] for the jump table
     cmpq    $7, %rdi    # compering choice index with 7
     ja      .INVALID_CHOICE_CASE    # checking if the choice is in the range of 0 - 7
     jmp     *.JMP_TABLE(,%rdi,8)    # indirect jump using the jump table

.LENGTH_PRINTING_CASE:
    movq    %rsi, %rdi  # Geting the adress of the first pstring into %rdi for it to be the first arg in pstrlen func.
    xorq    %rax, %rax  # %rax = 0
    call    pstrlen
    movq    %rax, %rsi  # Storing the length of the first pstring in %rsi as the second arg for the printf function.
    movq    %rdx, %rdi  # Geting the adress of the second pstring into %rdi for it to be the first arg in pstrlen func.
    xorq    %rax, %rax  # %rax = 0
    call    pstrlen
    movq    %rax, %rdx  # Storing the length of the second pstring in %rdx as a third arg for the prinf function.
    movq    $length_printing_format, %rdi   # The string is the first paramter passed to the printf function.
    xorq    %rax, %rax  # %rax = 0
    pushq   $3          # Pushing arbitrery value for 16 alingment.
    call    printf
    popq    %r12
    jmp     .END_OF_RUN_FUNC

.CHAR_REPLACING_CASE:
    movq    %rsi, %r12  # Geting the adress of the first pstring into %r12, for safe keeping.
    movq    %rdx, %r13  # Geting the adress of the second pstring into %r13, for safe keeping.
   # pushq   $3          # for 16 anlignment
    subq    $24, %rsp   # Expending this function stack frame with 24 bytes.

              # Getting the old char and new char from the user, using scanf
    # Getting rid off the '\n' from previos user input
    leaq    (%rsp), %rsi
    movq    $get_char_from_buffer_format, %rdi
    xorq    %rax, %rax
    call    scanf

    # Geting the first char, i.e the old char, from the user
    leaq    (%rsp), %rsi
    movq    $get_char_from_buffer_format, %rdi
    xorq    %rax, %rax  # %rax = 0
    call    scanf

    # Geting rid of the expected ' ' char in the user input
    leaq    1(%rsp), %rsi
    movq    $get_char_from_buffer_format, %rdi
    xorq    %rax, %rax  # %rax = 0
    call    scanf

    # Geting the second char, i.e the new char, from the user
    leaq    1(%rsp), %rsi
    movq    $get_char_from_buffer_format, %rdi
    xorq    %rax, %rax  # %rax = 0
    call    scanf

# Replacing in the first pstring
    movq    %r12, %rdi      # %rdi = adress of the first pstring, did this so it will be the first arg for replaceChar
    movb    (%rsp),%sil     # Setting the rightmost byte of %rsi to the old char value.
    movzbq  %sil, %rsi
    movb    1(%rsp), %dl    # Setting the rightmost byte of %rdx to the new char value.
    movzbq  %dl, %rdx
    call    replaceChar

# Replacing in the second pstring
    movq    %r13, %rdi      # %rdi = adress of the second pstring, did this so it will be the first arg for replaceChar
    movzbq  (%rsp), %rsi    # Setting the rightmost byte of %rsi to the old char value.
    movzbq  1(%rsp), %rdx    # Setting the rightmost byte of %rdx to the new char value.
    call    replaceChar

# Printing the messege with prinf
    xorq    %rax, %rax  # %rax = 0
    movq    $char_replacing_format, %rdi     # Setting the first arg for printf to be the wanted format.
    movzbq  (%rsp), %rsi    # Setting the second arg for printf to be the old char.
    movzbq  1(%rsp), %rdx   # Setting the third arg for printf to be the new char.
    leaq    1(%r12), %rcx   # Setting the forth arg for printf to be the first pstring's string.
    leaq    1(%r13), %r8    # Setting the fith arg for printf to be the second pstring's string.
    call    printf

    addq    $24, %rsp       # reducing this function stack frame with 16 bytes.

    jmp     .END_OF_RUN_FUNC

.INTERVAL_CPY_CASE:

    pushq   $3  #for 16 anlignment

# Setting up space in the stack for the 2 integers we'll get from the user

    subq    $16, %rsp   # Expending this function stack frame with 16 bytes.
    movq    %rsi, %r12  # Geting the adress of the first pstring into %r12, for safe keeping.
    movq    %rdx, %r13  # Geting the adress of the second pstring into %r13, for safe keeping.

# Getting the start index from the user
    leaq    (%rsp), %rsi
    movq    $get_index_from_user_format, %rdi
    xorq    %rax, %rax
    call    scanf

# Getting the end index from the user
    leaq    8(%rsp), %rsi
    movq    $get_index_from_user_format, %rdi
    xorq    %rax, %rax
    call    scanf

# saving the indexes in registers and setting up the call for pstrijcpy function.
    movq    %r12, %rdi      # Saving the adress of the first pstring as the first arg for the pstrijcpy function.
    movq    %r13, %rsi      # Saving the adress of the second pstring as the second arg for the pstrijcpy function.
    movzbq  (%rsp), %rdx    # Saving the start index in the third arg register %rdx, for the pstrijcpy function.
    movzbq  8(%rsp), %rcx   # Saving the end index in the forth arg register %rcx, for the pstrijcpy function.
    call    pstrijcpy

# Printing the wanted messege to the user for the first pstring.
    xorq    %rax, %rax  # %rax = 0
    movq    $pstring_printing_format, %rdi # Setting the wanted format as the first arg for printf.
    movzbq  (%r12), %rsi    # %rsi  = the length of the first pstring, this is the second arg for printf.
    leaq    1(%r12), %rdx   # %rdx = the adress of the start of the first pstring's string. Third arg for printf.
    call    printf

# Printing the wanted messege to the user for the second pstring.
    xorq    %rax, %rax  # %rax = 0
    movq    $pstring_printing_format, %rdi # Setting the wanted format as the first arg for printf.
    movzbq  (%r13), %rsi    # %rsi  = the length of the second pstring, this is the second arg for printf.
    leaq    1(%r13), %rdx   # %rdx = the adress of the start of the second pstring's string. Third arg for printf.
    call    printf

    addq    $16, %rsp       # reducing this function stack frame with 16 bytes.
    jmp     .END_OF_RUN_FUNC

.CASE_SWAPPING_CASE:
    movq    %rsi, %r12  # Geting the adress of the first pstring into %r12, for safe keeping.
    movq    %rdx, %r13  # Geting the adress of the second pstring into %r13, for safe keeping.

    movq    %rsi, %rdi  # Setting the adress of the first pstring as the first arg for swapCase function.
    call    swapCase

    movq    %rdx, %rdi  # Setting the adress of the first pstring as the first arg for swapCase function.
    call    swapCase

# Printing the wanted messege to the user for the first pstring.
    xorq    %rax, %rax  # %rax = 0
    movq    $pstring_printing_format, %rdi # Setting the wanted format as the first arg for printf.
    movzbq  (%r12), %rsi    # %rsi  = the length of the first pstring, this is the second arg for printf.
    leaq    1(%r12), %rdx   # %rdx = the adress of the start of the first pstring's string. Third arg for printf.
    call    printf

# Printing the wanted messege to the user for the second pstring.
    xorq    %rax, %rax  # %rax = 0
    movq    $pstring_printing_format, %rdi # Setting the wanted format as the first arg for printf.
    movzbq  (%r13), %rsi    # %rsi  = the length of the second pstring, this is the second arg for printf.
    leaq    1(%r13), %rdx   # %rdx = the adress of the start of the second pstring's string. Third arg for printf.
    call    printf

    jmp     .END_OF_RUN_FUNC

.INTERVAL_CMP_CASE:

# Setting up space in the stack for the 2 integers we'll get from the user.
    subq    $24, %rsp   # Expending this function stack frame with 24 bytes.
    movq    %rsi, %r12  # Geting the adress of the first pstring into %r12, for safe keeping.
    movq    %rdx, %r13  # Geting the adress of the second pstring into %r13, for safe keeping.

# Getting the start index from the user.
    leaq    (%rsp), %rsi
    movq    $get_index_from_user_format, %rdi
    xorq    %rax, %rax
    call    scanf

# Getting the end index from the user.
    leaq    8(%rsp), %rsi
    movq    $get_index_from_user_format, %rdi
    xorq    %rax, %rax
    call    scanf


# saving the indexes in registers and setting up the call for pstrijcpy function.
    movq    %r12, %rdi      # Saving the adress of the first pstring as the first arg for the pstrijcpy function.
    movq    %r13, %rsi      # Saving the adress of the second pstring as the second arg for the pstrijcpy function.
    movzbq  (%rsp), %rdx    # Saving the start index in the third arg register %rdx, for the pstrijcpy function.
    movzbq  8(%rsp), %rcx   # Saving the end index in the forth arg register %rcx, for the pstrijcpy function.
    call    pstrijcmp

# Printing the messege with prinf.
    movq    %rax, %rsi                          # Seting the comparison result as the second arg for printf.
    movq    $comparison_result_format, %rdi     # Setting the first arg for printf to be the wanted format.
    xorq    %rax, %rax                          # %rax = 0
    call    printf

    addq    $24, %rsp        # reducing this function stack frame with 24 bytes.
    jmp     .END_OF_RUN_FUNC    


.INVALID_CHOICE_CASE:
    xorq    %rax, %rax  # %rax = 0
    movq    $invalid_choice_msg_format, %rdi    # Setting the format as the first arg of printf.
    call    printf

.END_OF_RUN_FUNC:
    xor     %rax, %rax      # setting %rax = 0
    movq    -8(%rbp), %r12  # restoring the save register (%r12) value, for the caller function.
    movq    -16(%rbp), %r13 # restoring the save register (%r13) value, for the caller function.
    movq    -24(%rbp), %r14 # restoring the save register (%r14) value, for the caller function.
    movq	%rbp, %rsp      # restore the old stack pointer - release all used memory.
    popq	%rbp		    # restore old frame pointer (the caller function frame)
    ret			            # return to caller function (run_main).



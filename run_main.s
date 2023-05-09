
    .section    .rodata

get_string_size_from_user_format: .string "%hhd"

get_string_for_pstring_forma:   .string "%s"

test_format:    .string "the length is %d, the str is %s\n"


    .text

# Creats 2 pstrings using input from the user and a choice for the jump table then calls run_func with this info.
# Input:
#        none.
# Output:
#        0 (%rax = 0 in the end of this function)

.globl  run_main
    .type   run_main, @function
run_main:
            # Setting up the stack frame for this function

    pushq	%rbp         # Save the old frame pointer. pushing 8 bytes into the stack.
    movq	%rsp, %rbp	 # Create the new frame pointer.
    pushq   %r12         # Saving a callee save register in this function stack frame. Pushing 8 bytes into the stack.
    pushq   %r13         # Saving a callee save register in this function stack frame. Pushing 8 bytes into the stack.
    pushq   %r14         # Saving a callee save register in this function stack frame. Pushing 8 bytes into the stack.
    pushq   %rbx         # Saving a callee save register in this function stack frame. Pushing 8 bytes into the stack.

    xorq    %rbx, %rbx  # %rbx = 0

            # Seting up the stack frame for the criation of the first pstring

    subq    $16, %rsp    # Expending this function stack frame with 8 bytes.

            # Getting the second pstring size from the user

    leaq    (%rsp), %rsi
    movq    $get_string_size_from_user_format, %rdi
    xorq    %rax, %rax  # %rax = 0
    call    scanf

    xorq    %r12, %r12
    movb    (%rsp), %r12b    # %r12 = size of the first pstring.
    addq    $16, %rsp        # reducing this function stack frame with 8 bytes.

            # Seting this stack frame to store the first pstring

    #leaq    (%r12, %r12,8), %r12  # %r12 *= %r12
    movq    %r12, %rbx
    salq    $4, %r12
    subq    %r12, %rsp      # Expending function stack frame with (16 * size of first pstr) bytes, for 16 alignment.

            # Geting the string for the first pstring from the user and creating the first pstring

    movb    %bl, (%rsp)   # Setting the first byte of the first pstring to be the size of the pstring.
    leaq    1(%rsp), %rsi   # %rsi = adress of the second byte of the pstring, this will be the second arg for scanf.
    movq    $get_string_for_pstring_forma, %rdi # Seting the first arg for scanf to be the wanted format.
    call    scanf

    movq    %rsp, %r13  # %r13 = adress of the first pstring

            # Seting up the stack frame for the criation of the second pstring

    subq    $16, %rsp    # Expending this function stack frame with 8 bytes.

            # Getting the second pstring size from the user

    leaq    (%rsp), %rsi
    movq    $get_string_size_from_user_format, %rdi
    xorq    %rax, %rax  # %rax = 0
    call    scanf

    movzbq  (%rsp), %r12    # %r12 = size of the second pstring.
    addq    $16, %rsp        # reducing this function stack frame with 8 bytes.

            # Seting this stack frame to store the second pstring

    movq    %r12, %rbx
    salq    $4, %r12        # %r12 *= 16
    subq    %r12, %rsp      # Expending function stack frame with (16 * size of second pstr) bytes, for 16 alignment.

            # Geting the string for the second pstring from the user and creating the second pstring

    movb    %bl, (%rsp)   # Setting the first byte of the second pstring to be the size of the pstring.
    leaq    1(%rsp), %rsi   # %rsi = adress of the second byte of the pstring, this will be the second arg for scanf.
    movq    $get_string_for_pstring_forma, %rdi # Seting the first arg for scanf to be the wanted format.
    call    scanf

    movq    %rsp, %r14  # %r14 = adress of the second pstring

            # Getting the option choice from the user

            # Seting up the stack frame for storing the choice of the user

    subq    $16, %rsp    # Expending this function stack frame with 8 bytes.

            # Getting the the choice from the user

    leaq    (%rsp), %rsi
    movq    $get_string_size_from_user_format, %rdi # Setting the first arg for scanf to be a format that gets an int.
    xorq    %rax, %rax  # %rax = 0
    call    scanf

    movzbq  (%rsp), %r12    # %r12 = user's choice.
    addq    $16, %rsp        # reducing this function stack frame with 8 bytes.

            # Seting args for run_func

    movq    %r12, %rdi  # Setting the first arg to be the user's choice.
    movq    %r13, %rsi  # Setting the second arg to be the adress of the first pstring.
    movq    %r14, %rdx  # Setting the third arg to be the adress of the second pstring.
    call    run_func

            # End of run_main function

    xor     %rax, %rax      # setting %rax = 0
    movq    -8(%rbp), %r12  # restoring the save register (%r12) value, for the caller function.
    movq    -16(%rbp), %r13 # restoring the save register (%r13) value, for the caller function.
    movq    -24(%rbp), %r14 # restoring the save register (%r14) value, for the caller function.
    movq    -32(%rbp), %rbx # restoring the save register (%rbx) value, for the caller function.
    movq	%rbp, %rsp      # restore the old stack pointer - release all used memory.
    popq	%rbp		    # restore old frame pointer (the caller function frame)
    ret			            # return to caller function (run_main).



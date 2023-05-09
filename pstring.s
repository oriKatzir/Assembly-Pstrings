

    .section    .rodata     # Read only data section.
invalid_input_msg:  .string "invalid input!\n"


    .text   # the beginnig of the code.

# Gets an adress of a pstring struct and returns its length.
# Input:
#        an adress of a pstring structs (stored in %rdi).
# Output:
#        the length of the pstring (the length is stored in %rax).

.globl pstrlen
    .type   pstrlen, @function
pstrlen:
    pushq	%rbp        # save the old frame base pointer.
    movq	%rsp, %rbp	# create the new frame pointer.
    movb    (%rdi), %al    # gets the length of the pstring into %rax (%rax = length of th pstring).
    movzbq  %al, %rax
    popq    %rbp            # gets the old frame base adress into %rbp
    ret

# Replaces all the appearances of the old char with the new char.
# Input:
#        an adress of a pstring structs (stored in %rdi).
#        the old char, that we wants to replace all of it's appearances (stored in %sil, rightmost byte of %rsi).
#        the new char, that we wants to replace with (stored in %dl, rightmost byte of %rdx).
# Output:
#        The adress of the given pstring struct (stored in %rax).

.globl replaceChar
    .type   replaceChar, @function
replaceChar:
# Seting up the function frame.
    pushq	%rbp        # save the old frame base pointer, pushed 8 byets into the stack.
    movq	%rsp, %rbp	# create the new frame pointer.
    pushq   %r12        # Saving the callee save rgister (%r12), pushed 8 byets into the stack.
    pushq   %r13        # Saving the callee save rgister (%r13), pushed 8 byets into the stack.

    xorq    %r13, %r13       # %r13 = 0
    movq    %rdi, %rax       # Saving the adress of the pstring in %rax as the return value of this function.
    leaq    1(%rdi),%r12     # Saving the adress of the first char in the pstring in %r12.
    movzbq    (%r12), %r13   # Saving the asci value of the first byte in the pstring in %r13.

.test_if_curent_char_is_not_null:
    cmpq    $0, %r13     # Checking if the current char is '\0', i.e if we're at the end of the pstring.
    je      .end_of_replaceChar_function

    cmpq    %r13, %rsi     # Checking if the current char in the pstring is equal to the old char.
    je      .is_the_old_char

.is_not_the_old_char:
    leaq    1(%r12), %r12   # Moving %r12b for it to point to the next char in the pstring.
    movzbq  (%r12), %r13    # Saving the asci value of the current char in the pstring in the rightmost byte of %r13.
    jmp     .test_if_curent_char_is_not_null

.is_the_old_char:
    movb    %dl, (%r12)              # Setting the current char to be the given new char instead of the old char.
    jmp     .is_not_the_old_char    # So that i dont repeat the same code twice.

.end_of_replaceChar_function:
    movq    -8(%rbp), %r12     # Returning the original data into the callee saved register.
    movq    -16(%rbp), %r13    # Returning the original data into the callee saved register.
    movq	%rbp, %rsp	       # Restore the old stack pointer - release all used memory.
    popq	%rbp		       # Restore old frame pointer (the caller function frame).
    ret			               # Return to caller function (run_func).


# Copies a sub string from a given src pstring into a dst given pstring.
# The length of the dst pstring will not be changed.
# Input
#        an adress of a dst pstring struct (stored in %rdi).
#        an adress of a src pstring struct (stored in %rsi).
#        i, the index of the start of the sub string (stored in %rdx).
#        j, the index of the end of the sub string (stored in %rcx).
# Output
#        The adress of the dst pstring struct (stored in %rax).

.globl pstrijcpy
    .type   pstrijcpy, @function
pstrijcpy:
# Seting up the function frame.
    pushq	%rbp        # save the old frame base pointer, pushed 8 byets into the stack.
    movq	%rsp, %rbp	# create the new frame pointer.
    pushq   %r12        # Saving the callee save rgister (%r12), pushed 8 byets into the stack.
    pushq   %r13        # Saving the callee save rgister (%r13), pushed 8 byets into the stack.
    pushq   $2          # Pushing 8 byetes into the stack to align it to dubles of 16.

    movzbq  %dl, %rdx
    movzbq  %cl, %rcx
    movq    %rdi, %r13  # Saving the adress of the dst pstring struct for later use.

# Checking if the indexes values are valid.

    # Checking if i > j
    cmpq    %rdx, %rcx
    js      .invalid_input

    # Cecking if i < 0
    xorq    %r12, %r12
    cmpq    %r12, %rdx
    jl      .invalid_input

    # Cecking if j < 0
    cmpq    %r12, %rcx
    jl      .invalid_input


# Dst pstring.
    movzbq  (%rdi), %r12   # Saving the value of the first byte of dst pstring (%r12b = the length of dst pstring).
    cmpq    %r12, %rcx      # Comparing the length of the dst pstring and the end index
    jae      .invalid_input  # If the end index is biger then the length of the dst pstring then this is invalid input.

# Src pstring.
    movzbq    (%rsi), %r12   # Saving the value of the first byte of src pstring (%r12b = the length of src pstring).
    cmpq    %r12, %rcx      # Comparing the length of the src pstring and the end index
    jae      .invalid_input  # If the end index is biger then the length of the src pstring then this is invalid input.

# Setting up the while loop.
    movq    %rdx, %rax               # %rax = i
    leaq    1(%rdi, %rdx, 1), %rdi   # Moving up %rdi to point on the i char of the dst pstring
    leaq    1(%rsi, %rdx, 1), %rsi   # Moving up %rsi to point on the i char of the src pstring

.while_inside_interval:
    cmpq    %rcx, %rax      # Comaring the counter (%rax) and the end index
    jnbe    .end_of_pstrijcpy_function  # checking if the counter is inside [i,j].
    movb    (%rsi), %r12b   # Copies the asci value of the current char in src pstring into the rightmost byte of %r12.
    movb    %r12b, (%rdi)   # Setting the current char in the dest pstring to the current char in src pstring.
    leaq    1(%rdi), %rdi   # Moving up %rdi to point on the next char of the dst pstring
    leaq    1(%rsi), %rsi   # Moving up %rsi to point on the next char of the src pstring
    incq    %rax            # Counter += 1
    jmp     .while_inside_interval


.invalid_input:
    xorq    %rax, %rax                  # %rax = 0
    movq    $invalid_input_msg, %rdi    # Seting the string format as the second arg for printf.
    pushq   $2                          # For 16 anlingment.
    call    printf
    popq    %r12
# Remember the values we had in %rax, %rcx and %rdx are lost after returning from printf.


.end_of_pstrijcpy_function:
    movq    %r13, %rax         # Setting up the adress of the dst pstring struct as the return value.
    movq    -8(%rbp), %r12     # Returning the original data into the callee saved register.
    movq    -16(%rbp), %r13    # Returning the original data into the callee saved register.
    movq	%rbp, %rsp	       # Restore the old stack pointer - release all used memory.
    popq	%rbp		       # Restore old frame pointer (the caller function frame).
    ret			               # Return to caller function (run_func).




# switching the cases of the leters in a given pstring.
# Input
#        an adress of a dst pstring struct (stored in %rdi).
# Output
#        The adress of the given pstring struct (stored in %rax).

.globl swapCase
    .type   swapCase, @function
swapCase:

# Seting up the function frame.
    pushq	%rbp        # save the old frame base pointer, pushed 8 byets into the stack.
    movq	%rsp, %rbp	# create the new frame pointer.
    pushq   %r12        # Saving the callee save rgister (%r12), pushed 8 byets into the stack.

    movq    %rdi, %rax  # Saving the adress of the given pstring stract as a return value.

    leaq    1(%rdi), %rdi   # Moving %rdi to point to the first char in the pstring.
    movzbq  (%rdi), %r12    # %r12 = the asci value of the first char in the pstring.

.loop:
    cmpq    $0, %r12    # Compar 0 to the current char to see if it is '\0', if it is then we done.
    je      .end_of_swapCase_function

    cmpq    $65, %r12       # Comparing the  char to see if it's value is lower then an upper case letter.
    jnae    .continue_to_the_next_iteration
    cmpq    $90, %r12       # Compare the char to the value of the bigest possible asci value of an upper case letter.
    jbe     .is_upper_case_letter
    cmpq    $97, %r12       # Compare the char to the value of the lowest possible asci value of an lower case letter.
    jnae    .continue_to_the_next_iteration
    cmpq    $122, %r12
    jbe     .is_lower_case_letter
    jmp     .continue_to_the_next_iteration # Just incase.. this is a test dont forgatto delete


.is_lower_case_letter:
# To convert an lower case letter to an upper case letter you need to subtract 32 from its asci value.
    subq    $32, %r12
    movb    %r12b, (%rdi)
    jmp     .continue_to_the_next_iteration

.is_upper_case_letter:
# To convert an upper case letter to an lower case letter you need to add 32 to its asci value.
    addq    $32, %r12
    movb    %r12b, (%rdi)
    jmp     .continue_to_the_next_iteration

.continue_to_the_next_iteration:
    leaq    1(%rdi), %rdi   # Moving %rdi to point to the next char in the pstring.
    movzbq  (%rdi), %r12    # %r12 = the asci value of the next char in the pstring.
    jmp .loop

.end_of_swapCase_function:
    movq    -8(%rbp), %r12     # Returning the original data into the callee saved register.
    movq	%rbp, %rsp	       # Restore the old stack pointer - release all used memory.
    popq	%rbp		       # Restore old frame pointer (the caller function frame).
    ret


 # switching the cases of the leters in a given pstring.
 # Input:
 #        an adress of pstr1, a compared pstring struct (stored in %rdi).
 #        an adress of pstr2, a compare_to pstring struct (stored in %rsi).
 #        i, the index of the start of the sub string interval (stored in %rdx).
 #        j, the index of the end of the sub string interval (stored in %rcx).
 # Output:
 #        an integer, based on lexicographic order:
 #               1 if  pstr1->str[i:j] > pstr2->str[i:j]
 #               -1 if  pstr1->str[i:j] < pstr2->str[i:j]
 #               0 if  pstr1->str[i:j] = pstr2->str[i:j]

.globl pstrijcmp
    .type   pstrijcmp, @function
pstrijcmp:
# Seting up the function frame.
    pushq   %rbp        # save the old frame base pointer, pushed 8 byets into the stack.
    movq    %rsp, %rbp	# create the new frame pointer.
    pushq   %r12        # Saving the callee save rgister (%r12), pushed 8 byets into the stack.
    pushq   %r13        # Saving the callee save rgister (%r13), pushed 8 byets into the stack.
    pushq   %r14        # Saving the callee save rgister (%r13), pushed 8 byets into the stack.

# Checking if the indexes values are valid.

    # Checking if i > j

    cmpq    %rdx, %rcx
    js      .j_is_out_of_bound

    xorq    %r12, %r12  # %r12 = 0

    # Cecking if i < 0
    cmpq    %r12, %rdx
    jl      .j_is_out_of_bound

    # Cecking if j < 0
    cmpq    %r12, %rcx
    jl      .j_is_out_of_bound

# Dst pstring.
    movzbq  (%rdi), %r12        # Saving the value of the first byte of pstr1 (%r12b = the length of pstr1).
    cmpq    %r12, %rcx          # Comparing the length of the pstr1 and the end index j.
    jae      .j_is_out_of_bound  # If the end index, j, is biger then the length of pstr1 then this is invalid input.

# Src pstring.
    movzbq  (%rsi), %r12        # Saving the value of the first byte of pstr2 (%r12b = the length of pstr2).
    cmpq    %r12, %rcx          # Comparing the length of pstr2 and the end index, j.
    jae      .j_is_out_of_bound  # If the end index, j, is biger then the length of pstr2 then this is invalid input.

# Setting up the comparing logic.

    xorq    %r12, %r12  # %r12 = 0, %r12 will store the asci value of the current char in pstr1 in each iteration.
    xorq    %r13, %r13  # %r13 = 0, %r13 will store the asci value of the current char in pstr2 in each iteration.

    movq    %rdx, %rax               # %rax = i, %rax will serve as a counter.
    leaq    1(%rdi, %rdx, 1), %rdi   # Moving up %rdi to point on the i char of the dst pstring.
    leaq    1(%rsi, %rdx, 1), %rsi   # Moving up %rsi to point on the i char of the src pstring.

.while_between_i_and_j:
    cmpq    %rcx, %rax                  # Comaring the counter (%rax) and the end index.
    jnbe    .pstr1_is_equal_to_pstr2    # checking if the counter is inside [i,j].

    movzbq  (%rdi), %r12    # %r12 = asci value of the current char in pstr1.
    movzbq  (%rsi), %r13    # %r14 = asci value of the current char in pstr2.

    cmpq    %r13, %r12          # comparing the current char in pstr1 and the curent char in pstr2
    ja      .pstr1_is_bigger    # If %r12 > %r13 then go to .pstr1_is_bigger label.
    jb      .pstr2_is_bigger    # If %r12 < %r13 then go to .pstr2_is_bigger label.

    leaq    1(%rdi), %rdi       # Moving up %rdi to point on the next char of pstr1.
    leaq    1(%rsi), %rsi       # Moving up %rsi to point on the next char of pstr2.
    incq    %rax                # counter += 1
    jmp     .while_between_i_and_j

.pstr1_is_bigger:
    movq    $1, %rax    # Setting up the return value to be 1.
    jmp     .end_of_pstrijcmp_function

.pstr2_is_bigger:
    movq    $-1, %rax   # Setting up the return value to be -1.
    jmp     .end_of_pstrijcmp_function

.pstr1_is_equal_to_pstr2:
    xorq    %rax, %rax   # Setting up the return value to be 0.
    jmp     .end_of_pstrijcmp_function

.j_is_out_of_bound:
    xorq    %rax, %rax                  # %rax = 0
    movq    $invalid_input_msg, %rdi    # Seting the string format as the second arg for printf.
    pushq   $2                          # For 16 anlingment
    call    printf
    popq    %r12
    movq    $-2, %rax

.end_of_pstrijcmp_function:
    movq    -8(%rbp), %r12     # Returning the original data into the callee saved register.
    movq    -16(%rbp), %r13    # Returning the original data into the callee saved register.
    movq    -24(%rbp), %r13    # Returning the original data into the callee saved register.
    movq    %rbp, %rsp	       # Restore the old stack pointer - release all used memory.
    popq	%rbp		       # Restore old frame pointer (the caller function frame).
    ret



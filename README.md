# Assembly-Pstrings

This GitHub repository is for the third assignment given in the Computer architecture course at Bar Ilan University.

## Description

The purpose of this project is to practice more advanced assembly concepts by working with pstrings manipulations and information.<br>
A `pstring` is a struct that contains a string and its length.<br>

<img width="128" alt="pString" src="https://user-images.githubusercontent.com/106544582/237052162-d119d38e-9f83-4062-b21c-4e36917b27ed.png">

Which will be stored in the memory as follow:

<img width="127" alt="pStringMem" src="https://user-images.githubusercontent.com/106544582/237052461-69eadeb1-7127-4718-9a3e-0bc203e5589d.png">

### The program consists of four files:
- `main.c`: Main C file that calls `run_main()` function.
- `run_main.s`: Assembly file in charge of receiving two `pstrings` and a choice.
- `func_select.s`: Assembly file in charge of the control flow of the program, executing the user request by the selected choice.
- `pstring.s`: Assembly file that is a `pstring` library used for `func_select.s` to perform operations on `pstrings`.

`func_select.s` is a switch case that receives five cases:

- Case 31: Prints the two `pstrings` length.
- Case 32: Asks the user for two chars - old char and new char, replaces them in both `pstrings`, and prints the result.
- Case 35: Asks the user for two numbers (i and j), copies from the second `pstring` the [i:j] chars to the first `pstring`, and prints the result.
- Case 36: Replaces all upper case letters with lower case letters and lower case letters with upper case letters.
- Case 37: Asks the user for two numbers (i and j) and implements `pstrijcmp` on the first and second `pstrings`. If `pstring1[i:j]` is larger lexicography than `pstring2[i:j]`, prints 1. If they are equal, prints 0. Otherwise, prints -1.

If any other choice of case is made, the program will print "invalid option!"

## Functions

The pstring library contains the following functions:

- `char pstrlen(Pstring* pstr)`: Returns the length of a pstring.
- `Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)`: Replaces all instances of `oldChar` with `newChar` in the given pstring.
- `Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)`: Copies the substring of `src` from `i` to `j` into `dst`.
- `Pstring* swapCase(Pstring* pstr)`: Swaps the cases of all letters in the given pstring.
- `int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)`: Compares the substrings of `pstr1` and `pstr2` from `i` to `j` lexicographically.

## Installation and Execution

To clone and run this application, you'll need Git and the GCC compiler. From your command line:

1. Clone this repository:

```bash
$ git clone https://github.com/oriKatzir/Assembly-Pstrings.git
```

2. Navigate to the cloned directory:

```bash
$ cd Assembly-Pstrings
```

3. Compile the program using the provided `Makefile`:

```bash
$ make
```

4. Run the program:

```bash
$ ./a.out
```

## Makefile

The `Makefile` provided in this repository specifies the build rules for compiling the program. To compile the program using the `Makefile`, simply run the command:

```bash
$ make
```

The `make` command will compile all necessary files and generate the `a.out` executable file.

To clean up the build artifacts (e.g., object files), you can run:

```bash
$ make clean
```

This will remove all `.o` files and the `a.out` executable.

## Author

This project was created by Ori Katzir.

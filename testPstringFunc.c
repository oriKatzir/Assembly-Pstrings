//was created by Evyatar Altman 24/12/22
//if you compile using the terminal, use "gcc pstring.s pstring.h testPstringFunc.c -o testing -no-pie"
// and run ./testing
#include "pstring.h"
#include "assert.h"
#include <stdio.h>
#include <string.h>

void testPstrlen(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"bbbbbb"};
    //get the len of p1
    assert(pstrlen(&p1) == 5);
    //get the len of p2
    assert(pstrlen(&p2) == 6);
    printf("Success pstrlen (1/5)\n");
}

void testReplaceChar(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"bbbbbb"};
    Pstring p3 = {6,"bcbcbc"};
    Pstring p4 = {0,""};
    //replace all a in b in p1
    assert(strcmp(replaceChar(&p1,'a','b')->str,"bbbbb") == 0);
    //replace all a to b in p2, nothing needs to changing
    assert(strcmp(replaceChar(&p2,'a','b')->str,"bbbbbb") == 0);
    //replace all b to @ in p2
    assert(strcmp(replaceChar(&p2,'b','@')->str,"@@@@@@") == 0);
    //replace all c to a in p3
    assert(strcmp(replaceChar(&p3,'c','a')->str,"bababa") == 0);
    //return every a to c
    assert(strcmp(replaceChar(&p3,'a','c')->str,"bcbcbc") == 0);
    //replace all b to r in p3
    assert(strcmp(replaceChar(&p3,'b','r')->str,"rcrcrc") == 0);
    //test empty string
    assert(strcmp(replaceChar(&p4,'b','r')->str,"") == 0);
    printf("Success replaceChar (2/5)\n");
}

void testPstrijcpy(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"bbbbbb"};
    Pstring p3 = {10,"0123456789"};
    Pstring p4 = {10,"0000000000"};
    //test the same string on itself
    assert(strcmp(pstrijcpy(&p1,&p1,0,4)->str,"aaaaa") == 0);
    //test when i==j
    assert(strcmp(pstrijcpy(&p1,&p2,0,0)->str,"baaaa") == 0);
    assert(strcmp(pstrijcpy(&p1,&p2,0,3)->str,"bbbba") == 0);
    //test i and j out of bound, doesn't change anything and prints "invalid massage"
    assert(strcmp(pstrijcpy(&p1,&p2,11,13)->str,"bbbba") == 0);
    //test i and j out of bound of dst, doesn't change anything and prints "invalid massage"
    assert(strcmp(pstrijcpy(&p1,&p2,5,5)->str,"bbbba") == 0);
    //test i and j out of bound of src, doesn't change anything and prints "invalid massage"
    assert(strcmp(pstrijcpy(&p2,&p1,5,5)->str,"bbbbbb") == 0);
    //test j out of bound of dst, doesn't change anything and prints "invalid massage"
    assert(strcmp(pstrijcpy(&p1,&p2,4,6)->str,"bbbba") == 0);
    //test j out of bound of src, doesn't change anything and prints "invalid massage"
    assert(strcmp(pstrijcpy(&p2,&p1,4,6)->str,"bbbbbb") == 0);
    assert(strcmp(pstrijcpy(&p4,&p3,6,8)->str,"0000006780") == 0);
    //test src shorter than dst
    assert(strcmp(pstrijcpy(&p3,&p1,0,2)->str,"bbb3456789") == 0);
    //optional, when i > j
    //assert(strcmp(pstrijcpy(&p1,&p1,4,0)->str,"aaaaa") == 0);
    printf("Success pstrijcpy (3/5)\n");
}


void testSwapCase(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"BBBBBB"};
    Pstring p3 = {10,"0123456789"};
    Pstring p4 = {8,"1A2b3C4d"};
    Pstring p5 = {0,""};
    //upper p1
    assert(strcmp(swapCase(&p1)->str,"AAAAA") == 0);
    //lowwer p2
    assert(strcmp(swapCase(&p2)->str,"bbbbbb") == 0);
    //do nothing to p3
    assert(strcmp(swapCase(&p3)->str,"0123456789") == 0);
    //deal only with alpha beit characters in p4
    assert(strcmp(swapCase(&p4)->str,"1a2B3c4D") == 0);
    //test empty string, doesn't change anything
    assert(strcmp(swapCase(&p5)->str,"") == 0);
    printf("Success swapCase (4/5)\n");
}

void testPstrijcmp(){
    Pstring p1 = {5,"aaaaa"};
    Pstring p2 = {6,"bbbbbb"};
    Pstring p3 = {10,"0123456789"};
    Pstring p4 = {9,"102340078"};
    //test i==j, pstr1[i] < pstr2[i]
    assert(pstrijcmp(&p1,&p2,0,0) == -1);
    //test i==j, pstr1[i] > pstr2[i]
    assert(pstrijcmp(&p2,&p1,0,0) == 1);
    //test pstr1[i] > pstr2[i]
    assert(pstrijcmp(&p1,&p2,0,3) == -1);
    //test i and j out of bounds
    assert(pstrijcmp(&p1,&p2,11,13) == -2);
    //test i and j out of bounds of pstr1
    assert(pstrijcmp(&p1,&p2,5,5) == -2);
    //test i and j out of bounds of pstr2
    assert(pstrijcmp(&p2,&p1,5,5) == -2);
    assert(pstrijcmp(&p4,&p3,6,8) == -1);
    //test pstr1 shorter
    assert(pstrijcmp(&p1,&p3,0,2) == 1);
    //test pstr2 shorter
    assert(pstrijcmp(&p3,&p1,0,2) == -1);
    assert(pstrijcmp(&p4,&p3,0,2) == 1);
    //test the same pstring on itself
    assert(pstrijcmp(&p1,&p1,2,4) == 0);
    //test pstr1[i:j] == pstr2[i:j]
    assert(pstrijcmp(&p4,&p3,2,4) == 0);
    //optional, when i > j
    //assert(pstrijcmp(&p1,&p2,3,0) == -2);
    printf("Success pstrijcmp (5/5)\n");
}





int main(){
    testPstrlen();
    testReplaceChar();
    testPstrijcpy();
    testSwapCase();
    testPstrijcmp();
    return 0;
}

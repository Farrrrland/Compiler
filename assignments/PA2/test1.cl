(* 
 * Test by Farland, 2021.10.23
 * Based on Handout 2
 * Chapter 4.1
 *)

class Test01 {
    
    -- Testing 4.1 Invalid Character
    $$$$ : String;
    -- Testing 4.1 string too long
    tooLongStr : String <- "This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size\
                            This is a bad example with too long size";

    -- Testing 4.1 Unescaped Newline
    newLine : String;
    newLine <- "This is \
                a good example";
    newLine <- "This is a bad example with unescaped newline

    -- Testing 4.1 Unreached *)
    (* This is a good comment with only one terminater *)
    (* This is a bad comment but with double terminater followed *) *)

    -- Testing 4.1 EOF error
    (* This is a bad comment continues till EOF occurs
};
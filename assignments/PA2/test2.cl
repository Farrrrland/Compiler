(* 
 * Test by Farland, 2021.10.23
 * Based on Handout 
 * Chapter 4.1
 *)

class Test02 {

    --Testing escape characters
    escpStr : String <- "ab\ncd"

    -- Testing \0
    zeroStr : String;
    zeroStr <- "123\0"
    zeroStr <- ZeroStr.concat("123\\0");
    zeroStr <- ZeroStr.concat("123\\\0");
    zeroStr <- ZeroStr.concat("123\\\\0");

 };
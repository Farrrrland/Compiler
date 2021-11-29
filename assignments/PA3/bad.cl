
(*
 *  execute "coolc bad.cl" to see the error messages that the coolc parser
 *  generates
 *
 *  execute "myparser bad.cl" to see the error messages that your parser
 *  generates
 *)

(* no error *)
class A {
};

(* error:  b is not a type identifier *)
Class b inherits A {
};

(* error:  a is not a type identifier *)
Class C inherits a {
};

(* error:  keyword inherits is misspelled *)
Class D inherts A {
};

(* error:  closing brace is missing *)
Class E inherits A {
;

class F {
    a : Int;
    b : bool;
};

class G {
    -- good
    a : Int;
    b : String <- "goodgood";

    -- bad
    c : Int <- 1 ** 2;
    d : Int < 1;
    E : String <- "badbad";

    -- good
    f3(x : Int) : Int {
        2 * x
    };

    -- bad

    f2() : Int {
        1 ** 4
    };

    F1() : Int{

    };
};

class H {
    test(x : Int) : Bool {
        {
            -- bad
            x <- 1 -+ 1;
            while x +-1 loop t pool;
            (x x);
            1 << 1;
        }
    };
};

class I {
    z : Int <- 1;

    test() : Bool {
        {
            -- good
            let x : Int <- 1, y : Int <- 2 in {
                z <- x + y;
            };
            let x : Int <- 1 in 1;
            
            -- bad
            let x in 1;
            let in 1;
            let x, y : Int, z in 1;
            let x : Int < 1 in 1;
            let x : Int <- 1 ** 1, y : Int <- 1 -+ 1 in 1;
        }
    };
};
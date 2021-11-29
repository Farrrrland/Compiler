(*
 * This is a good test
 *)

class Main inherits IO {
    newline() : Object {
     out_string("\n")
    };
 
    prompt() : String {
     {
        out_string("Input something:");
        in_string();
     }
    };
 
    main() : Object {
      (let z : Z <- new Z in
    -- while loop
     while true loop  
        -- let
        (let s : String <- prompt() in
        -- if else
         if s = "stop" then 
             abort()
         else
            (let i : Int <- z.val(s) in
             (let str : String <- z.str(i) in
                {
                  out_int(i);
                  newline();
                  out_string(str);
                  newline();
                }
                     )
                   )
         fi
        )
         pool
      )
    };
 };


Class Book inherits IO {
    name : String;
    author : String;

    initBook (book_name : String, book_author : String) : Book {
        {
            name <- book_name;
            author <- book_author;
            self;
        }
    };

    print() : Book {
        {
            out_string("name:      ").out_string(name).out_string("\n");
            out_string("author:     ").out_string(author).out_string("\n");
            self;
        }
    };
};

-- inherits
Class Article inherits Book {
    per_title : String;

    initArticle(article_name : String, article_author : String,
		article_per_title : String) : Article {
        {
            initBook(article_name, article_author);
            per_title <- article_per_title;
            self;
        }
    };

    print() : Book {
        {
            -- dispatch
	          self@Book.print();
            out_string("periodical:  ").out_string(per_title).out_string("\n");
            self;
        }
    };
};

Class Main {
  books : BookList;
  main() : Object {
  -- let, new, dispatch
  (let a : Article <- new Article.initArticle("name", "author", "perTitle") in
    {
      -- case
      case a of
        id : Book => out_string("a book\n");
        id : Article => out_string("an article\n");
      esac;
    })
  };
};

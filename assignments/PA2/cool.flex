/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don''t remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
bool is_commented = false;
int comment_count = 0;
int str_count = 0;

%}
%option noyywrap
/*
 * Define names for regular expressions here.
 */

%x COMMENT
%x str
%x str_e

DARROW          =>
ASSIGN          <-

DIGIT 		[0-9]
INTEGER		[0-9]+

TYPEID		[A-Z]([A-Za-z_0-9])*
OBJECTID	[a-z]([A-Za-z_0-9])*

QUOTE		   \"

/* COMMENTS */
OPEN_COMMENT	\(\*
CLOSE_COMMENT	\*\)
LINE_COMMENT	--.*

/* WHITESPACE */
WHITESPACE	[ \f\t\v\r\n]
NEWLINE		\n

/* KEYWORDS */
CLASS           (?i:class)
ELSE		        (?i:else)
FI		          (?i:fi)
IF		          (?i:if)
IN		          (?i:in)
INHERITS	      (?i:inherits)
ISVOID		      (?i:isvoid)
LET		          (?i:let)
LOOP		        (?i:loop)
POOL		        (?i:pool)
THEN		        (?i:then)
WHILE		        (?i:while)
CASE		        (?i:case)
ESAC		        (?i:esac)
NEW		          (?i:new)
OF		          (?i:of)
NOT	          	(?i:not)
TRUE	        	t(?i:rue)
FALSE	        	f(?i:alse)



%%
<INITIAL,COMMENT>{NEWLINE}		{ curr_lineno++; }

<INITIAL,COMMENT>{OPEN_COMMENT}		{ comment_count++; is_commented = true; BEGIN(COMMENT); }
<INITIAL>{CLOSE_COMMENT} { cool_yylval.error_msg = "Unmatched *)"; return (ERROR); }
<COMMENT>{CLOSE_COMMENT}		{ 
			if (comment_count > 0) {
			 comment_count--;
			}
		        if (comment_count == 0) {
			 BEGIN(INITIAL);
			 is_commented = false; 
			}
			}		 
<COMMENT>. 	{ }
<COMMENT><<EOF>> 	{ cool_yylval.error_msg = "EOF in comment."; BEGIN(INITIAL); return (ERROR); }

 /*
  *  Nested comments
  */


 /*
  *  The multiple-character operators.
  */


"{"         { return ('{'); }
"}"         { return ('}'); }
"("         { return ('('); }
")"         { return (')'); }
"-"         { return ('-'); }
":"         { return (':'); }
";"         { return (';'); }
"."         { return ('.'); }
"="         { return ('='); }
"+"         { return ('+'); }
"<"         { return ('<'); }
","         { return (','); }
"@"         { return ('@'); }
"~"         { return ('~'); }

{DARROW}		{ return (DARROW); }
{ASSIGN}		{ return (ASSIGN); }
"<="		    { return (LE); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
{CLASS}			{ return (CLASS); }
{IF}			  { return (IF); }
{FI}			  { return (FI); }
{CASE}			{ return (CASE); }
{ESAC}			{ return (ESAC); }
{WHILE}			{ return (WHILE); }
{LOOP}			{ return (LOOP); }
{POOL}			{ return (POOL); }
{IN}			  { return (IN); }
{ISVOID}		{ return (ISVOID); }
{LET}			  { return (LET); }
{NOT}			  { return (NOT); }
{NEW}			  { return (NEW); }
{OF}			  { return (OF); }
{INHERITS}	{ return (INHERITS); }
{THEN}			{ return (THEN); }
{ELSE}			{ return (ELSE); }
{TRUE}			{ cool_yylval.boolean = true; return (BOOL_CONST); }
{FALSE}			{ cool_yylval.boolean = false; return (BOOL_CONST); }

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

<INITIAL>{QUOTE}	{ BEGIN(str); string_buf[0] = '\0'; string_buf_ptr = string_buf; }
<str>{QUOTE} { *string_buf_ptr = '\0';  cool_yylval.symbol = new StringEntry(string_buf, string_buf_ptr - string_buf, str_count++); BEGIN(INITIAL); return (STR_CONST); }
<str>\\\\    { if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1) 
                    { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); } 
                *string_buf_ptr = '\\'; 
                string_buf_ptr++; } 
<str>\\t     { if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1)
                    { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); } 
                *string_buf_ptr = '\t';
                string_buf_ptr++; } 
<str>\\b     { if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1)
                    { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); } 
                *string_buf_ptr = '\b';
                string_buf_ptr++; } 
<str>\\f     { if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1)
                    { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); } 
                *string_buf_ptr = '\f';
                string_buf_ptr++; } 
<str>\\n     { if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1)
                    { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); }
                *string_buf_ptr = '\n'; 
                string_buf_ptr++; } 
<str>\\[^tfbn]  { if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1)
                      { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); }
                  if(yytext[1] == '\0') { cool_yylval.error_msg = "String contains null character."; *string_buf_ptr = '\0'; BEGIN(str_e); return (ERROR); } 
                  *string_buf_ptr = yytext[1];
                  string_buf_ptr++; } 
<str>.       {if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1)
                  { cool_yylval.error_msg = "String constant is too long."; BEGIN(str_e); return (ERROR); }
              if(yytext[0] == '\0') { cool_yylval.error_msg = "String contains null character."; *string_buf_ptr = '\0'; BEGIN(str_e); return (ERROR); }
              *string_buf_ptr = yytext[0]; 
              string_buf_ptr++; } 
<str>{NEWLINE}   { curr_lineno++; BEGIN(INITIAL); *string_buf_ptr = '\0'; cool_yylval.error_msg = "Unterminated string constant."; return (ERROR); }
<str>\\\n    { curr_lineno++; *string_buf_ptr = '\n'; string_buf_ptr++; }
<str><<EOF>> { cool_yylval.error_msg = "EOF in string constant."; BEGIN(INITIAL); return (ERROR); }
<str_e>{NEWLINE}  { BEGIN(INITIAL); }
<str_e>{QUOTE}    { BEGIN(INITIAL); }
<str_e>. {}


{INTEGER}		{ cool_yylval.symbol = new IntEntry(yytext, MAX_STR_CONST, str_count++); return (INT_CONST); }
{TYPEID}		{ cool_yylval.symbol = new StringEntry(yytext, MAX_STR_CONST, str_count++); return (TYPEID); }
{OBJECTID}		{ cool_yylval.symbol = new StringEntry(yytext, MAX_STR_CONST, str_count++); return (OBJECTID); }
<INITIAL>{WHITESPACE} 		{ }
.		{ cool_yylval.error_msg = yytext; return (ERROR); }



%%

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "string_utils.h"
#include "vartable.h"
int yylex(void);
int yyparse();

//int yydebug = 1;

void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
	return 1;
} 
  
int main(int argc, char **argv)
{
    yyparse();
	return 0;
} 

%}

%union {
    int boolVal;
    double numberVal;
    char *strVal;
};

%token <strVal> IDENTIFIER
%token AND_OP OR_OP EQ_OP NE_OP IF ELSE ENDIF LE_OP GE_OP
%token ASK
%token <numberVal> CONSTANT
%token <strVal> STRING_LITERAL
%token TEXT

%type <strVal> text TEXT
%type <numberVal> additive_expression multiplicative_expression
%type <boolVal> conditional_expression logical_or_expression logical_and_expression
%type <boolVal> equality_expression relational_expression

%%

translation_unit
    : translation_unit code_or_text
    | /* NULL */
    ;
    
text: text TEXT
    {
        $$ = strdup2($1, $2);
        
        // Free previously allocated strings
        if ($1 != $2) {
            free($1);
            free($2);
        } else {
            free($1);
        }
    }
    | { $$ = NULL; }
    ;
    
code_or_text
    : statement
    | text
    ;
    
statement
    : if_statement
    | ask_statement
    ;
    
if_statement
    : if_expr text endif_expr
    {
        printf("text in if:\n%s\n", $2);
    }
    | if_expr text else_expr text endif_expr
    {
        printf("text in if:\n%s\ntext in else:\n%s\n", $2, $4);
    }
    ;
    
ask_statement
    : '[' ASK STRING_LITERAL IDENTIFIER ']'
    {
        printf("ask text: %s\nask identifier: %s\n", $3, $4);
    }
    ;

if_expr
    : '[' IF conditional_expression ']';
    
else_expr
    : '[' ELSE ']';
    
endif_expr
    : '[' ENDIF ']';

conditional_expression
    : CONSTANT
    | IDENTIFIER
    | STRING_LITERAL
    | logical_or_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR_OP logical_and_expression
    ;

logical_and_expression
    : equality_expression
    | logical_and_expression AND_OP equality_expression
    ;

equality_expression
    : relational_expression
    | equality_expression EQ_OP relational_expression
    | equality_expression NE_OP relational_expression
    ;

relational_expression
    : additive_expression
    | relational_expression '<' additive_expression
    | relational_expression '>' additive_expression
    | relational_expression LE_OP additive_expression
    | relational_expression GE_OP additive_expression
    ;
    
additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression
    | additive_expression '-' multiplicative_expression
    ;
    
multiplicative_expression
    : primary_expression
    | multiplicative_expression '*' primary_expression
    | multiplicative_expression '/' primary_expression
    ;
    
primary_expression
    : conditional_expression
    ;

%%

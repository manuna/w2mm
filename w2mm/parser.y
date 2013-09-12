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
    char *strVal;
    variable_t varVal;
};

%token <varVal> IDENTIFIER
%token AND_OP OR_OP EQ_OP NE_OP IF ELSE ENDIF LE_OP GE_OP
%token ASK
%token <varVal> CONSTANT
%token <varVal> STRING_LITERAL
%token TEXT

%type <strVal> text TEXT
%type <varVal> additive_expression multiplicative_expression primary_expression
%type <varVal> if_expr conditional_expression logical_or_expression logical_and_expression
%type <varVal> equality_expression relational_expression

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
        printf("condition value: %d\n", $1.value.val_integer);
        printf("text in if:\n%s\n", $2);
    }
    | if_expr text else_expr text endif_expr
    {
        printf("condition value: %d\n", $1.value.val_integer);
        printf("text in if:\n%s\ntext in else:\n%s\n", $2, $4);
    }
    ;
    
ask_statement
    : '[' ASK STRING_LITERAL IDENTIFIER ']'
    {
        printf("ask text: %s\nask identifier: %s\n", $3.value.val_string, $4.value.val_string);
    }
    ;

if_expr
    : '[' IF conditional_expression ']'
    {
        $$ = $3;
    };
    
else_expr
    : '[' ELSE ']';
    
endif_expr
    : '[' ENDIF ']';

conditional_expression
    : CONSTANT
    {
        $$.var_type = VAR_BOOL;
        switch($1.var_type) {
            case VAR_DOUBLE:
                $$.value.val_integer = $1.value.val_double != 0;
                break;
            case VAR_INTEGER:
            case VAR_BOOL:
                $$.value.val_integer = $1.value.val_integer != 0;
                break;
            case VAR_STRING:
                $$.value.val_integer = $1.value.val_string != NULL;
                break;
            default:
                $$.value.val_integer = 0;
                break;

        }
    }
    | IDENTIFIER
    {
        $$.var_type = VAR_BOOL;
        if ($1.var_type == VAR_STRING) {
            variable_t tmpVar;
            query_variable($1.value.val_string, &tmpVar);
            
            switch(tmpVar.var_type) {
                case VAR_DOUBLE:
                    $$.value.val_integer = tmpVar.value.val_double != 0;
                    break;
                case VAR_INTEGER:
                case VAR_BOOL:
                    $$.value.val_integer = tmpVar.value.val_integer != 0;
                    break;
                case VAR_STRING:
                    $$.value.val_integer = tmpVar.value.val_string != NULL;
                    break;
                default:
                    $$.value.val_integer = 0;
                    break;

            }
        } else {
            $$.value.val_integer = 0;
        }
    }
    | STRING_LITERAL
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = 0;
        
    }
    | logical_or_expression
    | '(' logical_or_expression ')'
    {
        $$ = $2;
    }
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR_OP logical_and_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer || $3.value.val_integer;
    }
    ;

logical_and_expression
    : equality_expression
    | logical_and_expression AND_OP equality_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer && $3.value.val_integer;
    }
    ;

equality_expression
    : relational_expression
    | equality_expression EQ_OP relational_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer == $3.value.val_integer;
    }
    | equality_expression NE_OP relational_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer != $3.value.val_integer;
    }
    ;

relational_expression
    : additive_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer != 0;
    }
    | relational_expression '<' additive_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer < $3.value.val_integer;
    }
    | relational_expression '>' additive_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer > $3.value.val_integer;
    }
    | relational_expression LE_OP additive_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer <= $3.value.val_integer;
    }
    | relational_expression GE_OP additive_expression
    {
        $$.var_type = VAR_BOOL;
        $$.value.val_integer = $1.value.val_integer >= $3.value.val_integer;
    }
    ;
    
additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression
    {
        // TODO: result might be not integer
        $$.var_type = VAR_INTEGER;
        $$.value.val_integer = $1.value.val_integer + $3.value.val_integer;
    }
    | additive_expression '-' multiplicative_expression
    {
        // TODO: result might be not integer
        $$.var_type = VAR_INTEGER;
        $$.value.val_integer = $1.value.val_integer - $3.value.val_integer;
    }
    ;
    
multiplicative_expression
    : primary_expression
    | multiplicative_expression '*' primary_expression
    {
        // TODO: result might be not integer
        $$.var_type = VAR_INTEGER;
        $$.value.val_integer = $1.value.val_integer * $3.value.val_integer;
    }
    | multiplicative_expression '/' primary_expression
    {
        // TODO: result might be not integer
        $$.var_type = VAR_INTEGER;
        $$.value.val_integer = $1.value.val_integer / $3.value.val_integer;
    }
    ;
    
primary_expression
    : conditional_expression
    ;

%%

%{
#include <stdio.h>
#include <string.h>
int yylex(void);
int yyparse();

int yydebug=1;

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
	while (1) {
    	yyparse();
    }
	return 0;
} 

%}

%token LBRACKET RBRACKET
%token CONSTANT STRING_LITERAL IDENTIFIER
%token AND OR IF ELSE ENDIF
%token TEXT

%%

translation_unit
    : if_statement
     /*TEXT else_statement TEXT endif_statement*/
     ;

if_statement
    : LBRACKET /*IF CONSTANT*/ RBRACKET
    {
        printf("if_statement");
    };
    
else_statement
    : LBRACKET ELSE RBRACKET;
    
endif_statement
    : LBRACKET ENDIF RBRACKET;

primary_expr
    : CONSTANT
    | STRING_LITERAL
    | IDENTIFIER
    | '(' expr ')'
	;
    
expr: primary_expr;
	
%%

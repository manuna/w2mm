D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*
LB          (\[)
RB          (\])

%{
#include "y.tab.h"
%}

%%
LB						{
                            printf("LBRACKET");
                            return LBRACKET;
                        }

RB						{
                            printf("RBRACKET");
                            return RBRACKET;
                        }
                        
"AND"                   {
                            printf("%s ", yytext);
                            return (AND);
                        }

"OR"                    {
                            printf("%s ", yytext);
                            return (OR);
                        }
                        
"IF"                    {
                            printf("%s ", yytext);
                            return (IF);
                        }
                        
"ELSE"                  {
                            printf("%s ", yytext);
                            return (ELSE);
                        }
                        
"ENDIF"                 {
                            printf("%s ", yytext);
                            return (ENDIF);
                        }

0[xX]{H}+{IS}?          {
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

0{D}+{IS}?              {
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

{D}+{IS}?               {
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

L?'(\\.|[^\\'])+'       {
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

{D}+{E}{FS}?            {
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

{D}*"."{D}+({E})?{FS}?	{
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

{D}+"."{D}*({E})?{FS}?	{
                            printf("CONSTANT(%s) ", yytext);
                            return(CONSTANT);
                        }

\"(\\.|[^\\"])*\"       {
                            printf("STRING_LITERAL(%s) ", yytext);
                            return(STRING_LITERAL);
                        }

{L}({L}|{D})*           {
                            printf("IDENTIFIER(%s) ", yytext);
                            return(IDENTIFIER);
                        }
						
[-+\n]					{ return *yytext; }
[ \t]+					/* ignore whitespaces */
%%
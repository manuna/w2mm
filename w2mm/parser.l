D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include "vartable.h"
#include "y.tab.h"
int linenumber = 1;
%}

%s COMMAND

%%

<INITIAL>{
"["                     {
                            BEGIN(COMMAND);
                            return *yytext;
                        }
                        
[^\[^\n]+               {
                            yylval.strVal = strdup(yytext);
                            return(TEXT);
                        }
                        
"\n"                    {
                            yylval.strVal = strdup(yytext);
                            ++linenumber;
                            return(TEXT);
                        }

}

<COMMAND>{

"]"						{
                            BEGIN(INITIAL);
                            return *yytext;
                        }
                        
"AND"                   {
                            return(AND_OP);
                        }

"OR"                    {
                            return(OR_OP);
                        }
                        
"IF"                    {
                            return(IF);
                        }
                        
"ELSE"                  {
                            return(ELSE);
                        }
                        
"ENDIF"                 {
                            return(ENDIF);
                        }
                        
"ASK"                   {
                            return(ASK);
                        }
    
"="                     {
                            return(EQ_OP);
                        }
    
"<>"                    {
                            return(NE_OP);
                        }
                        
">"                     {
                            return(*yytext);
                        }
                        
"<"                     {
                            return(*yytext);
                        }
                        
">="                    {
                            return(GE_OP);
                        }
                        
"<="                    {
                            return(LE_OP);
                        }

0[xX]{H}+{IS}?          {
                            yylval.varVal.var_type = VAR_INTEGER;
                            yylval.varVal.value.val_integer = atoi(yytext);
                            return(CONSTANT);
                        }

0{D}+{IS}?              {
                            yylval.varVal.var_type = VAR_INTEGER;
                            yylval.varVal.value.val_integer = atoi(yytext);
                            return(CONSTANT);
                        }

{D}+{IS}?               {
                            yylval.varVal.var_type = VAR_INTEGER;
                            yylval.varVal.value.val_integer = atoi(yytext);
                            return(CONSTANT);
                        }

'(\\.|[^\\'])+'         {
                            yylval.varVal.var_type = VAR_INTEGER;
                            yylval.varVal.value.val_integer = atoi(yytext);
                            return(CONSTANT);
                        }

{D}+{E}{FS}?            {
                            yylval.varVal.var_type = VAR_DOUBLE;
                            yylval.varVal.value.val_double = atof(yytext);
                            return(CONSTANT);
                        }

{D}*"."{D}+({E})?{FS}?	{
                            yylval.varVal.var_type = VAR_DOUBLE;
                            yylval.varVal.value.val_double = atof(yytext);
                            return(CONSTANT);
                        }

{D}+"."{D}*({E})?{FS}?	{
                            yylval.varVal.var_type = VAR_DOUBLE;
                            yylval.varVal.value.val_double = atof(yytext);
                            return(CONSTANT);
                        }

\"(\\.|[^\\"])*\"       {
                            yylval.varVal.var_type = VAR_STRING;
                            yylval.varVal.value.val_string = strdup(yytext);
                            return(STRING_LITERAL);
                        }

{L}({L}|{D})*           {
                            yylval.varVal.var_type = VAR_STRING;
                            yylval.varVal.value.val_string = strdup(yytext);
                            return(IDENTIFIER);
                        }
						
[-+]					{ return *yytext; }
[\n]                    { ++linenumber; return *yytext; }
[ \t]+					/* ignore whitespaces */

}

%%

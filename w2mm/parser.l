D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
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
                            yylval.numberVal = atoi(yytext);
                            return(CONSTANT);
                        }

0{D}+{IS}?              {
                            yylval.numberVal = atoi(yytext);
                            return(CONSTANT);
                        }

{D}+{IS}?               {
                            yylval.numberVal = atoi(yytext);
                            return(CONSTANT);
                        }

'(\\.|[^\\'])+'         {
                            yylval.numberVal = atoi(yytext);
                            return(CONSTANT);
                        }

{D}+{E}{FS}?            {
                            yylval.numberVal = atof(yytext);
                            return(CONSTANT);
                        }

{D}*"."{D}+({E})?{FS}?	{
                            yylval.numberVal = atof(yytext);
                            return(CONSTANT);
                        }

{D}+"."{D}*({E})?{FS}?	{
                            yylval.numberVal = atof(yytext);
                            return(CONSTANT);
                        }

\"(\\.|[^\\"])*\"       {
                            yylval.strVal = strdup(yytext);
                            return(STRING_LITERAL);
                        }

{L}({L}|{D})*           {
                            yylval.strVal = strdup(yytext);
                            return(IDENTIFIER);
                        }
						
[-+]					{ return *yytext; }
[\n]                    { ++linenumber; return *yytext; }
[ \t]+					/* ignore whitespaces */

}

%%

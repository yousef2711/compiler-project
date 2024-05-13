/**********/
/* File: tiny.flex            */
/* Lex specification for TINY */
/**********/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "util.c"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}({letter}|{digit})*
newline     \n
whitespace  [ \t]+

/* This tells flex to read only one input file */
%option noyywrap

%%

"if"            {return IF;}
"else"          {return ELSE;}
"int"           {return INT;}
"return"        {return RETURN;}
"void"          {return VOID;}
"while"         {return WHILE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"<"             {return LT;}
">"             {return GT;}
"=="            {return EQ;}
"!="            {return NE;}
";"             {return SEMI;}
","             {return COMMA;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"{"             {return LBRACE;}
"}"             {return RBRACE;}
"["             {return LBRACKET;}  // Added to handle array indexing
"]"             {return RBRACKET;}  // Added to handle array indexing
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"/*"            { char c, prev = 0;
                  do
                  { c = input();
                    if (c == '*' && prev == '/') break;
                    prev = c;
                    if (c == '\n') lineno++;
                  } while (1);
                }
.               {return ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = fopen("tiny.txt", "r+");
    yyout = fopen("result.txt", "w+");
    listing = yyout;
  }
  currentToken = yylex();
  strncpy(tokenString, yytext, MAXTOKENLEN);
  
  fprintf(listing, "\t%d: ", lineno);
  printToken(currentToken, tokenString);
  
  return currentToken;
}

int main()
{
	printf("Welcome to the TINY Flex scanner. Awaiting tokens...\n");
	while(getToken())
	{
		printf("A new token has been detected...\n");
	}
	return 1;
}
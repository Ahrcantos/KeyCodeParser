%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "keycode_parser.tab.h"


//Used for temporary storage when
//parsing strings
char* string_content;
char* keycode_content;

%}

%x STRING_STATE
%x KEYCODE_STATE

STRING_CONTENT		(\\.|[^"\\]){0,127}
KEYCODE_CONTENT		(\\.|[^'\\]){0,127}
NUMBER						[0-9]+
IDENTIFIER				[a-zA-Z][a-zA-Z0-9_]{0,126}

%%

\"								{BEGIN(STRING_STATE);}
<STRING_STATE>{STRING_CONTENT} {
										string_content = malloc(yyleng + 2);
										strncpy(string_content, yytext, yyleng);
									}
<STRING_STATE>\"	{
										yytext = string_content;
										BEGIN(INITIAL);
										return STRING;
									}


\'								{BEGIN(KEYCODE_STATE);}
<KEYCODE_STATE>{KEYCODE_CONTENT} {
										keycode_content = malloc(yyleng + 2);
										strncpy(keycode_content, yytext, yyleng);
									}
<KEYCODE_STATE>\'	{
										yytext = keycode_content;
										BEGIN(INITIAL);
										return KEYCODE;
									}

{NUMBER}					{
										return NUMBER;
									}

WRITE							{return WRITE;}
EXEC							{return EXEC;}
CMD								{return CMD;}
LINE							{return LINE;}
SPEED 						{return SPEED;}
SHELL 						{return SHELL;}
REPEAT 						{return REPEAT;}
INCLUDE 					{return INCLUDE;}
WRITE_PREFIX			{return WRITE_PREFIX;}
EXEC_PREFIX				{return EXEC_PREFIX;}
CMD_PREFIX				{return CMD_PREFIX;}
LINE_PREFIX				{return LINE_PREFIX;}
WRITE_SUFFIX			{return WRITE_SUFFIX;}
EXEC_SUFFIX				{return EXEC_SUFFIX;}
CMD_SUFFIX				{return CMD_SUFFIX;}
LINE_SUFFIX				{return LINE_SUFFIX;}

{IDENTIFIER}			{return IDENTIFIER;}

[\(\)\{\}\+\,\=]	{return yytext[0];}
.									{}

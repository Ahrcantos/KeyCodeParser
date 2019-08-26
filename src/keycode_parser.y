%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "types.h"
%}

%start input

%token WRITE
%token EXEC
%token CMD
%token LINE
%token IDENTIFIER
%token STRING
%token KEYCODE
%token NUMBER
%token SPEED
%token SHELL
%token REPEAT
%token INCLUDE
%token WRITE_PREFIX
%token EXEC_PREFIX
%token CMD_PREFIX
%token LINE_PREFIX
%token WRITE_SUFFIX
%token EXEC_SUFFIX
%token CMD_SUFFIX
%token LINE_SUFFIX

%%

input:
		%empty
|		action input
|		asign input
;

action:
			WRITE expression
|			EXEC expression
|			CMD expression
|			LINE expression
;

asign:
		 WRITE_PREFIX '=' expression
|		 EXEC_PREFIX '=' expression
|		 CMD_PREFIX '=' expression
|		 LINE_PREFIX '=' expression
|		 WRITE_SUFFIX '=' expression
|		 EXEC_SUFFIX '=' expression
|		 CMD_SUFFIX '=' expression
|		 LINE_SUFFIX '=' expression

expression:
					STRING
|					KEYCODE
|					STRING '+' expression
|					KEYCODE '+' expression



%%

int
main(int argc, char** argv)
{
	return yyparse();
}

void
yyerror(const char* error)
{
	printf("%s", error);
}


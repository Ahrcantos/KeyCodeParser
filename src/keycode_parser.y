%code requires
{
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <xdo.h>

	#include "expression.h"
	#include "variable.h"
	#include "instruction.h"
}


%code requires
{
	//Evaluates the expression and presses all the
	//keys within it in sequence
	//Used when an instruction for key presses is 
	//executed
	void
	exec_expression(expression_t* expr);
}



%start input

%token WRITE
%token EXEC
%token CMD
%token LINE
%token <string> IDENTIFIER
%token <string> STRING
%token <string> KEYCODE
%token NUMBER
%token SHELL
%token REPEAT
%token INCLUDE
%type <expression> expression

%union
{
	expression_t* 				expression;
	char*									string;
	var_list_t*						params;
	variable_t*						param;
}

%%

input:
		%empty
|		input action
|		input call
;

action:
			WRITE expression
{
	exec_expression($2);
	expression_free($2);
}
|			EXEC expression
|			CMD expression
|			LINE expression
;

expression:
					STRING
{
	$$ = init_expression();
	append_to_expression($$, $1, STRING_LITERAL_TYPE);
}
|					KEYCODE
{
	$$ = init_expression();
	append_to_expression($$, $1, KEYCODE_LITERAL_TYPE);
}
|					IDENTIFIER
{
	//TODO New copy of expression needs to be created
	$$ = init_expression();
	append_to_expression($$, $1, VAR_TYPE);
}
|					expression '+' STRING
{
	append_to_expression($1, $3, STRING_LITERAL_TYPE);
	$$ = $1;
}
|					expression '+' KEYCODE
{
	append_to_expression($1, $3, KEYCODE_LITERAL_TYPE);
	$$ = $1;
}
|					expression '+' IDENTIFIER
{
	//TODO New copy of expression needs to be created
	append_to_expression($1, $3, VAR_TYPE);
	$$ = $1;
}

call:
					IDENTIFIER '(' parameters ')'
{
}
|					IDENTIFIER '(' ')'
{
}
;

parameters:
					expression
{
}
|					parameters ',' expression
{

}
;




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

void
exec_expression(expression_t* expr)
{
	if(expr->head == NULL)
		return;

	expression_node_t* tmp = expr->head;
	xdo_t* x = xdo_new(":0.0");

	while(tmp != NULL)
	{
		if(tmp->type == STRING_LITERAL_TYPE)
		{
			xdo_enter_text_window
				(
				 x, CURRENTWINDOW, 
				 tmp->value, 
				 70000
				);
		}
		else
		{
		xdo_send_keysequence_window
			(
			 x, CURRENTWINDOW, 
			 tmp->value, 
			 70000
			);
		}
		tmp = tmp->next;
	}
	xdo_free(x);
}

#ifndef VARIABLE_H
#define VARIABLE_H

#include <stdlib.h>
#include <string.h>
#include "expression.h"



//===========Variable========================

#define VAR_EXPR 0
#define VAR_NUM 1

typedef struct variable_t
{
	char* name;
	short type;
	union
	{
		expression_t* expr;
		long 					number;
	} value;
} variable_t;

//Initialises a new variable with given name
//Uses when a variable is not yet declared but
//assigned or when parameter list need to be created
variable_t*
var_init(char* name);


//Set the type of the variable to that
//of a number and asigns a value
variable_t*
var_asign_num(variable_t* var, long num);

variable_t*
var_asign_expr(variable_t* var, expression_t* expr);

//Frees the memory of the variable
//Used when the call stack is reduced or
//when parameter lists become irrelevant
void
var_free(variable_t* var);



//=========Var-List================================

typedef struct var_node_t
{
	variable_t 								var;
	struct var_node_t* 				next;
} var_node_t;

typedef struct var_list_t
{
	var_node_t* head;
} var_list_t;

//Initializes a new variable list.
//Used when a new function call is found
//or at the start of the programm to set up
//the global namespace, or in function definitions.
//In the later case only the name attribute
//in each variable is set
var_list_t*
init_var_list();



#endif

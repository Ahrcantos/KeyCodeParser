#include "variable.h"



//===========Variable========================

variable_t*
var_init(char* name)
{
	variable_t* var;
	var = (variable_t*) malloc(sizeof(variable_t));
	memset(var, 0, sizeof(variable_t));

	int len_name = strlen(name) + 1;
	var->name = (char*) malloc(len_name);
	strncpy(var->name, name, len_name);

	return var;
}

void
var_free(variable_t* var)
{
	free(var->name);

	if(var->type == VAR_EXPR)
	{
		//TODO Free expression
	}

	free(var);
}


//=========Var-List================================

var_list_t*
init_var_list()
{
	var_list_t* var_list;
	var_list = (var_list_t*) malloc(sizeof(var_list_t));
	var_list->head = NULL;
	return var_list;
}

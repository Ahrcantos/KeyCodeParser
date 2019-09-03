#include "expression.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

//Appends a string or keycode to the expression
//to associate that literal with that expression
//since they cannot simply be concatenated.
//Also looks the correct type of keycode id if the
//type happens to be that of a keycode literal
expression_node_t*
append_to_expression(expression_t* expr, char* content, short type)
{
	//Create new node
	expression_node_t* added_node;
	added_node = (expression_node_t*) malloc(sizeof(expression_node_t));
	added_node->next = NULL;
	added_node->type = type;
	added_node->value = content;

	if(expr->head == NULL)
	{
		expr->head = added_node;
	}
	else
	{
		//Walk the list
		expression_node_t* tmp = expr->head;
		while(tmp->next != NULL)
		{
			tmp = tmp->next;
		}
		//and append
		tmp->next = added_node;

	}


	return added_node;
}

expression_t*
init_expression()
{
	expression_t* expr;
	expr = (expression_t*) malloc(sizeof(expression_t));

	expr->head = NULL;
	return expr;
}


void
show_expression(expression_t* expr)
{

	if(expr->head == NULL)
	{
		printf("Empty expression");
		return;
	}
	
	expression_node_t* tmp = expr->head;
	while(tmp != NULL)
	{
		printf(" -->");
		if(tmp->type == KEYCODE_LITERAL_TYPE)
		{
			printf("Keycode: %s", tmp->value);
		}
		else
		{
			printf("String: %s", tmp->value);
		}
		tmp = tmp->next;
	}
}

expression_t*
merge_expression(expression_t* dest, expression_t* src)
{
	if(dest->head == NULL)
	{
		dest->head = src->head;
		return dest;
	}
	
	expression_node_t* tmp = dest->head;
	while(tmp->next == NULL)
	{
		tmp = tmp->next;
	}

	tmp->next = src->head;

	return dest;
}


expression_t*
copy_expression(expression_t* org)
{
	expression_t* copy_expr;
	copy_expr = (expression_t*) malloc(sizeof(expression_t));

	expression_node_t *copy_node = NULL, *prev_node = NULL;

	expression_node_t* tmp;
	tmp =  org->head;

	while(tmp != NULL)
	{
		copy_node = copy_expression_node(tmp);
		if(prev_node == NULL)
		{
			copy_expr->head = copy_node;
			prev_node = copy_node;
		}
		else
		{
			prev_node->next = copy_node;
			prev_node = copy_node;
		}
		tmp = tmp->next;
	}


	return copy_expr;
}


expression_node_t*
copy_expression_node(expression_node_t* org)
{
	if(org == NULL)
		return NULL;


	expression_node_t* copy_node;
	copy_node = (expression_node_t*) malloc(sizeof(expression_node_t));

	copy_node->type = org->type;
	copy_node->next = NULL;
	copy_node->value = (char*) strdup(org->value);

	return copy_node;
}

void
expression_free(expression_t* expr)
{
	if(expr->head == NULL)
		return;

	expression_node_t *next = NULL, *tmp = expr->head;	

	while(tmp->next != NULL)
	{
		next = tmp->next;
		free(tmp->value);
		free(tmp);
		tmp = next;
	}

	free(expr);
}

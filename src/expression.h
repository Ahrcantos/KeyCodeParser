#ifndef EXPRESSION_H
#define EXPRESSION_H
//===============Expression========================

#define VAR_SIZE 128
#define STRING_LITERAL_TYPE 0
#define KEYCODE_LITERAL_TYPE 1
#define VAR_TYPE 2

typedef struct expression_node_t
{
	short type;
	char* value;

	struct expression_node_t* next;
} expression_node_t;

typedef struct expression_t
{
	struct expression_node_t* head;
} expression_t;

//Appends a string or keycode to the expression
//to associate that literal with that expression
//since they cannot simply be concatenated.
//Also looks the correct type of keycode id if the
//type happens to be that of a keycode literal
expression_node_t*
append_to_expression(expression_t* expr, char* content, short type);

//Initalizes a new expression (list)
//Used when an expression is detected within the
//grammar
expression_t*
init_expression();

//Print an entire expression chain for
//debugging purposes
void
show_expression(expression_t* expr);

//Append an expression to another one
//Used when for example the value of a
//variable needs to be added to an expression
//which in itself can also be an expression
expression_t*
merge_expression(expression_t* dest, expression_t* src);


//Copies every element of the expression
//into a new one. Used when expressions
//get passed by value, which they always
//do
expression_t*
copy_expression(expression_t* org);

//Copies an expression node
//Used in copy_expression when the nodes
//of the expression are copied
//Note: While all attributes are copied
// the next pointer whould still point to a
//none copied version of the next object.
//Thus to avoid trouble it is set to NULL
expression_node_t*
copy_expression_node(expression_node_t* org);

#endif

#ifndef INSTRUCTION_H
#define INSTRUCTION_H

#define WRITE_CMD 0
#define EXEC_CMD 1
#define CMD_CMD 2
#define LINE_CMD 3

//Structure for all standard commands
//like WRITE, LINE, etc. uses when building
//the execution tree to denote a cmd instruction
typedef struct cmd_t
{
	short type;
	expression_t* expr;
} cmd_t;

//Uses in the execution tree for all asignments
//that occur
typedef struct asignment_t
{
	char*					var_name;
	expression_t* value;
} asignment_t;

//Used in the execution tree for all functions
//calls. Stores the function name aswell as all the
//parameters with which the function is called
typedef struct call_t
{
	char*					func_name;
	//TODO parameterlist
} call_t;

typedef struct instruction_t
{
	short type;
	expression_t* expr;

	struct instruction_t* next;
} instruction_t;

typedef struct instruction_seq_t
{
	instruction_t* head;
} instruction_seq_t;

#endif

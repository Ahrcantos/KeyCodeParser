%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "keycode_parser.tab.h"

//Used for temporary storage when
//parsing strings
#define STRING_SIZE 1024
char string_content[STRING_SIZE];
char* keycode_content;

int
append_string_to_buffer(char* buffer, char* str);

//Appends a char to the string in the given
//buffer
int
append_char_to_buffer(char* buffer, char c);

//Clears the given string buffer
void
clear_buffer(char* buffer);

//Saves the current buffer on the heap
//and returns the pointer
char*
save_buffer(char* buffer);


void 
clear_value();

%}

%x string_state
%x keycode_state

NUMBER						[0-9]+
IDENTIFIER				[a-zA-Z][a-zA-Z0-9_]{0,126}

%%

\" {
	BEGIN(string_state); 
	clear_buffer(string_content);
}
<string_state>[^\\"\n]* {
	append_string_to_buffer(string_content, yytext);
}
<string_state>\\n {
	append_char_to_buffer(string_content, '\n');
}
<string_state>\\t {
	append_char_to_buffer(string_content, '\t');
}
<string_state>\\[0-7]* {
	append_char_to_buffer(string_content, strtol(yytext+1, 0, 8));
}
<string_state>\\[\\"] {
	append_char_to_buffer(string_content, yytext[1]);
}
<string_state>\\. {
	printf("Invalid escape sequenze %s in string!", yytext);
	exit(EXIT_FAILURE);
}
<string_state>\n {
	printf("Newline in string!\n");
	exit(EXIT_FAILURE);
}
<string_state><<EOF>> {
	printf("Unterminated String\n");
	exit(EXIT_FAILURE);
}
<string_state>\" {
	clear_value();
	yylval.string = save_buffer(string_content);
	BEGIN(INITIAL);
	return STRING;
}


\' {
	clear_buffer(string_content);
	BEGIN(keycode_state);
}
<keycode_state>[^\\'\n]* {
	append_string_to_buffer(string_content, yytext);
}
<keycode_state>\'	{
	clear_value();
	yylval.string = save_buffer(string_content);
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

{IDENTIFIER} {
	clear_buffer(string_content);
	append_string_to_buffer(string_content, yytext);
	yylval.string = save_buffer(string_content);
	return IDENTIFIER;
}


[\(\)\{\}\+\,\=]	{return yytext[0];}
.									{}

%%

void 
clear_value()
{
	memset(&yylval, 0, sizeof(yylval));
}

void
clear_buffer(char* buffer)
{
	memset(buffer, '\0', STRING_SIZE);
}


int
append_string_to_buffer(char* buffer, char* str)
{
	size_t buffer_len = strlen(buffer);
	size_t string_len = strlen(str);

	if(buffer_len + string_len < STRING_SIZE - 1)
	{
		strcat(buffer, str);
		return 0;
	}

	fprintf(stderr, "%s\n", "String too long");
	exit(EXIT_FAILURE);
}


int
append_char_to_buffer(char* buffer, char c)
{
	size_t buffer_len = strlen(buffer);
	size_t char_len = sizeof(c);

	if(buffer_len + char_len < STRING_SIZE)
	{
		strncat(buffer, &c, char_len);
		return 0;
	}

	fprintf(stderr, "%s\n", "String too long");
	exit(EXIT_FAILURE);

}

char*
save_buffer(char* buffer)
{
	int len = strlen(buffer);
	char* ptr = (char*) malloc(len + 1);
	strncpy(ptr, buffer, len + 1);
	return ptr;
}

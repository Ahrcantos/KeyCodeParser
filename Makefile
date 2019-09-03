keycode_parser: src/keycode_parser.l src/keycode_parser.y src/expression.c src/variable.c
	flex -o src/keycode_parser.yy.c src/keycode_parser.l
	bison -o src/keycode_parser.tab.c --defines=src/keycode_parser.tab.h src/keycode_parser.y
	gcc -ggdb -o build/keycode_parser src/keycode_parser.tab.c src/keycode_parser.yy.c src/expression.c src/variable.c -ll -lxdo

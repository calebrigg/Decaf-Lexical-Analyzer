
%{

#include <iostream>
#include <cstdlib>

using namespace std;
int linecount=1;
%}

char [a-zA-Z]*
escaped_char "\\"("n"|"t"|"r"|"a"|"v"|"b"|"\\")
string_lit "\""({char}|{escaped_char}|" ")*"\""
char_lit "\'"([a-zA-Z]|{escaped_char})"\'"
%s INPUT
%%
  /*
    Pattern definitions for all tokens
  */
func                       { return 1; }
extern			   { return 17; }
void			   { return 19; }
bool			   { return 20; }
for			   { return 21; }
false			   { return 22; }
else			   { return 23; }
continue		   { return 24; }
break			   { return 25; }
if			   { return 26; }
null			   { return 27; }
return			   { return 28; }
string			   { return 29; }
true			   { return 30; }
while			   { return 31; }
int                        { return 2; }
package                    { return 3; }
var 			   { return 14; }
\{                         { return 4; }
\}                         { return 5; }
\(                         { return 6; }
\)                         { return 7; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { return 8; }
[\t\r\a\v\b ]+             { return 9; }
\n+[\t\r\a\v\b ]*\n*       { return 10; }
\;			   { return 11; }
\=			   { return 12; }
[0-9]+			   { return 13; }
\/\/.*\n		   { return 15; }
{char_lit}	   	{ return 16; }
\'\' { cerr << "Error: char constant has zero width" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
\'[\\|\n|\"|\del]+\' { cerr << "Error: unexpected character in input" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
\'..+\' { cerr << "Error: char constant length is greater than one" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
\'. { cerr << "Error: unterminated char constant" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
-			   { return 18; }
,			   { return 32; }
==			   { return 33; }
\%			   { return 34; }
\*			   { return 35; }
\+			   { return 36; }
{string_lit}	   { return 37; }
\"[\\]	{ cerr << "Error: unknown escape sequence in string constant" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
\"[\n|\"]*\"	 { cerr << "Error: newline in string constant" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
\".*	 { cerr << "Error: string constant is missing closing delimiter" <<endl << "Lexical error: line " << linecount <<endl; return -1;}
&&			   { return 38; }
\/			   { return 39; }
\.			   { return 40; }
>=			   { return 41; }
>			   { return 42; }
\<\<			   { return 43; }
\<=			   { return 44; }
!=			   { return 45; }
!			   { return 46; }
\[			   { return 47; }
\<			   { return 48; }
\|\|			   { return 49; }
>>			   { return 50; }
\]			   { return 51; }
.                          { cerr << "Error: unexpected character in input " << endl; return -1; }

%%


string getnewline(string lexeme){
	string result = "T_WHITESPACE ";
	for (int i=0; i<lexeme.size(); i++){
		if(lexeme[i]=='\n'){
		linecount++;
			result+="\\n";
		}
	}
return result;
}

void errLine(int linecount){
	cout<< linecount << endl;
}

int main () {
  int token;
  string lexeme;
  while ((token = yylex())) {
    if (token > 0) {
      lexeme.assign(yytext);
      switch(token) {
        case 1: cout << "T_FUNC " << lexeme << endl; break;
        case 2: cout << "T_INTTYPE " << lexeme << endl; break;
        case 3: cout << "T_PACKAGE " << lexeme << endl; break;
        case 4: cout << "T_LCB " << lexeme << endl; break;
        case 5: cout << "T_RCB " << lexeme << endl; break;
        case 6: cout << "T_LPAREN " << lexeme << endl; break;
        case 7: cout << "T_RPAREN " << lexeme << endl; break;
        case 8: cout << "T_ID " << lexeme << endl; break;
        case 9: cout << "T_WHITESPACE " << lexeme << endl; break;
        case 10: cout << getnewline(lexeme) << endl; break;
	case 11: cout << "T_SEMICOLON " << lexeme << endl; break;
	case 12: cout << "T_ASSIGN " << lexeme << endl; break;
	case 13: cout << "T_INTCONSTANT " << lexeme << endl; break;
	case 14: cout << "T_VAR " << lexeme << endl; break;
	case 15: linecount++; cout << "T_COMMENT " << lexeme.substr(0,lexeme.size()-1) << "\\n" << endl; break;
	case 16: cout << "T_CHARCONSTANT " << lexeme << endl; break;
	case 17: cout << "T_EXTERN " << lexeme << endl; break;
	case 18: cout << "T_MINUS " << lexeme << endl; break;
	case 19: cout << "T_VOID " << lexeme << endl; break;
	case 20: cout << "T_BOOLTYPE " << lexeme << endl; break;
	case 21: cout << "T_FOR " << lexeme << endl; break;
	case 22: cout << "T_FALSE " << lexeme << endl; break;
	case 23: cout << "T_ELSE " << lexeme << endl; break;
	case 24: cout << "T_CONTINUE " << lexeme << endl; break;
	case 25: cout << "T_BREAK " << lexeme << endl; break;
	case 26: cout << "T_IF " << lexeme << endl; break;
	case 27: cout << "T_NULL " << lexeme << endl; break;
	case 28: cout << "T_RETURN " << lexeme << endl; break;
	case 29: cout << "T_STRINGTYPE " << lexeme << endl; break;
	case 30: cout << "T_TRUE " << lexeme << endl; break;
	case 31: cout << "T_WHILE " << lexeme << endl; break;
	case 32: cout << "T_COMMA " << lexeme << endl; break;
	case 33: cout << "T_EQ " << lexeme << endl; break;
	case 34: cout << "T_MOD " << lexeme << endl; break;
	case 35: cout << "T_MUL " << lexeme << endl; break;
	case 36: cout << "T_ADD " << lexeme << endl; break;
	case 37: cout << "T_STRINGCONSTANT " << lexeme << endl; break;
	case 38: cout << "T_AND " << lexeme << endl; break;
	case 39: cout << "T_DIV " << lexeme << endl; break;
	case 40: cout << "T_DOT " << lexeme << endl; break;
	case 41: cout << "T_GEQ " << lexeme << endl; break;
	case 42: cout << "T_GT " << lexeme << endl; break;
	case 43: cout << "T_LEFTSHIFT " << lexeme << endl; break;
	case 44: cout << "T_LEQ " << lexeme << endl; break;
	case 45: cout << "T_NEQ " << lexeme << endl; break;
	case 46: cout << "T_NOT " << lexeme << endl; break;
	case 47: cout << "T_LSB " << lexeme << endl; break;
	case 48: cout << "T_LT " << lexeme << endl; break;
	case 49: cout << "T_OR " << lexeme << endl; break;
	case 50: cout << "T_RIGHTSHIFT " << lexeme << endl; break;
	case 51: cout << "T_RSB " << lexeme << endl; break;
        default: errLine(linecount);exit(EXIT_FAILURE);
      }
    } else {
      if (token < 0) {
	errLine(linecount);
        exit(EXIT_FAILURE);
      }
    }
  }
  exit(EXIT_SUCCESS);
}


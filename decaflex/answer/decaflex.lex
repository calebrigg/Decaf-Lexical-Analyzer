
%{

#include <iostream>
#include <cstdlib>

using namespace std;

int linecount=1;
int textpos = 0;
%}
all_char [\a\b\t\v\f\r \!\#\$\%\&\`\"\(\)\*\+\,\-\.\/0-9a-zA-Z\:\;\<\=\>\?\[\]\^_\'\{\}\|\~]
all_char_lit [ !#$%&()\*\+,-\./0-9a-zA-Z:;<=>\?\[\]_\{\}|~]
char [a-zA-Z0-9\,]*
escaped \\[n]
escaped_char_c "\\"("^"|"\""|"'"|"f"|"n"|"t"|"r"|"a"|"v"|"b"|"\\")
escaped_char_s "\\"("^"|"\""|"'"|"f"|"n"|"t"|"r"|"a"|"v"|"b"|"\\")
string_lit "\""({all_char_lit}|{escaped_char})*"\""
char_lit "\'"({all_char}|{escaped_char_c})"\'"
string ({all_char_lit}|{escaped_char_s})*
string_n ({all_char_lit}|{escaped_char_s}|"\n")*
%s STRINGSTART
%s ERRORSTRING

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
\'\' { cerr << "Error: char constant has zero width" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl; return -1;}
\'[\\|\n|\"|\del]+\' {cerr << "Error: unexpected character in input" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl; return -1;}
\'[a-zA-Z]+\' {cerr << "Error: char constant length is greater than one" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl; return -1;}
\'. {cerr << "Error: unterminated char constant" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl; return -1;}
-			   { return 18; }
,			   { return 32; }
==			   { return 33; }
\%			   { return 34; }
\*			   { return 35; }
\+			   { return 36; }
\"{string}\"   { return 37; }
\"{string_n}	  {cerr << "Error: newline in string constant" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl;return -1;}
\"[\\]+.*\"	{cerr << "Error: unknown escape sequence in string constant" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl; return -1;}
\"{string}	 {cerr << "Error: string constant is missing closing delimiter" <<endl << "Lexical error: line " << linecount << ", position " << textpos+1<<endl; return -1;}
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
    textpos=0;
			result+="\\n";
		}
    else if(lexeme[i]=='\t'){
      result+="\t";
    }
    else if(lexeme[i]==' '){
      result+=" ";
    }
    else if(lexeme[i]=='\r'){
      result+="\r";
    }
    else if(lexeme[i]=='\v'){
      result+="\v";
    }
    else if(lexeme[i]=='\b'){
      result+="\b";
    }
    textpos++;
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
        case 1: cout << "T_FUNC " << lexeme << endl; textpos+=lexeme.size(); break;
        case 2: cout << "T_INTTYPE " << lexeme << endl; textpos+=lexeme.size(); break;
        case 3: cout << "T_PACKAGE " << lexeme << endl; textpos+=lexeme.size(); break;
        case 4: cout << "T_LCB " << lexeme << endl; textpos+=lexeme.size(); break;
        case 5: cout << "T_RCB " << lexeme << endl; textpos+=lexeme.size(); break;
        case 6: cout << "T_LPAREN " << lexeme << endl; textpos+=lexeme.size(); break;
        case 7: cout << "T_RPAREN " << lexeme << endl; textpos+=lexeme.size(); break;
        case 8: cout << "T_ID " << lexeme << endl; textpos+=lexeme.size(); break;
        case 9: cout << "T_WHITESPACE " << lexeme << endl; textpos+=yyleng; break;
        case 10: cout << getnewline(lexeme) << endl; break;
	case 11: cout << "T_SEMICOLON " << lexeme << endl; textpos+=lexeme.size(); break;
	case 12: cout << "T_ASSIGN " << lexeme << endl; textpos+=lexeme.size(); break;
	case 13: cout << "T_INTCONSTANT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 14: cout << "T_VAR " << lexeme << endl; textpos+=lexeme.size(); break;
	case 15: linecount++; cout << "T_COMMENT " << lexeme.substr(0,lexeme.size()-1) << "\\n" << endl; textpos=0; break;
	case 16: cout << "T_CHARCONSTANT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 17: cout << "T_EXTERN " << lexeme << endl; textpos+=lexeme.size(); break;
	case 19: cout << "T_VOID " << lexeme << endl; textpos+=lexeme.size(); break;
  case 18: cout << "T_MINUS " << lexeme << endl; textpos+=lexeme.size(); break;
	case 20: cout << "T_BOOLTYPE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 21: cout << "T_FOR " << lexeme << endl; textpos+=lexeme.size(); break;
	case 22: cout << "T_FALSE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 23: cout << "T_ELSE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 24: cout << "T_CONTINUE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 25: cout << "T_BREAK " << lexeme << endl; textpos+=lexeme.size(); break;
	case 26: cout << "T_IF " << lexeme << endl; textpos+=lexeme.size(); break;
	case 27: cout << "T_NULL " << lexeme << endl; textpos+=lexeme.size(); break;
	case 28: cout << "T_RETURN " << lexeme << endl; textpos+=lexeme.size(); break;
	case 29: cout << "T_STRINGTYPE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 30: cout << "T_TRUE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 31: cout << "T_WHILE " << lexeme << endl; textpos+=lexeme.size(); break;
	case 32: cout << "T_COMMA " << lexeme << endl; textpos+=lexeme.size(); break;
	case 33: cout << "T_EQ " << lexeme << endl; textpos+=lexeme.size(); break;
	case 34: cout << "T_MOD " << lexeme << endl; textpos+=lexeme.size(); break;
	case 35: cout << "T_MUL " << lexeme << endl; textpos+=lexeme.size(); break;
	case 36: cout << "T_ADD " << lexeme << endl; textpos+=lexeme.size(); break;
	case 37: cout << "T_STRINGCONSTANT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 38: cout << "T_AND " << lexeme << endl; textpos+=lexeme.size(); break;
	case 39: cout << "T_DIV " << lexeme << endl; textpos+=lexeme.size(); break;
	case 40: cout << "T_DOT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 41: cout << "T_GEQ " << lexeme << endl; textpos+=lexeme.size(); break;
	case 42: cout << "T_GT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 43: cout << "T_LEFTSHIFT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 44: cout << "T_LEQ " << lexeme << endl; textpos+=lexeme.size(); break;
	case 45: cout << "T_NEQ " << lexeme << endl; textpos+=lexeme.size(); break;
	case 46: cout << "T_NOT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 47: cout << "T_LSB " << lexeme << endl; textpos+=lexeme.size(); break;
	case 48: cout << "T_LT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 49: cout << "T_OR " << lexeme << endl; textpos+=lexeme.size(); break;
	case 50: cout << "T_RIGHTSHIFT " << lexeme << endl; textpos+=lexeme.size(); break;
	case 51: cout << "T_RSB " << lexeme << endl; textpos+=lexeme.size(); break;
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

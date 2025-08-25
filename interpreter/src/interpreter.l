// fuente 'jflex' para interprete

package org.unp.plp.interprete;

%%

%class Lexer
%byaccj

%{

  private Parser yyparser;

  /** constructor del analizador sintáctico
  *** acepta como parámetro el lector de caracteres a usar
  **/

  public Lexer(java.io.Reader r, Parser p )
  {
    this(r);
    yyparser = p  ;
  }

  /** devuelve el numero de linea donde está el último caracter leido
  **/

  public int lineaActual()
  {
     return yyline;
  }

%}

%%

world { return Parser.WORLD; }
put { return Parser.PUT; }
in { return Parser.IN; }
hero { return Parser.HERO; }
gold { return Parser.GOLD; }
pit { return Parser.PIT; }
wumpus { return Parser.WUMPUS; }
display { return Parser.DISPLAY; }
i { return Parser.I; }
j { return Parser.J; }
\+ { return Parser.SUMA; }
\- { return Parser.RESTA; }
\* { return Parser.PROD; }
\/ { return Parser.DIV; }
\> { return Parser.MAYOR; }
\>= { return Parser.MAYOR_IGUAL; }
\< { return Parser.MENOR; }
\<= { return Parser.MENOR_IGUAL; }
\!= { return Parser.DISTINTO; }

[0-9]+
   {  yyparser.yylval = Integer.valueOf(yytext());
      return Parser.CONSTANT;
   }

[x,\(\)\[\]] 
  {
    yyparser.yylval = yytext();
    return yytext().charAt(0);
  }

\r|\n|\r\n
  { // lleva la cuenta de lineas
    yyline++ ;
    return Parser.NL;
  }

[ \t]+ {  /** accion vacia: se ignoran los espacios y tabuladores **/
       }

.      {  /** token desconocido: se produce un mensaje de error **/
          yyparser.yyerror("El lexema '"+yytext()+"' no corresponden a ningún token conocido");
       }

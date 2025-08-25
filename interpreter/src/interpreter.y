// fuente byaccj para una calculadora sencilla


%{
  import java.io.*;
  import java.util.List;
  import java.util.ArrayList;
  import org.unp.plp.interprete.WumpusWorld; 
%}


// lista de tokens por orden de prioridad
    
%token NL         // nueva línea
%token CONSTANT   // constante
%token WORLD
%token PUT IN
%token HERO GOLD WUMPUS PIT
%token PAR_ABRE PAR_CIERRA SEP_CELDA
%token DISPLAY
%token I J
%token SUMA RESTA DIV PROD
%token IGUAL MENOR MENOR_IGUAL MAYOR MAYOR_IGUAL DISTINTO

%%

program
  : world_stmt statement_list // Lista de sentencias
  ;

statement_list
  : statement                // Unica sentencia
  | statement statement_list // Sentencia,y lista
  ;

statement
  : CONSTANT NL { System.out.println("constante: "+ $1); $$ = $1; }
  | put_stmt
  | display_stmt
  | NL
  ;

world_stmt
  : WORLD CONSTANT 'x' CONSTANT NL { world = WumpusWorld.crear((int)$2, (int)$4); }
  ;

put_stmt
  : PUT elem IN '(' CONSTANT ',' CONSTANT ')' NL { world.agregarElemento((ELEMENTO)$2, world.getCelda((int)$5, (int)$7)); }
  | PUT PIT IN '[' cond_list ']'
  ;

cond_list
  : cond //{ $$ = $1; }
  | cond ',' cond_list //{ $$ = ($1 && $3); }
  ;

cond
  : expr operador expr //{ $$ = world.eval(); }
  ;

display_stmt
  : DISPLAY { world.print(); }
  ;

elem 
  : HERO { $$ = ELEMENTO.HERO; }
  | GOLD { $$ = ELEMENTO.GOLD; }
  | WUMPUS { $$ = ELEMENTO.WUMPUS; }
  | PIT { $$ = ELEMENTO.PIT; }
  ;

operador
  : IGUAL 
  | DISTINTO
  | MAYOR
  | MAYOR_IGUAL
  | MENOR
  | MENOR_IGUAL
  ;

expr
  : expr operador_princ term
  | term
  ;

term
  : term operador_sec factor
  | factor
  ;

factor
  : CONSTANT
  | J
  | I
  ;

operador_princ
  : SUMA
  | RESTA
  ;

operador_sec
  : DIV
  | PROD
  ;

%%

  /** referencia al analizador léxico
  **/
  private Lexer lexer ;

  private WumpusWorld world;

  /** constructor: crea el Interpreteranalizador léxico (lexer)
  **/
  public Parser(Reader r)
  {
     lexer = new Lexer(r, this);
  }

  /** esta función se invoca por el analizador cuando necesita el
  *** siguiente token del analizador léxico
  **/
  private int yylex ()
  {
    int yyl_return = -1;

    try
    {
       yylval = new Object();
       yyl_return = lexer.yylex();
    }
    catch (IOException e)
    {
       System.err.println("error de E/S:"+e);
    }

    return yyl_return;
  }

  /** invocada cuando se produce un error
  **/
  public void yyerror (String descripcion, int yystate, int token)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     System.err.println ("Token leído : "+yyname[token]);
  }

  public void yyerror (String descripcion)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     //System.err.println ("Token leido : "+yyname[token]);
  }

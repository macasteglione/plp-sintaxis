// fuente byaccj para una calculadora sencilla


%{
  import java.io.*;
  import java.util.List;
  import java.util.ArrayList;
  import org.unp.plp.interprete.WumpusWorld;
  import org.unp.plp.interprete.Condition;
  import org.unp.plp.interprete.ConditionList;
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

%left SUMA RESTA
%left PROD DIV

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
  | PUT PIT IN '[' cond_list ']' NL { world.agregarElemento((ELEMENTO)$2, (ConditionList)$5); }
  ;

cond_list
  : cond { 
      ConditionList list = new ConditionList();
      list.addCondition((Condition)$1);
      $$ = list;
    }
  | cond ',' cond_list { 
      ConditionList list = (ConditionList)$3;
      list.addCondition((Condition)$1);
      $$ = list;
    }
  ;

cond
  : I operador_comp expr { $$ = new Condition('i', (String)$2, (int)$3); }
  | J operador_comp expr { $$ = new Condition('j', (String)$2, (int)$3); }
  | I IGUAL expr { $$ = new Condition('i', "=", (int)$3); }
  | J IGUAL expr { $$ = new Condition('j', "=", (int)$3); }
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

operador_comp
  : MENOR { $$ = "<"; }
  | MENOR_IGUAL { $$ = "<="; }
  | MAYOR { $$ = ">"; }
  | MAYOR_IGUAL { $$ = ">="; }
  | DISTINTO { $$ = "!="; }
  ;

expr
  : expr SUMA term { $$ = (int)$1 + (int)$3; }
  | expr RESTA term { $$ = (int)$1 - (int)$3; }
  | term { $$ = $1; }
  ;

term
  : term PROD factor { $$ = (int)$1 * (int)$3; }
  | term DIV factor { $$ = (int)$1 / (int)$3; }
  | factor { $$ = $1; }
  ;

factor
  : CONSTANT { $$ = $1; }
  | '(' expr ')' { $$ = $2; }
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

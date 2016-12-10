grammar Nub;

program returns [AstNode.Expression e]
   : v=toplevels[new java.util.ArrayList<AstNode.Expression>()] {$e = new AstNode.ExpressionList($v.e); }
   ;

toplevels[List<AstNode.Expression> es] returns [List<AstNode.Expression> e]
   : (v=toplevel {$es.add($v.e);})+ {$e = $es;}
   ;

toplevel returns [AstNode.Expression e]
   : w=letExpression {$e = $w.e;}
   | v=lineExpression {$e = $v.e;}
   | x=printExpression {$e = $x.e;}
   ;

lineExpression returns [AstNode.Expression e]
   : v=expression SEMICOLON {$e = $v.e;}
   ;

letExpression returns [AstNode.LetExpression e]
    : LET name=IDENTIFIER EQ v=expression SEMICOLON {$e = new AstNode.LetExpression($name.getText(), $v.e);}
    ;

printExpression returns[AstNode.PrintExpression e]
    : PRINT LP v=expression RP SEMICOLON {$e = new AstNode.PrintExpression($v.e);}
    ;

expression returns [AstNode.Expression e]
    : v=conditional {$e = $v.e;}
    ;

conditional returns [AstNode.Expression e]
    : l=conditional op='<=' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='>=' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='<' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='>' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='==' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='!=' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='&&' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=conditional op='||' r=additive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | v=additive {$e = $v.e;}
    ;

additive returns [AstNode.Expression e]
    : l=additive op='+' r=multitive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=additive op='-' r=multitive {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | v=multitive {$e = $v.e;}
    ;

multitive returns [AstNode.Expression e]
    : l=multitive op='*' r=primary {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | l=multitive op='/' r=primary {$e = new AstNode.BinaryOperation($op.getText(), $l.e, $r.e);}
    | v=primary {$e = $v.e;}
    ;

primary returns [AstNode.Expression e]
    : v=identifier {$e = $v.e;}
    | n=NUMBER {$e = new AstNode.Number(Integer.parseInt($n.getText()));}
    | '(' x=expression ')' {$e = $x.e;}
    ;

identifier returns [AstNode.Identifier e]
    : i=IDENTIFIER {$e = new AstNode.Identifier($i.getText());}
    ;

fragment ESC :   '\\' (["\\/bfnrt] | UNICODE) ;
fragment UNICODE : 'u' HEX HEX HEX HEX ;
fragment HEX : [0-9a-fA-F] ;

PRINT
    : 'print'
    ;

LET
    : 'let'
    ;

IN
    : 'in'
    ;

IDENTIFIER
   : IDENTIFIER_START IDENTIFIER_PART*
   ;

fragment IDENTIFIER_START
   : 'a'..'z'
   | 'A'..'Z'
   | '_'
   ;

fragment IDENTIFIER_PART
   : IDENTIFIER_START
   | '0'..'9'
   ;

EQ
   : '='
   ;

LP
   : '('
   ;

RP : ')'
   ;

NUMBER
    : '-'? INT
    ;

SEMICOLON
    : ';'
    ;

fragment INT :   '0' | [1-9] [0-9]* ; // no leading zeros

WS  :   [ \t\n\r]+ -> skip ;
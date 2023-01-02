/* predicate play/0 calls predicates explain and menu */
play/0:- explain, menu.

/* predicate explain prints the game rules*/
explain:-
    nl, nl,
    write('1st PHASE (DROP) - On each turn, each player drops a stone from the reserve to any empty space on the board which is not adjacent (orthogonal) to a friendly stone. If a player cannot drop more stones, he must pass. This continues until all stones are placed on the board, or no more stones can be dropped.'),
    nl, nl,
    write('2nd PHASE (MOVE) - On each turn, each player moves a stone to an empty adjacent (orthogonal) cell. If he is able to make 3 in a rows (not more or less) he may capture one enemy stone.'),
    nl, nl,
    write('GOAL - Wins the player who captures all of his opponents stones'),
    nl, nl.

/* predicate menu prints an interface that presents to the user the diferent game modes and the input is passed to predicate chooseGame */
menu:-
    nl, nl,
    write('Choose a playing mode by entering the number followed by a dot.'),
    nl,
    write('1 - H/H'), nl, write('2 - H/PC'), nl, write('3 - PC/H'), nl, write('4 - PC/PC'),
    nl, nl,
    read(N), nl, chooseGame(N), nl, nl.

/* predicate chooseGame takes the option chosen by the user and calls the respective predicate (NOT FINISHED!) */
chooseGame(X):-
    X==1 -> phaseOne([' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],1);
    X==2 -> phaseTwo([' ','X','O','X','X',' ',' ',' ',' ','O','O',' ','O',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],1);
    X==3 -> phaseOne(['X',' ','O',' ','X',' ','O',' ','X',' ','O',' ','X',' ','O',' ','X',' ','O',' ','X',' ','O',' ','X',' ','O',' ','X',' '],1);
    X==4 -> phaseTwo(['X',' ','X',' ',' ','X',' ',' ',' ',' ',' ',' ',' ','O',' ',' ',' ',' ',' ','X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],1).

/* predicate draw receives a Board and prints it in the correct scale (5x6) */
draw([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]):- nl, nl, write([A,B,C,D,E,F]), nl, write([G,H,I,J,K,L]), nl, write([M,N,O,P,Q,R]), nl, write([S,T,U,V,W,X]), nl, write([Y,Z,AA,AB,AC,AD]), nl, nl.

/* predicate testPlayerMoves tests if there are still legal moves left for each player */
testPlayerMoves(Board,Player):-
    Player==1 -> testPlayerMovesX(Board,1);
    Player==2 -> testPlayerMovesO(Board,2).

/* predicate testPlayerMovesX tests if there are still legal moves left for player 1 */
testPlayerMovesX(Board,Player):- valid_moves(Board,Player) -> write(''); write('No valid moves left for Player 1!'), phaseOne(Board,2).

/* predicate testPlayerMovesO tests if there are still legal moves left for player 2 */
testPlayerMovesO(Board,Player):- valid_moves(Board,Player) -> write(''); write('No valid moves left for Player 2!'), phaseOne(Board,1).

/* predicate testBoard tests if there are any available moves left for either player by calling the predicate valid_moves */
testBoard(Board):- valid_moves(Board,2); valid_moves(Board,1).

/* predicate phaseOne resembles the first phase of the game and it's called recursively acting like a loop */
/* prints the information of the phase, draws the board, asks the player to place a stone, checks the availability of such space and places it */
phaseOne(Board,Player):-
    testBoard(Board) ->(
    nl, nl,
    write('1st PHASE - DROP'),
    draw(Board),
    write('Player '), write(Player), write(', choose a space to place a stone.'),
    nl, nl,
    testPlayerMoves(Board,Player),
    write('Line: '), read(Line),
    nl,
    write('Column: '), read(Col),
    nl,
    Cell is (Line - 1) * 6 + Col,
    legal(Board,Cell,Player) -> place(Board,Cell,Player); write('Illegal place.'), phaseOne(Board,Player));
    phaseTwo(Board,1).

/* predicate phaseTwo resembles the seconde phase of the game and it's called recursively acting like a loop */
/* prints the information of the phase, draws the board, asks the player to move a stone */
phaseTwo(Board,Player):-
    testBoardWin(Board) -> win(Board);
    nl, nl,
    write('2nd PHASE - MOVE'),
    draw(Board),
    write('Player '), write(Player), write(', choose a stone to move.'),
    nl, nl,
    write('Line: '), read(Line),
    nl,
    write('Column: '), read(Col),
    Cell is (Line - 1) * 6 + Col,
    nl,
    write('Move (w,a,s,d): '), read(Move),
    nl,
    move(Board,Cell,Move,Player).

/* predicate phaseThree is called after a three in a row is found and that player can capture an enemy stone */
/* prints the information of the phase and "eats" the stone the player wants to capture */
phaseThree(Board,Player):-
    draw(Board),
    write('Player '), write(Player), write(', choose an opponent stone to capture.'),
    nl, nl,
    write('Line: '), read(Line),
    nl,
    write('Column: '), read(Col),
    Cell is (Line - 1) * 6 + Col,
    nl, nl,
    eat(Board,Cell,Player).

/* predicate eat captures the desired stone making sure it's an enemy stone and not an empty space */
eat(Board,Cell,Player):-
    Player==1 -> capture('O',Board, Cell, NewBoard), checkSameBoard(Board,NewBoard,1,2);
    Player==2 -> capture('X',Board, Cell, NewBoard), checkSameBoard(Board,NewBoard,2,1).

/* predicate checkSameBoard checks if there were any changes to the board after capturing a stone */
/* if an ilegal move was detected when capturing a stone, the board wont change and phaseThree has to be called again */
checkSameBoard(Board,NewBoard,Player,NewPlayer):- Board==NewBoard -> phaseThree(Board,Player); phaseTwo(NewBoard,NewPlayer).

/* predicate legal calls predicate valid with different arguments based on the player */
legal(Board,Cell,Player):-
    Player==1 -> valid(Board,Cell,'X');
    Player==2 -> valid(Board,Cell,'O').
        
/* predicate place calls the specific predicates to place a stone and returns to phaseOne */
place(Board, Cell, Player):-
    Player==1 -> xplace(Board, Cell, NewBoard, NewPlayer), phaseOne(NewBoard,NewPlayer);
    Player==2 -> oplace(Board, Cell, NewBoard, NewPlayer), phaseOne(NewBoard,NewPlayer).

/* predicate move calls the specific predicates to move a stone and calls predicate checkThreeRow the checks if a three in a row has occured */
move(Board, Cell, Move, Player):-
    Player==1 -> xmove(Board, Cell, Move, NewBoard, NewPlayer), checkThreeRow(NewBoard,Player,NewPlayer);
    Player==2 -> omove(Board, Cell, Move, NewBoard, NewPlayer), checkThreeRow(NewBoard,Player,NewPlayer).

checkThreeRow(Board,Player,NewPlayer):- threeRow(Board,Player) -> phaseThree(Board,Player); phaseTwo(Board,NewPlayer).

/*
Example Board:
A  B  C  D  E  F
G  H  I  J  K  L
M  N  O  P  Q  R
S  T  U  V  W  X
Y  Z AA AB AC AD
*/

/* predicate win exits the program */
win(Board):- nl,nl,abort.

/*predicate testBoardWin checks if either player has won the game*/
testBoardWin(Board):-
    owin(Board) -> draw(Board), write('Player 2 WINS!');
    xwin(Board) -> draw(Board), write('Player 1 WINS!').

/*predicate owin checks if there are any stones left from player 1*/
owin([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]):-
    A\='X',
    B\='X',
    C\='X', 
    D\='X',
    E\='X',
    F\='X',
    G\='X',
    H\='X',
    I\='X',
    J\='X',
    K\='X',
    L\='X',
    M\='X',
    N\='X',
    O\='X',
    P\='X',
    Q\='X',
    R\='X',
    S\='X',
    T\='X',
    U\='X',
    V\='X',
    W\='X',
    X\='X',
    Y\='X',
    Z\='X',
    AA\='X',
    AB\='X',
    AC\='X',
    AD\='X'.

/*predicate own checks if there are any stones left from player 2*/    
xwin([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]):-
    A\='O',
    B\='O',
    C\='O',
    D\='O',
    E\='O',
    F\='O',
    G\='O',
    H\='O',
    I\='O',
    J\='O',
    K\='O',
    L\='O',
    M\='O',
    N\='O',
    O\='O',
    P\='O',
    Q\='O',
    R\='O',
    S\='O',
    T\='O',
    U\='O',
    V\='O',
    W\='O',
    X\='O',
    Y\='O',
    Z\='O',
    AA\='O',
    AB\='O',
    AC\='O',
    AD\='O'.

/*predicate valid_moves checks if there are any legal moves for a player*/
valid_moves(Board,Player) :-
    legal(Board,1,Player);
    legal(Board,2,Player);
    legal(Board,3,Player);
    legal(Board,4,Player);
    legal(Board,5,Player);
    legal(Board,6,Player);
    legal(Board,7,Player);
    legal(Board,8,Player);
    legal(Board,9,Player);
    legal(Board,10,Player);
    legal(Board,11,Player);
    legal(Board,12,Player);
    legal(Board,13,Player);
    legal(Board,14,Player);
    legal(Board,15,Player);
    legal(Board,16,Player);
    legal(Board,17,Player);
    legal(Board,18,Player);
    legal(Board,19,Player);
    legal(Board,20,Player);
    legal(Board,21,Player);
    legal(Board,22,Player);
    legal(Board,23,Player);
    legal(Board,24,Player);
    legal(Board,25,Player);
    legal(Board,26,Player);
    legal(Board,27,Player);
    legal(Board,28,Player);
    legal(Board,29,Player);
    legal(Board,30,Player).

/* predicate threeRow searches the board for a three in a row, line by line and column by column */
threeRow(Board, Player) :- Player==1 -> linethreeRow(Board, 'X', 'O'); Player==2 -> linethreeRow(Board, 'O', 'X').
threeRow(Board, Player) :- Player==1 -> colthreeRow(Board, 'X', 'O'); Player==2 -> colthreeRow(Board, 'O', 'X').

/* predicate linethreeRow searches all the options for a three in a row in any line */
linethreeRow(Board, Player, OtherPlayer) :- Board = [Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [' ',Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,' ',Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,' ',Player,Player,Player,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,OtherPlayer,Player,Player,Player,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,' ',Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,' ',Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,' ',Player,Player,Player,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,_,_,_,_,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Player,Player,Player,' ',_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,' ',_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,' ',_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,_,_,_,_,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Player,Player,Player,' ',_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Player,Player,Player,OtherPlayer,_,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,' ',_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' ',_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer,_].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,' '].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,' '].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player,OtherPlayer].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player,OtherPlayer].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,' ',Player,Player,Player].
linethreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,Player,Player,Player].

/* predicate colthreeRow searches all the options for a three in a row in any column */
colthreeRow(Board, Player, OtherPlayer) :- Board = [Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' '].
colthreeRow(Board, Player, OtherPlayer) :- Board = [OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' ',_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,' '].
colthreeRow(Board, Player, OtherPlayer) :- Board = [' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer].
colthreeRow(Board, Player, OtherPlayer) :- Board = [OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,OtherPlayer].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,' ',_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player,_].
colthreeRow(Board, Player, OtherPlayer) :- Board = [_,_,_,_,_,_,_,_,_,_,_,OtherPlayer,_,_,_,_,_,Player,_,_,_,_,_,Player,_,_,_,_,_,Player].

/* predicate xmove changes the board acording to the arguments received to move a stone from player 1 ('X')*/
xmove(['X',' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, 'd', [' ','X',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove(['X',B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, 's', [' ',B,C,D,E,F,'X',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([' ','X',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, 'a', ['X',' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,'X',C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, 's', [A,' ',C,D,E,F,G,'X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,'X',' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, 'd', [A,' ','X',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,' ','X',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, 'a', [A,'X',' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,'X',D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, 's', [A,B,' ',D,E,F,G,H,'X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,'X',' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, 'd', [A,B,' ','X',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,' ','X',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, 'a', [A,B,'X',' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,'X',E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, 's', [A,B,C,' ',E,F,G,H,I,'X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,'X',' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, 'd', [A,B,C,' ','X',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,' ','X',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, 'a', [A,B,C,'X',' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,'X',F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, 's', [A,B,C,D,' ',F,G,H,I,J,'X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,'X',' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, 'd', [A,B,C,D,' ','X',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,' ','X',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, 'a', [A,B,C,D,'X',' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,'X',G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, 's', [A,B,C,D,E,' ',G,H,I,J,K,'X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([' ',B,C,D,E,F,'X',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, 'w', ['X',B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,'X',H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, 's', [A,B,C,D,E,F,' ',H,I,J,K,L,'X',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,'X',' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, 'd', [A,B,C,D,E,F,' ','X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,' ',C,D,E,F,G,'X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 'w', [A,'X',C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,'X',I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 's', [A,B,C,D,E,F,G,' ',I,J,K,L,M,'X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,'X',' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 'd', [A,B,C,D,E,F,G,' ','X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,' ','X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 'a', [A,B,C,D,E,F,'X',' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,' ',D,E,F,G,H,'X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 'w', [A,B,'X',D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,'X',J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 's', [A,B,C,D,E,F,G,H,' ',J,K,L,M,N,'X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,'X',' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 'd', [A,B,C,D,E,F,G,H,' ','X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,' ','X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 'a', [A,B,C,D,E,F,G,'X',' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,' ',E,F,G,H,I,'X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 'w', [A,B,C,'X',E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,'X',K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 's', [A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,'X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,'X',' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 'd', [A,B,C,D,E,F,G,H,I,' ','X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,' ','X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 'a', [A,B,C,D,E,F,G,H,'X',' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,' ',F,G,H,I,J,'X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 'w', [A,B,C,D,'X',F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,'X',L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 's', [A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,'X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,'X',' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 'd', [A,B,C,D,E,F,G,H,I,J,' ','X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,' ','X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 'a', [A,B,C,D,E,F,G,H,I,'X',' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,' ',G,H,I,J,K,'X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, 'w', [A,B,C,D,E,'X',G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,'X',M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, 's', [A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,'X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,' ','X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, 'a', [A,B,C,D,E,F,G,H,I,J,'X',' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,' ',H,I,J,K,L,'X',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, 'w', [A,B,C,D,E,F,'X',H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,'X',N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, 's', [A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,'X',T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,'X',' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,' ','X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,' ',I,J,K,L,M,'X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 'w', [A,B,C,D,E,F,G,'X',I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,'X',O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,'X',U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,'X',' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,' ','X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,' ','X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,'X',' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,'X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, 'w', [A,B,C,D,E,F,G,H,'X',J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 15, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,'X',V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ','X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ','X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,'X',' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,'X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, 'w', [A,B,C,D,E,F,G,H,I,'X',K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 16, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,'X',W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ','X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ','X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,'X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, 'w', [A,B,C,D,E,F,G,H,I,J,'X',L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 17, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,'X',X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ','X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ','X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,'X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, 'w', [A,B,C,D,E,F,G,H,I,J,K,'X',M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'X',S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 18, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,'X',Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ','X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,'X',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,'X',N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',T,U,V,W,X,' ',Z,AA,AB,AC,AD], 19, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,'X',Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 19, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ','X',U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,'X',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,'X',O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',U,V,W,X,Y,' ',AA,AB,AC,AD], 20, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,'X',AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',' ',V,W,X,Y,Z,AA,AB,AC,AD], 20, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ','X',V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ','X',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',' ',U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,'X',V,W,X,Y,Z,AA,AB,AC,AD], 21, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',V,W,X,Y,Z,' ',AB,AC,AD], 21, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,'X',AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',' ',W,X,Y,Z,AA,AB,AC,AD], 21, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ','X',W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ','X',V,W,X,Y,Z,AA,AB,AC,AD], 21, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',' ',V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,'X',W,X,Y,Z,AA,AB,AC,AD], 22, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',W,X,Y,Z,AA,' ',AC,AD], 22, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,'X',AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',' ',X,Y,Z,AA,AB,AC,AD], 22, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ','X',X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ','X',W,X,Y,Z,AA,AB,AC,AD], 22, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',' ',W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,'X',X,Y,Z,AA,AB,AC,AD], 23, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',X,Y,Z,AA,AB,' ',AD], 23, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,'X',AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',' ',Y,Z,AA,AB,AC,AD], 23, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ','X',Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ','X',X,Y,Z,AA,AB,AC,AD], 23, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',' ',X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,'X',Y,Z,AA,AB,AC,AD], 24, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'X',S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'X',Y,Z,AA,AB,AC,' '], 24, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,'X'],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ','X',Y,Z,AA,AB,AC,AD], 24, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',' ',Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,'X',Z,AA,AB,AC,AD], 25, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',T,U,V,W,X,' ',Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'X',' ',AA,AB,AC,AD], 25, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ','X',AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,'X',AA,AB,AC,AD], 26, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',U,V,W,X,Y,' ',AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'X',' ',AB,AC,AD], 26, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ','X',AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ','X',AA,AB,AC,AD], 26, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'X',' ',AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,'X',AB,AC,AD],  27, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',V,W,X,Y,Z,' ',AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'X',' ',AC,AD],  27, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ','X',AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ','X',AB,AC,AD],  27, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'X',' ',AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,'X',AC,AD],  28, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',W,X,Y,Z,AA,' ',AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'X',' ',AD],  28, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ','X',AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ','X',AC,AD],  28, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'X',' ',AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,'X',AD],  29, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',X,Y,Z,AA,AB,' ',AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'X',' '],  29, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ','X'],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ','X',AD],  29, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'X',' ',AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,'X'],  30, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'X',Y,Z,AA,AB,AC,' '],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ','X'],  30, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'X',' '],2).
xmove(Board, _, _, Board,1) :- write('Illegal move.').

/* predicate omove changes the board acording to the arguments received to move a stone from player 2 ('O')*/
omove(['O',' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, 'd', [' ','O',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove(['O',B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, 's', [' ',B,C,D,E,F,'O',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([' ','O',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, 'a', ['O',' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,'O',C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, 's', [A,' ',C,D,E,F,G,'O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,'O',' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, 'd', [A,' ','O',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,' ','O',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, 'a', [A,'O',' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,'O',D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, 's', [A,B,' ',D,E,F,G,H,'O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,'O',' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, 'd', [A,B,' ','O',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,' ','O',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, 'a', [A,B,'O',' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,'O',E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, 's', [A,B,C,' ',E,F,G,H,I,'O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,'O',' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, 'd', [A,B,C,' ','O',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,' ','O',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, 'a', [A,B,C,'O',' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,'O',F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, 's', [A,B,C,D,' ',F,G,H,I,J,'O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,'O',' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, 'd', [A,B,C,D,' ','O',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,' ','O',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, 'a', [A,B,C,D,'O',' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,'O',G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, 's', [A,B,C,D,E,' ',G,H,I,J,K,'O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([' ',B,C,D,E,F,'O',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, 'w', ['O',B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,'O',H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, 's', [A,B,C,D,E,F,' ',H,I,J,K,L,'O',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,'O',' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, 'd', [A,B,C,D,E,F,' ','O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,' ',C,D,E,F,G,'O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 'w', [A,'O',C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,'O',I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 's', [A,B,C,D,E,F,G,' ',I,J,K,L,M,'O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,'O',' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 'd', [A,B,C,D,E,F,G,' ','O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,' ','O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, 'a', [A,B,C,D,E,F,'O',' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,' ',D,E,F,G,H,'O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 'w', [A,B,'O',D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,'O',J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 's', [A,B,C,D,E,F,G,H,' ',J,K,L,M,N,'O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,'O',' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 'd', [A,B,C,D,E,F,G,H,' ','O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,' ','O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, 'a', [A,B,C,D,E,F,G,'O',' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,' ',E,F,G,H,I,'O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 'w', [A,B,C,'O',E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,'O',K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 's', [A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,'O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,'O',' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 'd', [A,B,C,D,E,F,G,H,I,' ','O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,' ','O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, 'a', [A,B,C,D,E,F,G,H,'O',' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,' ',F,G,H,I,J,'O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 'w', [A,B,C,D,'O',F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,'O',L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 's', [A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,'O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,'O',' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 'd', [A,B,C,D,E,F,G,H,I,J,' ','O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,' ','O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, 'a', [A,B,C,D,E,F,G,H,I,'O',' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,' ',G,H,I,J,K,'O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, 'w', [A,B,C,D,E,'O',G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,'O',M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, 's', [A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,'O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,' ','O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, 'a', [A,B,C,D,E,F,G,H,I,J,'O',' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,' ',H,I,J,K,L,'O',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, 'w', [A,B,C,D,E,F,'O',H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,'O',N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, 's', [A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,'O',T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,'O',' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,' ','O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,' ',I,J,K,L,M,'O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 'w', [A,B,C,D,E,F,G,'O',I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,'O',O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,'O',U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,'O',' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,' ','O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,' ','O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,'O',' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,'O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, 'w', [A,B,C,D,E,F,G,H,'O',J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 15, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,'O',V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ','O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ','O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,'O',' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,'O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, 'w', [A,B,C,D,E,F,G,H,I,'O',K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 16, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,'O',W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ','O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ','O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,'O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, 'w', [A,B,C,D,E,F,G,H,I,J,'O',L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 17, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,'O',X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ','O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ','O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,'O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, 'w', [A,B,C,D,E,F,G,H,I,J,K,'O',M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'O',S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 18, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,'O',Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ','O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,'O',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,'O',N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',T,U,V,W,X,' ',Z,AA,AB,AC,AD], 19, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,'O',Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 19, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ','O',U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,'O',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,'O',O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',U,V,W,X,Y,' ',AA,AB,AC,AD], 20, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,'O',AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',' ',V,W,X,Y,Z,AA,AB,AC,AD], 20, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ','O',V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ','O',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',' ',U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,'O',V,W,X,Y,Z,AA,AB,AC,AD], 21, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',V,W,X,Y,Z,' ',AB,AC,AD], 21, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,'O',AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',' ',W,X,Y,Z,AA,AB,AC,AD], 21, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ','O',W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ','O',V,W,X,Y,Z,AA,AB,AC,AD], 21, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',' ',V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,'O',W,X,Y,Z,AA,AB,AC,AD], 22, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',W,X,Y,Z,AA,' ',AC,AD], 22, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,'O',AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',' ',X,Y,Z,AA,AB,AC,AD], 22, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ','O',X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ','O',W,X,Y,Z,AA,AB,AC,AD], 22, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',' ',W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,'O',X,Y,Z,AA,AB,AC,AD], 23, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',X,Y,Z,AA,AB,' ',AD], 23, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,'O',AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',' ',Y,Z,AA,AB,AC,AD], 23, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ','O',Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ','O',X,Y,Z,AA,AB,AC,AD], 23, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',' ',X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,'O',Y,Z,AA,AB,AC,AD], 24, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'O',S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'O',Y,Z,AA,AB,AC,' '], 24, 's', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,'O'],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ','O',Y,Z,AA,AB,AC,AD], 24, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',' ',Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,'O',Z,AA,AB,AC,AD], 25, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',T,U,V,W,X,' ',Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'O',' ',AA,AB,AC,AD], 25, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ','O',AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,'O',AA,AB,AC,AD], 26, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',U,V,W,X,Y,' ',AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'O',' ',AB,AC,AD], 26, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ','O',AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ','O',AA,AB,AC,AD], 26, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'O',' ',AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,'O',AB,AC,AD],  27, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',V,W,X,Y,Z,' ',AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'O',' ',AC,AD],  27, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ','O',AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ','O',AB,AC,AD],  27, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'O',' ',AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,'O',AC,AD],  28, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',W,X,Y,Z,AA,' ',AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'O',' ',AD],  28, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ','O',AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ','O',AC,AD],  28, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'O',' ',AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,'O',AD],  29, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',X,Y,Z,AA,AB,' ',AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'O',' '],  29, 'd', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ','O'],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ','O',AD],  29, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'O',' ',AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,'O'],  30, 'w', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'O',Y,Z,AA,AB,AC,' '],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ','O'],  30, 'a', [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'O',' '],1).
omove(Board, _, _, Board,2) :- write('Illegal move.').

/*predicate valid checks if a certain move can be played*/
valid([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],Cell,Player):-
    Cell==1 -> B\=Player, G\=Player, H\=Player, A==' ';
    Cell==2 -> A\=Player, G\=Player, H\=Player, I\=Player, C\=Player, B== ' ';
    Cell==3 -> B\=Player, I\=Player, H\=Player, J\=Player, D\=Player, C== ' ';
    Cell==4 -> C\=Player, E\=Player, I\=Player,J\=Player,K\=Player, D== ' ';
    Cell==5 -> D\=Player, F\=Player, J\=Player, K\=Player,L\=Player, E== ' ';
    Cell==6 -> E\=Player, K\=Player, L\=Player, F== ' ';
    Cell==7 -> A\=Player, B\=Player, H\=Player,M\=Player,N\=Player, G== ' ';
    Cell==8 -> A\=Player, B\=Player, C\=Player, G\=Player, I\=Player, M\=Player, N\=Player, O\=Player,H== ' ';
    Cell==9 -> B\=Player, C\=Player, D\=Player, H\=Player, J\=Player, N\=Player, O\=Player, P\=Player,I== ' ';
    Cell==10 -> C\=Player, I\=Player, O\=Player, P\=Player, Q\=Player, K\=Player, E\=Player, D\=Player,J== ' ';
    Cell==11-> D\=Player, E\=Player, F\=Player, J\=Player, L\=Player, P\=Player, Q\=Player, R\=Player,K== ' ';
    Cell==12 -> E\=Player, F\=Player, K\=Player, Q\=Player, R\=Player,L== ' ';
    Cell==13 -> G\=Player, H\=Player, N\=Player, S\=Player, T\=Player,M== ' ';
    Cell==14 -> G\=Player, H\=Player, I\=Player, M\=Player, O\=Player, S\=Player, T\=Player, U\=Player,N== ' ';
    Cell==15 -> H\=Player, I\=Player, J\=Player, N\=Player, P\=Player, T\=Player, U\=Player, V\=Player,O== ' ';
    Cell==16 -> I\=Player, J\=Player, K\=Player, O\=Player, Q\=Player, U\=Player, V\=Player, W\=Player,P== ' ';
    Cell==17 -> J\=Player, K\=Player, L\=Player, P\=Player, R\=Player, V\=Player, W\=Player, X\=Player,Q== ' ';
    Cell==18 -> K\=Player, L\=Player, Q\=Player, W\=Player, X\=Player,R== ' ';
    Cell==19 -> M\=Player, N\=Player, T\=Player, Y\=Player, Z\=Player,S== ' ';
    Cell==20 -> M\=Player, N\=Player, O\=Player, S\=Player, U\=Player, Y\=Player, Z\=Player, AA\=Player,T== ' ';
    Cell==21 -> N\=Player, O\=Player, P\=Player, T\=Player, V\=Player, Z\=Player, AA\=Player, AB\=Player,U== ' ';
    Cell==22 -> O\=Player, P\=Player, Q\=Player, U\=Player, W\=Player, AA\=Player, AB \=Player, AC\=Player,V== ' ';
    Cell==23 -> P\=Player, Q\=Player, R\=Player, V\=Player, X\=Player, AB\=Player, AC\=Player, AD\=Player,W== ' ';
    Cell==24 -> Q\=Player, R\=Player, W\=Player, AC\=Player, AD\=Player,X== ' ';
    Cell==25-> S\=Player, T\=Player, Z\=Player,Y== ' ';
    Cell==26 -> S\=Player, T\=Player, U\=Player, Y\=Player, AA\=Player,Z== ' ';
    Cell==27 -> AB\=Player, V\=Player, U\=Player, T\=Player, Z\=Player,AA== ' ';
    Cell==28 -> AC\=Player, W\=Player, V\=Player, U\=Player, AA\=Player,AB== ' ';
    Cell==29 -> AD\=Player, X\=Player, W\=Player, AB\=Player, V\=Player,AC== ' ';
    Cell==30 -> X\=Player, W\=Player, AC\=Player,AD== ' '.    

/*Predicates xplace, places a stone on a specific cell for the first player*/
xplace([' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, ['X',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,'X',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,'X',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,'X',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,'X',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,'X',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,'X',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,'X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,'X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,'X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,'X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,'X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,'X',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,'X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',V,W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',W,X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',X,Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'X',Y,Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'X',Z,AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'X',AA,AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'X',AB,AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'X',AC,AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'X',AD],2).
xplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' '],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,'X'],2).
xplace(Board, _, Board,1) :- write('Illegal place.').

/*Predicates oplace, places a stone on a specific cell for the second player*/
oplace([' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, ['O',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,'O',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,'O',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,'O',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,'O',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,'O',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,'O',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,'O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,'O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,'O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,'O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,'O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,'O',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,'O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',U,V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',V,W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',W,X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',X,Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'O',Y,Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'O',Z,AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'O',AA,AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'O',AB,AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'O',AC,AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'O',AD],1).
oplace([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' '],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,'O'],1).
oplace(Board, _, Board,2) :- write('Illegal place.').

/*predicate capture, deletes a stone from one of the players*/
capture(Player,[Player,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, [' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,Player,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,Player,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,Player,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,Player,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,Player,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,Player,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,Player,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,Player,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,Player,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,Player,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,Player,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,Player,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,Player,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,Player,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,Player,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Player,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,Player,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,Player,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,Player,U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,Player,V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,Player,W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,Player,X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,Player,Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Player,Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Player,AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,Player,AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,Player,AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,Player,AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD]).
capture(Player,[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,Player],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' ']).
capture(Player,Board, _, Board) :- write('Illegal stone.').
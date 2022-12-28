play/0:- explain, menu.

explain:-
    nl, nl,
    write('1st PHASE (DROP) - On each turn, each player drops a stone from the reserve to any empty space on the board which is not adjacent (orthogonal) to a friendly stone. If a player cannot drop more stones, he must pass. This continues until all stones are placed on the board, or no more stones can be dropped.'),
    nl, nl,
    write('2nd PHASE (MOVE) - On each turn, each player moves a stone to an empty adjacent (orthogonal) cell. If he is able to make 3 in a rows (not more or less) he may capture one enemy stone.'),
    nl, nl,
    write('GOAL - Wins the player who capture all of his opponents stones'),
    nl, nl.

menu:-
    nl, nl,
    write('Choose a playing mode by entering the number followed by a dot.'),
    nl,
    write('1 - H/H'), nl, write('2 - H/PC'), nl, write('3 - PC/H'), nl, write('4 - PC/PC'),
    nl, nl,
    read(N), nl, chooseGame(N), nl, nl.

chooseGame(X):-
    X==1 -> phaseOne([' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],1);
    X==2 -> humanPc;
    X==3 -> pcHuman;
    X==4 -> pcPc.

draw([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]):- nl, nl, write([A,B,C,D,E,F]), nl, write([G,H,I,J,K,L]), nl, write([M,N,O,P,Q,R]), nl, write([S,T,U,V,W,X]), nl, write([Y,Z,AA,AB,AC,AD]), nl, nl.

phaseOne(Board,Player):-
    nl, nl,
    write('1st PHASE - DROP'),
    draw(Board),
    write('Player '), write(Player), write(', choose a space to place a stone.'),
    nl, nl,
    write('Line: '), read(Line),
    nl,
    write('Column: '), read(Col),
    nl, nl,
    Cell is (Line - 1) * 6 + Col,
    legal(Board,Cell,Player) -> move(Board,Cell,Player); write('Illegal move.'), phaseOne(Board,Player).
    % NICE

/*
A B C D E F
G H I J K L
M N O P Q R
S T U V W X
Y Z AA AB AC AD
*/

xlegal([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],Cell,Player):-
    Cell==1 -> B\='X', G\='X', H\='X';
    Cell==2 -> A\='X', G\='X', H\='X', I\='X', C\='X';
    Cell==3 -> B\='X', I\='X', H\='X', J\='X', D\='X';
    Cell==4 -> C\='X', E\='X', I\='X',J\='X',K\='X';
    Cell==5 -> D\='X', F\='X', J\='X', K\='X',L\='X';
    Cell==6 -> E\='X', K\='X', L\='X';
    Cell==7 -> A\='X', B\='X', H\='X',M\='X',N\='X';
    Cell==8 -> A\='X', B\='X', C\='X', G\='X', I\='X', M\='X', N\='X', O\='X';
    Cell==9 -> B\='X', C\='X', D\='X', H\='X', J\='X', N\='X', O\='X', P\='X';
    Cell==10 -> C\='X', I\='X', O\='X', P\='X', Q\='X', K\='X', E\='X', D\='X';
    Cell==11-> D\='X', E\='X', F\='X', J\='X', L\='X', P\='X', Q\='X', R\='X';
    Cell==12 -> E\='X', F\='X', K\='X', Q\='X', R\='X';
    Cell==13 -> G\='X', H\='X', N\='X', S\='X', T\='X';
    Cell==14 -> G\='X', H\='X', I\='X', M\='X', O\='X', S\='X', T\='X', U\='X';
    Cell==15 -> H\='X', I\='X', J\='X', N\='X', P\='X', T\='X', U\='X', V\='X';
    Cell==16 -> I\='X', J\='X', K\='X', O\='X', Q\='X', U\='X', V\='X', W\='X';
    Cell==17 -> J\='X', K\='X', L\='X', P\='X', R\='X', V\='X', W\='X', X\='X';
    Cell==18 -> K\='X', L\='X', Q\='X', W\='X', X\='X';
    Cell==19 -> M\='X', N\='X', T\='X', Y\='X', Z\='X';
    Cell==20 -> M\='X', N\='X', O\='X', S\='X', U\='X', Y\='X', Z\='X', AA\='X';
    Cell==21 -> N\='X', O\='X', P\='X', T\='X', V\='X', Z\='X', AA\='X', AB\='X';
    Cell==22 -> O\='X', P\='X', Q\='X', U\='X', W\='X', AA\='X', AB \='X', AC\='X';
    Cell==23 -> P\='X', Q\='X', R\='X', V\='X', X\='X', AB\='X', AC\='X', AD\='X';
    Cell==24 -> Q\='X', R\='X', W\='X', AC\='X', AD\='X';
    Cell==25-> S\='X', T\='X', Z\='X';
    Cell==26 -> S\='X', T\='X', U\='X', Y\='X', AA\='X';
    Cell==27 -> AB\='X', V\='X', U\='X', T\='X', Z\='X';
    Cell==28 -> AC\='X', W\='X', V\='X', U\='X', AA\='X';
    Cell==29 -> AD\='X', X\='X', W\='X', AB\='X', V\='X';
    Cell==30 -> X\='X', W\='X', AC\='X'.


olegal([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],Cell,Player):-
    Cell==1 -> B\='O', G\='O', H\='O';
    Cell==2 -> A\='O', G\='O', H\='O', I\='O', C\='O';
    Cell==3 -> B\='O', I\='O', H\='O', J\='O', D\='O';
    Cell==4 -> C\='O', E\='O', I\='O',J\='O',K\='O';
    Cell==5 -> D\='O', F\='O', J\='O', K\='O',L\='O';
    Cell==6 -> E\='O', K\='O', L\='O';
    Cell==7 -> A\='O', B\='O', H\='O',M\='O',N\='O';
    Cell==8 -> A\='O', B\='O', C\='O', G\='O', I\='O', M\='O', N\='O', O\='O';
    Cell==9 -> B\='O', C\='O', D\='O', H\='O', J\='O', N\='O', O\='O', P\='O';
    Cell==10 -> C\='O', I\='O', O\='O', P\='O', Q\='O', K\='O', E\='O', D\='O';
    Cell==11-> D\='O', E\='O', F\='O', J\='O', L\='O', P\='O', Q\='O', R\='O';
    Cell==12 -> E\='O', F\='O', K\='O', Q\='O', R\='O';
    Cell==13 -> G\='O', H\='O', N\='O', S\='O', T\='O';
    Cell==14 -> G\='O', H\='O', I\='O', M\='O', O\='O', S\='O', T\='O', U\='O';
    Cell==15 -> H\='O', I\='O', J\='O', N\='O', P\='O', T\='O', U\='O', V\='O';
    Cell==16 -> I\='O', J\='O', K\='O', O\='O', Q\='O', U\='O', V\='O', W\='O';
    Cell==17 -> J\='O', K\='O', L\='O', P\='O', R\='O', V\='O', W\='O', X\='O';
    Cell==18 -> K\='O', L\='O', Q\='O', W\='O', X\='O';
    Cell==19 -> M\='O', N\='O', T\='O', Y\='O', Z\='O';
    Cell==20 -> M\='O', N\='O', O\='O', S\='O', U\='O', Y\='O', Z\='O', AA\='O';
    Cell==21 -> N\='O', O\='O', P\='O', T\='O', V\='O', Z\='O', AA\='O', AB\='O';
    Cell==22 -> O\='O', P\='O', Q\='O', U\='O', W\='O', AA\='O', AB \='O', AC\='O';
    Cell==23 -> P\='O', Q\='O', R\='O', V\='O', X\='O', AB\='O', AC\='O', AD\='O';
    Cell==24 -> Q\='O', R\='O', W\='O', AC\='O', AD\='O';
    Cell==25-> S\='O', T\='O', Z\='O';
    Cell==26 -> S\='O', T\='O', U\='O', Y\='O', AA\='O';
    Cell==27 -> AB\='O', V\='O', U\='O', T\='O', Z\='O';
    Cell==28 -> AC\='O', W\='O', V\='O', U\='O', AA\='O';
    Cell==29 -> AD\='O', X\='O', W\='O', AB\='O', V\='O';
    Cell==30 -> X\='O', W\='O', AC\='O'.


legal(Board,Cell,Player):-
    Player==1 -> xlegal(Board,Cell,Player);
    Player==2 -> olegal(Board,Cell,Player).
        
    
move(Board, Cell, Player):-
    Player==1 -> xmove(Board, Cell, NewBoard, NewPlayer), phaseOne(NewBoard, NewPlayer);
    Player==2 -> omove(Board, Cell, NewBoard, NewPlayer), phaseOne(NewBoard, NewPlayer).
    

xmove([' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, ['X',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,'X',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,'X',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,'X',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,'X',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,'X',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,'X',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,'X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,'X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,'X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,'X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,'X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,'X',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,'X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',T,U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',U,V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',V,W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',W,X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',X,Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'X',Y,Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'X',Z,AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'X',AA,AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'X',AB,AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'X',AC,AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'X',AD],2).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' '],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,'X'],2).
xmove(Board, _, Board,1) :- write('Illegal move.').


omove([' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, ['O',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,'O',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,'O',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,'O',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,'O',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,'O',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,'O',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,'O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,'O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,'O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,'O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,'O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,'O',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,'O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',T,U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',U,V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',V,W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',W,X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',X,Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'O',Y,Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'O',Z,AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'O',AA,AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'O',AB,AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'O',AC,AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'O',AD],1).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' '],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,'O'],1).
omove(Board, _, Board,2) :- write('Illegal move.').
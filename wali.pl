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
    move(Board, Cell, Player).
    % NICE

move(Board, Cell, Player):-
    Player==1 -> xmove(Board, Cell, NewBoard), phaseOne(NewBoard,2);
    Player==2 -> omove(Board, Cell, NewBoard), phaseOne(NewBoard,1).

xmove([' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, ['X',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,'X',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,'X',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,'X',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,'X',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,'X',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,'X',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,'X',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,'X',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,'X',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,'X',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,'X',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,'X',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,'X',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'X',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'X',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'X',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'X',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'X',T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'X',U,V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'X',V,W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'X',W,X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'X',X,Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'X',Y,Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'X',Z,AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'X',AA,AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'X',AB,AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'X',AC,AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'X',AD]).
xmove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' '],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,'X']).

omove([' ',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 1, ['O',B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,' ',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 2, [A,'O',C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,' ',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 3, [A,B,'O',D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,' ',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 4, [A,B,C,'O',E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,' ',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 5, [A,B,C,D,'O',F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,' ',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 6, [A,B,C,D,E,'O',G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,' ',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 7, [A,B,C,D,E,F,'O',H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,' ',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 8, [A,B,C,D,E,F,G,'O',I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,' ',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 9, [A,B,C,D,E,F,G,H,'O',J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,' ',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 10, [A,B,C,D,E,F,G,H,I,'O',K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,' ',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 11, [A,B,C,D,E,F,G,H,I,J,'O',L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,' ',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 12, [A,B,C,D,E,F,G,H,I,J,K,'O',M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,' ',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 13, [A,B,C,D,E,F,G,H,I,J,K,L,'O',N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,' ',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 14, [A,B,C,D,E,F,G,H,I,J,K,L,M,'O',O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,' ',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 15, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,'O',P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,' ',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 16, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,'O',Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,' ',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 17, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,'O',R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,' ',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD], 18, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,'O',S,T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,' ',T,U,V,W,X,Y,Z,AA,AB,AC,AD], 19, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,'O',T,U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,' ',U,V,W,X,Y,Z,AA,AB,AC,AD], 20, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,'O',U,V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,' ',V,W,X,Y,Z,AA,AB,AC,AD], 21, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,'O',V,W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,' ',W,X,Y,Z,AA,AB,AC,AD], 22, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,'O',W,X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,' ',X,Y,Z,AA,AB,AC,AD], 23, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,'O',X,Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,' ',Y,Z,AA,AB,AC,AD], 24, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,'O',Y,Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,' ',Z,AA,AB,AC,AD], 25, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,'O',Z,AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,' ',AA,AB,AC,AD], 26, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,'O',AA,AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' ',AB,AC,AD],  27, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,'O',AB,AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,' ',AC,AD],  28, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,'O',AC,AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,' ',AD],  29, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,'O',AD]).
omove([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,' '],  30, [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,'O']).
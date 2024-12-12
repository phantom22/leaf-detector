function [LL,LE,LS,LR,LW,EL,EE,ES,ER,EW,SL,SE,SS,SR,SW,RL,RE,RS,RR,RW,WL,WE,WS,WR,WW] = test_law(im)
    L5 = [1 4 6 4 1]; 
    E5 = [-1 -2 0 2 1];
    S5 = [-1 0 2 0 -1];
    R5 = [1 -4 6 -4 1];
    W5 = [-1 2 0 -2 1];

    c2 = @(A,B) conv2(A,B,im,'same').^2;

    %LE,LR,ES,SS,RR,LS,EE,ER,SR

    LL = c2(L5,L5);
    LE = c2(L5,E5);
    LS = c2(L5,S5);
    LR = c2(L5,R5);
    LW = c2(L5,W5);

    EL = c2(E5,L5);
    EE = c2(E5,E5);
    ES = c2(E5,S5);
    ER = c2(E5,R5);
    EW = c2(E5,W5);

    SL = c2(S5,L5);
    SE = c2(S5,E5);
    SS = c2(S5,S5);
    SR = c2(S5,R5);
    SW = c2(S5,W5);

    RL = c2(R5,L5);
    RE = c2(R5,E5);
    RS = c2(R5,S5);
    RR = c2(R5,R5);
    RW = c2(R5,W5);

    WL = c2(W5,L5);
    WE = c2(W5,E5);
    WS = c2(W5,S5);
    WR = c2(W5,R5);
    WW = c2(W5,W5);
end
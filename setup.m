regGrow().compile();

cd('c\');
mex normbins.c
mex binfeatures.c;
mex normglcm.c;
cd('..');
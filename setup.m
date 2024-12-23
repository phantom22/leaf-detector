regGrow().compile();

cd('c\');
mex stripped_binfeatures.c;

cd('old\');
mex normbins.c
mex binfeatures.c;
mex normglcm.c;

cd('..\..');
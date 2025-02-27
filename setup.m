%regGrow().compile();

cd('c\');
mex stripped_binfeatures.c;
mex normglcm.c;
mex glcmfeatures.c;

cd('..');
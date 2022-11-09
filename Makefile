MakePage=mydef_page

TOPROOT=out/libmycc.c out/mycc_translate.pl out/mycc.sh 

all_targets: ${TOPROOT}

.NOTPARALLEL:

out/libmycc.c: libmycc.def   
	${MakePage} libmycc.def out/libmycc.c

out/mycc_translate.pl: mycc_translate.def   
	${MakePage} -mperl mycc_translate.def out/mycc_translate.pl

out/mycc.sh: mycc.def   
	${MakePage} -msh mycc.def out/mycc.sh

install: all_targets
	sh install.sh

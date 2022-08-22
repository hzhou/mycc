MakePage=mydef_page

TOPROOT=out/libmycc.a out/mycc.sh 

all_targets: ${TOPROOT}

all: all_targets out

.NOTPARALLEL:

out/libmycc.c: libmycc.def   
	${MakePage} libmycc.def out/libmycc.c

out/libmycc.o: out/libmycc.c
	gcc -c -o out/libmycc.o out/libmycc.c

out/libmycc.a: out/libmycc.o
	ar rcs out/libmycc.a out/libmycc.o

out/mycc.sh: mycc.def   
	${MakePage} -msh mycc.def out/mycc.sh

out/mycc_translate.pl: mycc_translate.def   
	${MakePage} -mperl mycc_translate.def out/mycc_translate.pl

install: out/libmycc.a out/mycc.sh out/mycc_translate.pl
	install -m744 out/mycc.sh ${HOME}/bin/mycc
	install -m744 out/mycc_translate.pl ${HOME}/bin/mycc_translate
	install -m644 out/libmycc.a ${HOME}/bin

out: force_look
	make -C out

force_look:
	true

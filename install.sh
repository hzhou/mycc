#!/bin/sh

set -x
install -m 700 out/mycc.sh $HOME/bin/mycc
install -m 700 out/mycc_translate.pl $HOME/bin/mycc_translate
install -m 600 out/libmycc.a $HOME/bin/

CC=gcc
my_cflags="-g -finstrument-functions"

allargs=("$@")
linking=yes
argno=0
Show=
for arg in "$@"; do
    addarg=yes
    case "$arg" in
        -c|-S|-E|-M|-MM)
            linking=no
            ;;
        -show)
            Show=echo
            addarg=no
            ;;
        -v)
            echo "mycc - wrapper cc for gcc to add -finstrument-functions"
            if "$#" -eq "1"; then
                linking=no
            fi
            ;;
    esac
    if test x$addarg = xno; then
        unset allargs[$argno]
    fi
    ((argno++))
done
if test x"$linking" = x"yes"; then
    $Show $CC $my_cflags "${allargs[@]}" -Wl,--whole-archive -L$HOME/bin -lmycc -Wl,--no-whole-archive
else
    $Show $CC $my_cflags "${allargs[@]}"
fi

# MYCC - C compiler wrapper for function logging

## Prerequisite
* gcc or C compiler that supports -finstrument-functions
* shell - for mycc wrapper script
* Perl - for mycc_translate script
* Make
* [MyDef](https://github.com/hzhou/MyDef) + [output_c](https://github.com/hzhou/output_c)

## Install
```
make install
```

It installs to $HOME/bin. Add $HOME/bin to your PATH.

Sorry for lack of configurations, but hopefully you'd enjoy the simplicity.

## Usage

Set `CC=mycc` and most build system will pick it up.

## Example
### build
```
$ mycc -o foo/foo foo/foo.c
```
Or -
```
$ mycc -c -o foo/foo.o foo/foo.c && mycc -o foo/foo foo/foo.o
```

### run
```
$ MYCC_LOG=stdout foo/foo | mycc_translate
  0.000    main {
  0.000        bar {
  0.000            delay {
  0.006            }
hello world!
  0.006            baz {
  0.006                delay {
  0.029                }
  0.029            }
  0.029        }
  0.029    }
```
Or -
```
$ MYCC_LOG=foo.log foo/foo
hello world!

$ cat foo.log
0x55c296d45000 - 0x55c296d46000 @ 0x1000 -- /home/hzhou/projects/mycc/foo/foo
0x7f335f710000 - 0x7f335f888000 @ 0x22000 -- /lib/x86_64-linux-gnu/libc-2.31.so
0x7f335f908000 - 0x7f335f92b000 @ 0x1000 -- /lib/x86_64-linux-gnu/ld-2.31.so
  0.000 Enter 0x55c296d453e0 from 0x7f335f712083
  0.000 Enter 0x55c296d45380 from 0x55c296d45411
  0.000 Enter 0x55c296d452e9 from 0x55c296d453a5
  0.007 Exit 0x55c296d452e9 from 0x55c296d453a5
  0.007 Enter 0x55c296d45336 from 0x55c296d453ca
  0.007 Enter 0x55c296d452e9 from 0x55c296d4535b
  0.032 Exit 0x55c296d452e9 from 0x55c296d4535b
  0.032 Exit 0x55c296d45336 from 0x55c296d453ca
  0.032 Exit 0x55c296d45380 from 0x55c296d45411
  0.032 Exit 0x55c296d453e0 from 0x7f335f712083

$ cat foo.log | mycc_translate > foo_clean.log

$ cat foo_clean.log
  0.000    main {
  0.000        bar {
  0.000            delay {
  0.007            }
  0.007            baz {
  0.007                delay {
  0.032                }
  0.032            }
  0.032        }
  0.032    }
```

## Note
In case it is not clear, this is for debugging and code study. Do not use it to build production.

#!/bin/bash

################ also see https://bitbucket.org/hervey980/automatic_command/src/master/init_ubuntu/gdb_repl/

#set -o history -o histexpand
#echo !!

# https://stackoverflow.com/a/2236614/21294350

# run "~/CSAPP-3e-Solutions/site/content/compile.sh 2 xbyte g" instead of ". ~/CSAPP-3e-Solutions/site/content/compile.sh -c 2 -f xbyte -g" to avoid interpreted as positional arguments by "help source" or "exit current shell"

# https://stackoverflow.com/questions/2740906/how-to-access-command-line-arguments-of-the-caller-inside-a-function
# shopt -s extdebug
# function argv {
#    for a in ${BASH_ARGV[*]}; do
#       echo -n "$a "
#    done
#    echo
# }
# argv

# test() {
#    # echo -e "$* \n $@\n $?\n"
#    echo $@
#    # echo $*
# }
# test

# echo $*
# echo $@

helpFunction() {
   echo ""
   echo "Usage: $0 chapter file ((-g) num)"
   echo -e "\tThe argument order can't be changed"
   echo -e "\tDescription of what chapter is"
   echo -e "\tDescription of what file name is"
   echo -e "\t-g whether debug"
   echo -e "\tnum breakpoint line number"
   #   exit 0 # Exit script after printing help
}
# if [ $1 == '-h' || $1 == '--help' ] ; then
#    helpFunction
#    exit 0
# fi
# if [ $3 == 'g'|| $3 == '-g' ] ; then
#    gdb $test_file
# fi

for i in $@; do
   case $i in
   -h | --help)
      helpFunction
      exit 0
      ;;
   -c | c | --c)
      CREF=1
      ;;
   -r | r | --r)
      REPL=1
      ;;
   )
       
   esac
done

case $1 in
-h | --help)
   helpFunction
   exit 0
   ;;
-c | c | --c)
   cd ~/CSAPP-3e-Solutions/site/content/creference
   test_file=$2
   if [ -f $test_file.c ]; then
      if gcc $CFLAGS -g -ggdb3 $test_file.c -o $test_file; then
         case $3 in
         -g | g | --g)
            gdb $test_file
            exit 0
            ;;
         esac
         ./$test_file
      fi
   fi
   exit 0
   ;;
-r | r | --r)
   cd ~/CSAPP-3e-Solutions/site/content/gdb_repl
   test_file=$2
   if [ -f $test_file.c ]; then
      if gcc $CFLAGS -g -ggdb3 $test_file.c -o $test_file; then
         case $3 in
         -g | g | --g)
            if [[ -n $4 ]]; then
               gdb $test_file -ex "br $4" -ex "r"
               exit 0
            else
               #echo "please give gdb breakpoint"
               gdb $test_file
               exit 0
            fi
            ;;
         esac
         ./$test_file
      fi
   fi
   exit 0
   ;;
esac
cd ~/CSAPP-3e-Solutions/site/content/"chapter$1"/code
test_file=$2
if [ -f $test_file.c ]; then
   # https://stackoverflow.com/questions/1024525/how-to-check-if-gcc $CFLAGS-has-failed-returned-a-warning-or-succeeded-in-bash
   # https://stackoverflow.com/questions/36313216/why-is-testing-to-see-if-a-command-succeeded-or-not-an-anti-pattern
   if gcc $CFLAGS -g -ggdb3 $test_file.c -o $test_file; then
      ./$test_file
      case $3 in
      -g | g | --g)
         if [[ -n $4 ]]; then
            gdb $test_file -ex "br $4" -ex "r"
            exit 0
         else
            #echo "please give gdb breakpoint"
            gdb $test_file
            exit 0
         fi
         ;;
      esac
   fi
else
   echo "current dir is $(pwd), no file $2"
   exit 0
fi

exit 0

# Linux- Bash Shell and Scripts

## 01 Bash Beginning

### 01-01 Exploring the Bash Documentations

- **The Man and Info Commands**
    - Bash has a lof features.
    - There is some handy online documentation.
    - The `man` and `info` commands give the Bash(1) man page.
    - It's about 100 printed pages.
    - The reference manual is here: https://www.gnu.org/software/bash/manual/bash.html

```sh
man bash
man bash | wc -l
info bash 
info bash | wc -l
```

### 01-02 Setting the Script Interpreter and Permissions

- **Script File Basics**
    - First two characters should be #!
      (known as "shebang").
    - Followed by path to Bash or evn:
        `#!/usr/bin/env bash`
        `#!/bin/bash`
    - This is executed via the kernel system called `execve()`
    - Kernel checks for `#!` and passes the path to the orignal program as a command-line argument.
    - So `./myscript.sh`, with `#!/bin/bash` would have the kernel execute
        `bin/bash ./myscript.sh` 
    - Perl, Python, Expect, awk, and Bash can use `#!`.
    The env will look for Bash in you path.
    - Just `#!/bin/bash` is most common.

- **Executing the Script**
    - Make scripts excutable wit h`chmod u+x`
        *Add excuete permission for the "user", wihch means the owner of the script file.*
    - With only read permission, execute a script with bash `thescript.sh`
    - If the directory that contains the script, like the current directory (.), is not in you path, then you normally run the script this way: `./thescript.sh`
    - There is no need to give a script any special name but a `.sh` suffix is common and informative.

### 01-03 Time Commands and Set Variables

- **The Bash Time Command**
    - Bash has a builtin time command to report how much time a process consumed.
        `time find / -name core`

- **Variables in Bash**
    - Variables in Bash are given a value with =.
    - You should put no spaces before or after the =. value has special characters, including spaces, put the value in quotes.
    - myvar="this is some chars; * $\")"
    - Created when you assign one a value or declare with, for example, the export command.
    - Remove variables with the unset command 
    - Reference the value of a variable with a dollar sign front of the name:
        `echo myvar is $mayvar`
    - For a shell script to get a copy of a shell variable needs to be "exported""
        `export mynewvar` or declare `-x mynewvar`
    - You can export and assign in the same statement:
        `export var2="var2 value"`.
    - `export -f myfunc` will export the function `myfunc`.
    - Typing just export will print which variables are part of the shell`s environment - those exported.

- **Grouping in Bash**
    - Bash functions use braces and can modify variables of the shell that calls the function.

```sh
a=1
(
    a=2
)
echo $a
```
prints 1

```sh
a=1
{
    a=2
}
echo $a
```
prints 2

- **Bash Builtins**
    - Get a list of Bash builtins with the enable command
    - Prefers builtins, keywords, aliases, and functions over commands in the file system


```sh
time sleep 2
```

```sh
enable
```

### 01-04 Bash Startup

- `.bash_profile` is read when Bash is invoked as a login shell.
- `.bashrc` is executed when a new shell is started.
- If you extend an exported variable, like `PATH`, in `.bashrc`, it will grow with each neted shell invocation. -> *Not what we want!*
- `PATH=$PATH:/usr/local/bin`
    This would keep adding `/usr/local/bin` to the `PATH` within nested shells.
- Alisases and functions should normally be defined in `.bashrc`.

### 01-05 Sourcing and Aliasing with Bash

- **Sourcing Scripts**
    - `source example.sh`, or `. example.sh`
    - It is "dot spae" as a short way to source a script.
    - The shell executed the script in the shell's own process instead of in a new process.
    - Sourcing is a common way to import variable assignments or functions.
    - The sourced script is executed within the calling shell's process.

- **Working with Alisase**
    - The alias command allows for short command alternatives: alias ll="ls -l".
    - Some people use an alias to give an alternative more familiar name or to fix a common typo to Linux command.
    - List defined aliases by simply typing alias
    - Unset an alias with the unlias command

```sh
echo "x=22" > setx.sh
chmod +x setx.sh
echo $x                 # Print: nothing
./setx.sh
echo $x                 # Print: nothing
source ./setx.sh
echo $x                 # Print: 22
x=1
echo $x                 # Print: 1
. ./setx.sh
alias ls                # Pirnt: alias ls='ls --color=auto'
```

### 01-06 Dispaly Text with the Echo Command

- **Using the Echo Command**
    - Built into Bash and doesn't start a new process
        - `-n` -> don't print a trailing newline
        - `-e` -> enable backslash escaped characters like `\n` and `\t`
        - `-E` -> disable backslash escaped characters in case they were enabled by default
    - `ls *` would list contents of directories:
        - `echo *` would show file and directory names
    - Use file redirection techniques to send the output to other files, such as `stderr`:
        `echo 'Warning Will Robinson!' >&2`

*echoes.sh*
```sh
echo Hello World
echo -n Good to see you "\n\n"
echo Thanks
echo -e Hi "\t\t\t" There "\n\n"
echo -E Bye "t\t\t" For now "\n\n"
```

### 01-07 Challenge

- **Simple Script**
    - Write a Bash script, with "shebang" inside, that prints the variable A
    - Run your script without defining or setting a variable A in your shell
    - Run it again after setting A=1 on the command line before you run the script
    - Finally run it after doing: export A=2 on the command line

- **Source**
    - Write a script, `set.sh`, that sets A=10
    - On the command line set A=5, and then run your script that prints A to see it print A. A should be exported.
    - On the command line set A=5. In your script that prints A, before printing A, source `set.sh`. You should see the script now print A is 10.
    -  On the command line set A=5. In your script that prints A, run `set.sh`; don't source it. You should see that the script prints A=5.

- **Echo**
    - Write a script that echoes the line "Hello, World\n\n"
    - Add the `-n` option to the echo and run again
    - Relace the `-n` with `-e` and run again
    - What do they print? How does their output different?


## 02 Local Variables in Functions, Loops and Arithmetics

### 02-01 The Typesets and declare Commands for Variables

- **Local Variables and Typeset**
    - Variables can be created in a function that will not be available outside of it.
    - The typeset command makes variables local, can provide a type, or can provide formatting.
        `typeset -i x`
        `# x must be an integer`
    - Arithmetic is faster for variables defined to be integers.
    - Let allows for convenient arithmetic:
        `let x++; let x**2; let x=x*3; let x*=5, ...`
    
- **The Declare Command**
    - `declare -l` uppercase values in the variable are converted to lowercase.
    - `declare -u` lowercase values in the variable are converterd to uppercase.
    - `declare -r` variable is made *read-only*.
    - `declare -a MyArray` will make *MyArray*  an indexed array.
    - `declare -A MyArray2` will make *MyArray2* an associative array.

*typeset.sh*
```sh
    #!/bin/bash

function f1 {
    typeset x # Set x as local variable
    x=7
    y=8
}

x=1
y=2
echo x is $x
echo y is $y
f1
echo x is $x
echo y is $y
``` 

*declare.sh*
```sh
#!/bin/bash

declare -l lstring="ABCdef"
declare -u ustring="ABCdef"
declare -r readonly="A Value"
declare -a Myarray
declare -A Myarray2

echo lstring = $lstring
echo ustring = $ustring
echo readonly = $readonly
readonly="New Value"
Myarray[2]="Second Value"
echo 'Myarray[2] =' ${Myarray[2]}
Myarray2["hotdog"]="baseball"
echo 'Myarray2[hotdog] =' ${Myarray2["hotdog"]}
```

### 02-02 Lopping with for-while Sequences and Reading Input

- **The Read Command**
 - Read a line into a variable or multiple variables
 - `read a b` - reads first word into a and the rest into b
 - Convenient for a while loop

- **While Loops**

```sh
while
    command list 1
do
    command list
done
# loops while command list 1 succeeds
```

```sh
while
    ((x<10))
do
    echo loop $x; date >date.$x
    ((x=x+1))
done
```

```sh
while
    read a b
do
    echo a is $a b is $b
done <data_file
```

```sh
ls -l | while 
    read a b c d
    do ehoc owner is $c
    done
```

- **For Loops**

```sh
for <var> in <list>
do 
    command list
done
```

```sh
for i in dog catr elephant
do 
    echo i is $i
done
```

```sh
seq 1 5
# prints 1 2 3 4 5
```

```sh
for num in `seq 1 5`
# loops ove 1 2 3 4 5 
```

```sh
# generate sequences with {A..Z}, {1..10},
```

```sh
for d in $(<data_file)
# loops over space/newline
# separated data in data_file
```

```sh
for j in *.c
# making a list with file globbing
```

```sh
for f in $(find . -name *.c)
# using a command to gerneate a list
```

*`read.sh`*
*`while.sh`*
*`while2.sh`*

```sh
nl for.sh
```

### 02-03 Defining Functions and Using Return and Exit

- **Bash Functions**
    - Give a name to a sequence of statement that will execute within the shell, not in a new process
```sh
function NAME {
    function body ...
}
```
    - Commonly used to organize code in a shell process
```sh
function printhello {
    echo Hello
}

printhello
# shell memorizes the function like it's a new command
```

- **The Return Command**
    - Functions return when there are no more statement executed or when a return statement is executed.
```sh
function myfunc {
    echo starting
    return 
    echo this will not be executed
}
```
    - Functions produce results by writing output like commands do.
```sh
hvar = $(printhello)
```

- **The Exit Command**
    - `exit <VALUE>` sets the exit status, represented by `$? to <VALUE>`.
    - `exit` terminates the shell process.
    - `exit` in a function terminates the whole shell program, not just the function.

```sh
function printhello {
    echo Hello
}
```

*`func.sh`*
*`func2.sh`*

### 02-04 Using File Descriptors, File Redirection, Pipes and Here Documents

- **Redirection and Pipes**
    - Processes normally have three files open:
        0 => stdin, 1 => stdout, 2 => stderr
    - `command > stdout-here 2> stderr-her < stdin-from-here`
    - `command &> file`
        - file gets stdout and stderr from command,
        - file is created or overwritten
    - `command | command2`
        - command2's `stdin` comes from command's `stdout`
    - `command 2>&1 | command2`
        - gets `stdout` and `stderr` from command
    - `command |& command2`
        - alternative way for command2 to get command's `stdout` and `stderr` as its `stdin`
    - `command >> file`
        - appends `stdout` of `command` to end of file
    - `command &>> file`
        - appends `stdout` and `stderr` of `command` to end of file

- **Here Documents: <<**
    - Here documents are a way to embed input for standard input inside of a script.
    - They avoid having to create a new file just to hold some input values.

```sh
sort <<END
> cherry
> banana
> apple
> orange
> END
```
apple
banana
cherry
orange


- **Open and Close File Descriptors**
    - `exec N< myfile`
        - opens file descriptor N for reading from file `myfile`

    - `exec N> myfile`
        - opens file descriptor N for writting to `myfile`

    - `exec N<> myfile`
        - opens file descriptor N for reading & writing with `myfile`

    - `exec N>&- or exec N<&-`
        - closes file descriptor `N`

    - Use `lsof` (list open files) to see what file descriptors for a process are open

    - `exec 7>/tmp/myfile7`
      `lsof -p $$` => `$$` is shell's PID

    *`redirect.sh`*
    *`here.sh`*

### 02-05 Control-flow case statements and if-then-else with the test command 

- **The Case Statement**

```sh
case expression in
pattern 1 )
    command list ;;
pattern 2 )
    command list ;;
    ...
esac
```

```sh
case $ans in 
yes|YES|y|Y|y.x ) echo "Will do!";;
n*|N*) echo "Will NOT do!";;
*) echo "Oops!";;
esac
```

- **The If-Then-Else Statement**

```sh
if 
command list # last result is used
then
command list
[else 
command list]
fi
```

```sh
if 
grep -q import myfile
then
    echo myfile has import stuff
else 
    echo myfile does not have important stuff
fi
```

- **Tests in Bash**
    - The builtin test is used to check various conditions and set the return code with the result.
    - Loops and conditionals often use the result of test.
    - An alternative to test is `[[]]` or `(())`.

- **Test Examples**

```sh
if 
test -f afile
```

```sh
if [[ if bfile ]]
```

```sh
if
test $x -gt 5
```

- **Test Operators**
    `[[ ex1 -eq ex2 ]]   [[ ex1 -ne ex2 ]]`
    `[[ ex1 -lt ex2 ]]   [[ ex1 -gt ex2 ]]`
    `[[ ex1 -le ex2 ]]   [[ ex1 -ge ex2 ]]`
    `[[ ex1 && ex2 ]]   [[ ex1 || ex2 ]]`

- **More Tests**

```sh
test -d X
# success if X is a directory
```

```sh
test -f X
# success if X is a regular file
```

```sh 
test -s X
# success if X exists and not empty
```

```sh 
test -x X
# success if you have x permission on X
```

```sh 
test -w X
# success if you have w permission on X
```

```sh 
test -r X
# success if you have w permission on X
```

### 02-06 Using Arithmetic Operators

- **Arithmetic Operators**

Use in `(())` with let

```sh
id++ id-- ++id --id
! ~ ** * / % + -
<< >> <= >= < >
== != & ^ | && ||
expr?expr:expr
= *= /= %= += -= <<= >>= &= ^= ^= !=
expr1, expr2
```

- **Using Operators**

```sh
n=5
((n++))
if
((n>4 || n == 0))
```

*`arith.sh`*
```sh
((n=2**3 + 5))
((y=n^4))
echo y = $y
# prints 9, why
```

### 02-07 Challenge & Solution

- **Challenge: Local Vars**
    - Write a Bash script that has a function `f`
    - Creates a local variable, sets it to 1, and then prints its value
    - Sets A=2, calls f, and then prints A after returns


- **Challenge: Loops**
    - Write a Bash script that uses a `for loop` to loop all of the files in `/usr/bin` and echo the name of any one of them that has inside the string "unable to fork"

    Hint:
    ```sh
    if 
        strings $i | grep -q "unable to fork"
        then
    ...
    ```

- **Challenge: Arithmetci**
    - Write a shell script that echos a running total of the RSS and SZ columns from the command: `ps -ly`

    - Hint: 
    ```sh
    n=1
    ps -ly | while
    read c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
    do 
        if ((n>1)) # skip the first line
    ...
    ```

## 03 Using Filters and Parameters Expansion

### 03-01 Defining Filters and Using `head` `tail` and `wc`

- **Filters**
    - In Linux, a program is a "filter" if it reads from stdin and writes to stdout.
    - Filters can be used in pipes.
    - Filters provide the powerful means of combining input and output of a sequence of commands to get kind of report that you want.

- **The `head` and `tail` Commands
    - `head` prints the first n lines of a file or stdin.
    - `tail` prints the last n lines of a file or stdin.
    ```sh
    ls -l | head -5 # first 5 lines of ls -l
    ls -l | tail -7 # last 5 lines of ls -l
    ls -l | head -10 | tail -5 # lines 6-10
    ```
    - `wc` (word count) prints line, word, and char counts.
    - `wc -l` prints the number of lines.
    - `ls | wc -l` prints number of entries in directory

*`headtailwc.sh`*
*`makeoutput.sh`*

```sh
./makeoutput.sh > output &
tail -n2 -f output # Keep running -f means --follow
```

### 03-02 Using `sed` and AWK More Powerful Scripts

- **The Command `sed`**
    - Is a pattern editor, which means it is not interactive
    - Works great as a filter
    - Is ideal for batch editing tasks
    - Usually applies its editing to all lines in the input
    - With the `-i` option, change a file instead of echoing the modified file to stdout

- **Using `sed` Substitute**

    ```sh
    sed 's/old/new/' myfile
    ```
    - Substitute the first occurrence of `old`on each line for `new` in the file `myfile` and display the result on stdout.
    - `old` is a pattern and can be a regular expression.

- **`sed` Substitute**
    - The `/` is the usual character to separate the old from the new.
    - The file myfile will not be changed; the new version echoed to stdout.
    - No options are required for simple substitutions.


- **`sed` Examples**
    ```sh
    sed 's/@home/@domicile/; s/truck/lorrie'
    sed -e 's/[xX]/Y/' -e "s/b.&/blue/'
    sed -f sedscript -n sed4
    date | sed 's/J/j/'
    sed '1,5p'
    sed '/alpha/s/beta/gamma/'
    sed '/apple/,/orange/d'
    sed '/important/!s/print/throw_away/'
    ```

- **The `awk` Language**
    - A pattern matching language
    - An interpreted programming language that work as a filter
    - Good for report writing
    - Handy for short "algorithmic" kinds of processing
    - Processes a line at a time like sed
    - Breaks each line into fields, `$1`, `$2`, etc
    - Fields are delimited by the values in the variables normally white space
    - `$0` is the entire line (record).

- **`awk` Examples**
    ```sh
    $ ps -el | \
    awk '/pts/||$8~/35/{printf("%5d %5d %s\n", $4, $5, $14)}'

    *awkl*
    ```sh
    ps -ly | ./awkl
    ```

    ```sh
    man ls | col -b | awk -f words.awk
    ```

```sh
sed 's/apple/banana/' sometext
```

```sed2
s/a/A/
s/B/BBB/
```
```sh
sed -f sed2 sometext
```

*sed3*
```sh
sed -n "$1, $2p"
```
```sh
bash sed3 3 5 <sometext
```


### 03-03 Positional Parameters and Operators with Braces

- **Script Parameters and `{}`**
    - Parameters to a shell program: `$1`, `$2`, ...
    - Called "posional parameters"
    - To reference multidigit use `{}`, e.g., ${10}
    - `$0` is the path to the program itself:
        For example, echo Usage: `$0 arg1 ...`
    - `Shift` moves `$2` into `$1`. `$3` into `$2`, etc.
    - It is sometimes handy or required to use `{}` with named variable,. e.g., echo ${abc}DEF.
```sh
x=abc
abc=def
echo ${!x} #prints def. Indirection!
```

- **Unset or Null Variables**
    - `${variable <OPR> value}`
      `x=${var:-Hotdog}`
    - `:-` if var unset/null, return value; otherwise return value of var
    - `:=` if var unset/null var is assigned value & returned
    - `:?` Displays an error and exit script if var unset/null
    - `:+` if var unset/null return nothing; otherwise return value

- **String Operations**
    - `${var:offset}` - value of var starting at offset
    - `${var:offset:len}` - value of var starting at offset up to length len
    - ${#var} - length of var
    - `${var#pre}` - remove matching prefix
    - `${var%post}` - remove matching suffix
    - prefix and postfix - handy processing filenames/paths
    - Look at `info` bash for more details on thse and similar

```sh
./pos.sh {A..Z}
./indrect.sh
./unsetnull.sh
./string.sh
./prepost.sh
```

### 03-04 Challenges & Solutions

- **Write a script that loops through all of the command-line args, echoing them one per line.**

- **Write a script that will assign to the variable File the value of the variable TheFile if TheFile is set; otherwise, it will assign to File: `/tmp/data.file`**
    - Use the special Unset/Null expansion operation

- **Write a script that will echo all the names of the *.c files in the current directory without the ".c" suffix.**
    - Use the string operation

- **Write a script that uses `sed` to not echo line 1 and will remove the first space through the end of the line.**
    - Test like this:
        ```sh
        ls -s | bash challenge.sh
        ```
    - Should print just the sizes; no "total" line

- **Write an `awk` script that will calcute the sum and average of the numbers in three columns.**
    - The input:
        4   10  21
        6   20  31
    - Should print:
        sum 10 30 52
        ave 5 15 26

## 04 The Advanced Bash

### 04-01 Using the Coproc Command

- **Using Coproceses**
    A coprocess is a background process where your shell gets file descriptors for the process's stdin and stdout.

    ***Implemented with pipe***

We need a script that is a filter.
```sh
#!/bin/bash
while 
    read line
do 
    echo $line | tr "ABC" "abc" # tr means translate
done
```

- **`coproc ./mycoproc.sh`**
    - `echo BANANA >&"${COPROC[1]}"`
    - `cat <&"${COPROOC[0]}`

- **`coproc my { ./mycoproc.sh }`**
    - `echo BANANA >&"${my[1]}"`
    - `cat <&"${my[0]}`

```sh
coproc ./translate.sh
echo BaNana >&"${COPROC[1]}"
cat <&"${COPROC[0]}" # print: banana
kill %1
```

```sh
coproc myt { ./translate.sh ; }
echo BaNana >&"${myt[1]}"
cat <&"${myt[0]}" # print: banana
kill %1
```

### 04-02 Debugging Scripts with -x and -u options

- **Debugging Scripts**

```sh
bash prog
```
- Run prog; don't need execute permission

```sh
bash -x prog
```
- Echo commands after processing; can also do `set -x` or `set +x` inside of script

```sh
bash -n prog
```
- Do not execute commands, check for syntax error only

```sh
set -u
```
- Reports usage of an unset variable

- Lots of echo statements
- `tee`
```sh
cmd | tee log.file | ...
```


```sh
bash debug1.sh
bash -x debug1.sh
bash -n debug1.sh
```

### 04-03 Signals and Traps

- **Trap: Using Signals**
    - The Bash trap command is for signal handling.
        - ***Change behavior of signals within a script***
        - ***Ignore signals during critical sections in a script***
        - ***Allow the script to die gracefully***
        - ***Perform some operations when a signal is received***

```sh
./trapint
```

```sh
kill -l
```

### 04-04 Using the `eval` and `getopt` Command

- **The `eval` Command**
    - Used to have Bash evaluate a string.
    - Makes a "second pass" over the string and then runs it as a command
    - Runs "data," in effect, so be careful about providing a way for arbitrary code execution.
```sh    
c="ls | tr 'a' 'A'"; $c # doesn't work
eval $c # works
```

http://mywiki.wooledge.org/BashFAQ/048

- **The `getopt` Command**
    - `getopt` is used to process command-line options.
    - Option names, long and single letter, are specified and whether they take an argument.

```sh
opts=`getopt -o a: -l apple -- "$@"`
# Option a, long form -apple, takes an argument.
# getopt prints the parsed arguments.
# $@ is the Bash variable for list of parameters passed.
```

```sh
bash options.sh -b=hotdog
bash options.sh -ryes
bash options.sh -r yes
bash options.sh -r=yes
bash options.sh --branch
bash options.sh --branchhotter
```
    
### 04-05 Challenge & Solutions

- **Wriete a Bash script that assigns to a variable, c, the value "`ls -s | sort -n`"**

<!-- ***->Challenge1.sh*** -->
```sh    
c="ls -s | sort -n"; $c # doesn't work
eval $c # works
```

- **Wriete a Bash script which sets a variable, opts, equal to "`a b \$1 \$2`**
- **Do set -- "$opts" and echo $@. Run the script with command-line options: x y z. Do you see the x and y?**
- **Change the set-- "$opts" to eval set -- "$opts" and run again**

***->Challenge_04_B.sh.sh***
```sh
./Challenge_04_B.sh x y z
```


- **Add to the options.sh script, new options, -x and --exclude, that take a required value and set the variable `exlist` to the value; print `$exlist` at the end of the script**

***->./challenge_04_C***



- **Create a `coproc` that will run a script that uses the subsitute command to replace every occurrence of flag with banner**
- **Run your `coproc` and send it the following input: The first flag was red and the second flag was blue. But, the third flag and fourth flag were purple. Such flags were colorful flag."**

```sh
coproc mysed { ./coproc-set ; }
echo ${mysed[1]}    # prints 58
echo ${mysed[0]}    # prints 62
```

- **Write a script that does the folloing:**
    - echo no trap
    - sleep 5
    - trap INT with an empty string funciton
    - echo ignore interrupt
    - sleep 5
    - trap INT with an echo message function
    - echo trap with message
    - sleep 5
- **Run your script three times, hitting `Ctrl-c` in each of the three sleeps; decide what will happen first and then see if you were correct**
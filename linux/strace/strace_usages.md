# Strace Usage

## Intro Tutorial

```sh
strace ls -l
strace -o strace_output_ls.txt ls -l
strace -c ls -l
strace -e read ls -l
strace -t -e read ls -l # Added timestamp
strace -r -t -e read ls -l # Added real time
strace -f ./a.out [-options]
strace -p {PID}
```

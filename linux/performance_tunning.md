# Linux Performace Tunning

## 01 Introduction

### 01-01 What Do We Mean by Performce

- **Response Time**

    **Minimum**
    - A response as fast as possible

    **Deterministic**
    - A response in the same amount of time, every time

    **Deadline**
    - A response in time --- earlier may not have any additional value

- **Throughput**

    **Amount of work done in a time interval**
    - Database transactions per second
    - Webpages served per minute
    - Bytes transferrred per second
    - Throughput and response time my compete

- **Completion Time**
    **A particular task that completes as soon as possible**
    - Software build
    - QA run

- **Other Metrics**
    **Sometimes included in performance measures**
    - Efficiency
    - Scalability
    - Power consumption


### 01-02 Timming Techiniques

- **Using Wall Clock Time**

    **Get the time**
    - `date` command
    - `date`; your-command; date
    - Bash prompt
    - `PS1="\T$"`

- **The `time` Command**

    **`/usr/bin/time`**
    - `/usr/bin/time sleep 2`
    - 0.00user 0.00system 0:02.00elasped 0%CPU (0avgtext+0avgdata 1776maxresident)k
    - 0inputs+0outputs (0major+72minor)pagefaults Oswaps

    **Bash time keyword**
    - `$ type time`
    - `time` is a shell keyword
    - Note that builtins make sense alone; the time keyword is used before another command
    - `$time ./loop1.sh`

- **In Code**
    **Get the time, do it, and get the time afterwards.**
    - `gettimeofday()`
        Provides time since the start of the unix epoch, resolution uses.

    - `clock_gettime()`
        Lots of different times, see clock_getres(2)

- **Operations per Second**
    - Do N operations and time it (S Seconds)
    - Run program for S Seconds and count the number (N) of operations done
    - Operations/seond = N/S
    <!-- - `loop1/sh` did 50000 operations in  -->


- **Response Time**
    - Provide a stimulus and time how long it takes to get a response
    - `./ask.sh`

- **The `strace` Command**
    - The `strace` command will show the system calls that a process makes
    - It can also report how long they took --- in CPU time, not elapsed time 
    - `strace -c -o /tmp/s.out ./loop1.sh`


```sh
type pwd # pwd is a shell builtin
type /bin/pwd # /bin/pwd is /bin/pwd
```


### 01-03 The `proc` Filesystem

- **The `proc` filesystem needs to be mounted**
    - This should happen automatically at boot time
    - `mount -t proc proc /proc`

    **Proc files/directories have permission modes like file and directories.**
    - Some files are writable -by root
    **Proc is a "pseudo" filesystem - whole entries map to kernel funcitons to produce the contents.**

- **Proc Files Provide Kernel Info**
    - Printing the contents of the proc file causes the corresponding function in the kernel to be alled to produce fresh values
    - Proc files can be cat'd, grepped, and so on
    - The length reported by `ls` may be zero: it's a pseudo filesytem

- **Reading Proc Files for Perf Info**
    **There are >2000 proc files separate from the process ones.**
    - Process `proc` file are under the directory in `proc` named with the process ID
    - `/proc/1234` would be information about process with PID 123
    
    **Proc files under /proc/sys represent kernel variables.**
    - Some are RW, some R, and some W

- **Process Proc Files**
    **`limts`**
    - Resource limits - the same as ulimit command
    
    **`numa_maps`**
    - Where on NUMA system process has memory (large server)

    **`sched`**
    - Lots of statistics

    **`stat`**
    - Process status info

    **`statm`**
    - Process memory status info

    **`status`**
    - Simliar to ps command info
        *See /Documentation/filesystems/proc.txt in kernel source tree.*


```sh
echo $$ # Get the process ID of my shell
cd /proc/$$
pwd
cat stat
more statm
more status
```

- **System Proc Files**

    **Can set with `sysctl(8)`**
    - `sysctl -a` shows all of them, 1700+

    **Several subdirectiories under `/proc/sys`**
    - abi, debug, dev, fs, fscache, kernel, net, sunrpc, vm

    **System config files**
    - `/etc/sysctl.conf`, `/etc/sysctl.d`

### 01-04 Packages for Performance

- **Installing Packages**
    **Different Linux systems use different packaging.**
    - RPM and Debian packages are two most common

- **We will discuss RPM packages.**
    - Debian pacakages usually have the same or similar names as RPM packages
    - Use commands like `apt-get` with Debian package
    - Use `yum` and `rpm` with RPM packages

- **gnome-system-monitor**

- **Packages for Performance Tools**
    **`sysstat`**
    - Contains a variety of utilities
        cifsiostat, iostat, mpstat, nfsiostat-sysstat, pidstat, sar(system activity report)

    **procps-ng**
    - More utilities to help performance
        free, pmap, ps, slabtop, snice, tload, top, uptime, vmstat, watch

- **`perf`**
    **Gethers information about which subroutines consume the most time**
    - In the kernel
    - In the library
    - In a program

- **`perf` Example**

```sh
sudo perf record find / -xdev -name core > /dev/null 2>&1
sudo perf report
```

### 01-05 Performance Co-Pilot and Tuna

- **Perforance Co-Pilot(PCP) Setup**
    
    **Install these packages:**
    - pcp
    - pcp-gui
    - pcp-webjs
    - pcp-webapi
    - pcp-doc

    **Review a basic introduction in section 1:**
    - man pcpintro

- **PCP Overview**

    **PCP collectors: collect performance data, often on remote systems**

    **PCP monitors: display the data collected**

    **A toolkit designed for monitoring and managing system-level performance**

    **Run the data-gathering daemon on systems or monitor:**
        - `sudo systemctl enable pmcd pmlogger`
        - `sudo systemctl start pmcd pmlogger`

- **PCP Extensions**
    
    **Performance Metrics Domain Agents (PMDAs)**

    **Packages include**
    - apache, kvm, memcache, mysql, proc, systemd, weblog

    **`yum install pcp-pmda-systemd`**

    **`cd /var/lib/pcp/pmdas/systemd`**

- **Tuna**

    - Tool helps change attributes of application and kernel threads

    - Schedules policy or priority

```sh
pmstat
```

```sh
pminfo

pminfo -d disk.dm.util # -d detail
pminfo -f disk.dm.util # -f get current value
pmchart
```

```sh
sleep 10089 & # Get the PID
```

### 01-06 SystemTap and Berkeley Package Filter

- **SystemTap**

    **Command to run Systemtap scripts: `stap`**
    **Scripts interact with the kernel to**
    - Gather information about your system
    - Change configurations

    **Install the systemtap-client package**
    **Example scripts located in**
    - `/usr/share/systemtap/examples`

```sh
cd /usr/share/systemtap
ls
cd examples
ls
find . -name *.stp | wc -l
cd io
ls
view iotap.stp
view iotap.meta
./iotap.stp
```

- **Berkely Packet Filter (BPF)**

    - BPF is a language with an interpreter inside the Linux kernel used as convenient way of getting system information or changing the kernel behavior
    - BPF examples and valuable scripts available at https://github.com/iovisor/bc#tools
    - The newer version of BPF is more properly called eBPS (extended BPF)
    - Check kernel version requirements, kernel 4.1
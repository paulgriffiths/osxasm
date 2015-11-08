#  unix.inc
#  
#  UNIX constants
#
#  Paul Griffiths, November 7, 2015

.set    STDIN,          0           #  Standard input file descriptor
.set    STDOUT,         1           #  Standard output file descriptor
.set    STDERR,         2           #  Standard error file descriptor

.set    SC_EXIT,        0x2000001   #  exit system call constant
.set    SC_FORK,        0x2000002   #  fork system call constant
.set    SC_READ,        0x2000003   #  read system call constant
.set    SC_WRITE,       0x2000004   #  write system call constant
.set    SC_OPEN,        0x2000005   #  open system call constant
.set    SC_CLOSE,       0x2000006   #  close system call constant
.set    SC_GETPID,      0x2000014   #  getpid system call constant

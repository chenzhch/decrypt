# Decrypt
**Decrypt script binary program to obtain source code.**

Assuming the executable program of the encrypted script file is ```test.sh.x```, to prevent misjudgment by the decryption program, it is required program name to be unique in the process information.
Encryption program generation method | Decryption program 
------|------
[shc](https://github.com/neurobin/shc/) -f test.sh |sh decrypt.sh 1 ./test.sh.x
[shc](https://github.com/neurobin/shc/) -H -f test.sh |sh decrypt.sh 2  ./test.sh.x
[shellc](https://github.com/chenzhch/shellc/) sh test.sh -s |sh decrypt.sh 3 ./test.sh.x
[shc](https://github.com/neurobin/shc/) -P -f test.sh |sh decrypt.sh 4 ./test.sh.x
[shellc](https://github.com/chenzhch/shellc/) sh test.sh |sh decrypt.sh 4 ./test.sh.x
[ssc](https://github.com/liberize/ssc) test.sh test.sh.x |sh decrypt.sh 4 ./test.sh.x
[obash](https://github.com/louigi600/obash) test.sh |sh decrypt.sh 5 ./test.sh.x

The above cracking methods were tested and implemented in a LINUX environment, and may not be applicable to all environments. They are for reference only. If the obtained code is fragmented code, the total value in decrypt.sh can be increased.
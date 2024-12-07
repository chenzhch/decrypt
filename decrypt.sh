#Function: Decrypt script binary obtain source code.
#Author: ChenZhongChao
#Birthdate: 2024-12-05
#Github: https://github.com/chenzhch/decrypt.git

total=3 #Decryption result count
new=""
old=""
count=0

style=$1  
program=$2

#Using stdin
stdin()
{
    while [ : ]; do
        >decrypt.txt
        $program "$@" </dev/null & child=$!
        timeout 5 cat /proc/${child}/fd/3 2>/dev/null >decrypt.txt
        kill -9 $(pgrep -P $child)    
        kill -9 $child
        len=`wc -l decrypt.txt |awk '{print $1}'`
        if [ $len -gt 0 ]; then
            new=$(cat decrypt.txt)     
            if [ ${#new} -gt 3 ];then
                count=`expr $count + 1`
            fi
        fi
        if [ ${#new} -gt ${#old} ]; then
            old="$new"
            new=""
        fi
        if [ $count -gt $total ]; then
            clear
            echo "$old"
            exit
        fi
    done
}

#Using pipe: shc shellc ssc 
pipe()
{
    while [ : ]; do
        $program "$@" </dev/null & child=$!
        timeout 5 strace -p $child -e read -o decrypt.txt 2>&1 >/dev/null 
        kill -9 $(pgrep -P $child)  
        kill -9 $child
        len=`wc -l decrypt.txt |awk '{print $1}'`
        if [ $len -gt 0 ]; then
            new=$(cat decrypt.txt)     
            if [ ${#new} -gt 3 ];then
                count=`expr $count + 1`
            fi
        fi
        if [ ${#new} -gt ${#old} ]; then
            old="$new"
            new=""
        fi
        hs='read(255, "'
        ts='", 1)'
        content=""
        if [ $count -gt $total ]; then
        clear
        while IFS= read -r line; do
            if [[ $line == read\(255* ]]; then
                line=${line#*${hs}}
                line=${line%${ts}*}
                if [[ -n $line ]] && [[ $line = '\n' ]]; then
                    echo "$content"
                    content=""
                elif [[ -n $line ]] && [[ $line = '\t' ]]; then  
                    content="$content    "
                elif [[ -n $line ]] && [[ $line = '\"' ]]; then  
                    content="$content\""  
                else 
                    content="$content$line"
                fi
            fi
            done <<< "$old"
            echo $content
            exit
        fi
    done
}

#Using shc
shc()
{
    while [ : ]; do 
        > decrypt.txt
        $program "$@" & child=$!
        #ps -aux | grep $child | grep $program | grep -v grep >decrypt.txt
        cat /proc/$child/cmdline >decrypt.txt 
        kill -9 $(pgrep -P $child) 
        kill -9 $child             
        len=`wc -l decrypt.txt |awk '{print $1}'`
        if [ $len -gt 0 ]; then
            new="$(cat decrypt.txt)"     
            if [ ${#new} -gt 3 ];then
                count=`expr $count + 1`
            fi
        fi
        if [ ${#new} -gt ${#old} ]; then
            old="$new"
            new=""
        fi
        if [ $count -gt $total ]; then
            clear
            old=${old#*#}
            old=${old%./*} 
            echo "${old}"
            exit
        fi  
    done
}

#Using shc -H
shch()
{
    trap 'sleep 1; clear; cat decrypt.txt' INT TERM EXIT
    while [ : ]; do
        >decrypt.txt
        nice -n 19 $program "$@" </dev/null & child=$!
        cp hook.so /tmp/shc_x.so 
        kill -9 $(pgrep -P $child)
        kill -9 $child 
        len=`wc -l decrypt.txt |awk '{print $1}'`
        if [ $len -gt 0 ]; then
            exit
        fi
    done
}

#Using source temporary file 
temp()
{
    prlimit --cpu=1
    while [ : ]; do
        nice -n 19 $program "$@" </dev/null
    done
}


if [ $# -lt 2 ]; then
    echo "Usage: $0 style program [args...]"
    exit
fi
shift 2

case $style in 
    1) shc "$@" #Using shc
    ;;
    2) cc -fpic -shared -o hook.so hook.c -ldl
    shch "$@" #Using shc -H
    ;;
    3) stdin "$@" #Using stdin: shellc v.03  shellc -s
    ;;
    4) pipe "$@" #Using pipe: shellc ssh shc -P
    ;;
    5) #Using source temporary file 
    sh daemon.sh $total &
    sleep 1
    temp "$@" 
    ;;
    *)
    echo "error style"
    exit
    ;;
esac

    

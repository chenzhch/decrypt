total=$1
count=0   
old=""
new=""
filed=""
trap 'rm -f decrypt.txt' INT TERM EXIT
while [ : ]; do
    >decrypt.txt
    for filed in `ps -aux | grep source | grep -v grep | grep -v daemon.sh| awk '{print $14}'`; do
        if [ "F${filed}" != "F" ];then
            timeout 5 cat $filed 2>/dev/null >decrypt.txt
        fi
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
            for pid in `ps -ef |grep -v grep |grep decrypt.sh| awk '{print $2}'`; do
                kill -9 $pid
            done
            sleep 1
            for pid in `ps -ef |grep -v grep |grep decrypt.sh| awk '{print $2}'`; do
                kill -9 $pid
            done
            clear
            echo "$old" 
            exit
        fi
    done
done


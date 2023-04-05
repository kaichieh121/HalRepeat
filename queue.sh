#!/home/hertin/softwares/zsh/bin/zsh
# #!/bin/bash
repeat=$1
pid=$2
script=$3
USERNAME=kcchang3
echo working directory in $(pwd)/${script}
echo submitting job $repeat times
for i in $(seq $repeat); do
    echo "waiting for $pid to finish ..."
    # check_squeue () {
    #     echo "$(squeue | grep ${USERNAME} | grep ${pid} | xargs)"
    #}
    r=$(squeue 2>&1)
    while true
    do
        if [ $? -ne 0 ] || [[ $r == *"slurm_load_jobs error"* ]]; then
            sleep 30
        else
            filtered=$(echo $r | grep ${USERNAME} | grep ${pid} | xargs )
            if [ ! -z "${filtered}" ]; then
                sleep 30
            else
                break

            fi
        fi
        r=$(squeue 2>&1)
    done
    echo "submitting job ..."
    pid=$(swbatch $(pwd)/${script} | cut -d ' ' -f4)

done
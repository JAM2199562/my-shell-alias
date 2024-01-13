export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias md='mkdir -p'

alias pb='ping www.baidu.com'
alias pd='ping 10.130.32.31'

alias dnsb='nslookup bing.com'

alias ntl='netstat -tlnp'
alias nul='netstat -ulnp'
alias ntul='netstat -tulnp'

alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkk='docker kill'
alias dkrm='docker rm -f'
alias dks='docker stop'
alias dkr='docker run -itd'
function dkexec() {
    container_id=$1
    if [ -z "$container_id" ]; then
        echo "Usage: dkexec <container_id>"
        return 1
    fi

    # Check if bash is available in the container
    if docker exec -it $container_id /bin/bash -c 'exit' >/dev/null 2>&1; then
        echo "Entering bash in container $container_id"
        docker exec -it $container_id /bin/bash
    # If bash is not available, check if sh is available
    elif docker exec -it $container_id /bin/sh -c 'exit' >/dev/null 2>&1; then
        echo "Entering sh in container $container_id"
        docker exec -it $container_id /bin/sh
    else
        echo "Neither bash nor sh is available in container $container_id"
    fi
}

alias yumup='yum update'
alias aptup='apt update'
alias aptupg='apt upgrade'

alias psef='ps -ef'
alias psg='ps -ef | grep'

alias tcpdd='tcpdump -D'

alias cdb='cd -'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git pull'
alias gd='git diff'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ~="cd ~"

function bkk() {
    if [[ -n "$1" ]]; then
        local current_date=$(date +%Y%m%d%H%M)
        if [ -d "$1" ]; then
            # 是目录时使用递归复制
            cp -r "$1" "${1}_${current_date}"
        elif [ -f "$1" ]; then
            # 是文件时直接复制
            cp "$1" "${1}_${current_date}"
        else
            echo "Error: '$1' is not a valid file or directory"
            return 1
        fi
        echo "Backup of '$1' created as '${1}_${current_date}'"
    else
        echo "Usage: bkk <filename/directory>"
    fi
}

function tcpd() {
    if [[ -z "$1" ]]; then
        sudo tcpdump -i any -nn
    elif [[ $1 =~ ^[0-9]+$ ]] && [ $1 -ge 0 ] && [ $1 -le 65535 ]; then
        sudo tcpdump -i any port $1 -nn
    else
        echo "Error: Invalid port number. Please provide a port number in the range 0-65535."
    fi
}

function pys() {
    for ip in $(ip -4 a | grep inet | grep -v "127.0.0.1" | awk '{print $2}' | cut -d/ -f1); do
        echo "http://$ip:1111"
    done
    if command -v python3 &> /dev/null; then
        python3 -m http.server 1111
    elif command -v python &> /dev/null && python -c "import sys; print(sys.version_info[0])" | grep -q "2"; then
        python -m SimpleHTTPServer 1111
    else
        echo "Neither Python 2 nor Python 3 is available"
    fi
}

port() {
    local host=$1
    local port=$2
    local nc_result nmap_result output_color

    echo "Checking port $port on $host..."

    # 使用 nc 检测端口，抑制输出
    nc -zv -w 3 $host $port 2>&1 >/dev/null
    nc_result=$?

    # 使用 nmap 检测端口，抑制输出
    nmap_result=$(nmap -p $port $host 2>&1 | grep "$port" | grep -oE "(open|closed|filtered)")

    # 确定输出颜色
    if [ "$nc_result" -eq 0 ] || [ "$nmap_result" = "open" ]; then
        output_color="\033[0;32m" # 绿色
    else
        output_color="\033[0;31m" # 红色
    fi

    # 输出结果
    echo -e "nc result: $([ $nc_result -eq 0 ] && echo -e "${output_color}open\033[0m" || echo -e "${output_color}closed\033[0m")"
    echo -e "nmap result: ${output_color}${nmap_result:-unreachable}\033[0m"
}

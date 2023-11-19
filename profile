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
alias go='git checkout'
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
#solar\srv\idcard\idcard.sh
hostname=$(hostnamectl --static) 
echo "Machine name : $hostname"

os="$(uname)"

version="$(uname -r)"
echo "OS ${os} and kernel version is ${version}"

ip="$(ip addr show | grep inet | grep enp0s3 | awk '{print $2}' | cut -d '/' -f1)"
echo "IP : ${ip}"

total="$(free -h | grep Mem | awk '{print $2}')"

free="$(free -h | grep Mem | awk '{print $4}')"
echo "RAM : ${free} memory available on ${total} total memory"

df="$( df -h | grep root | cut -d '/' -f4 |  awk '{print $4}')"
echo "Disk : ${df} space left"

proc="$(while read noemie_line ; do

    echo "- $noemie_line"

done <<<  "$(ps -eo %mem=,command= --sort=-%mem | head -n 5 | awk '{print $2}' | rev | cut -d '/' -f1 | rev)"
)"
echo "Top 5 processes by RAM usage :
${proc}"

ports="$(while read noemie_line ; do
    nemid="$(echo $noemie_line | awk '{print $1}')"
    port="$(echo $noemie_line | awk '{print $5}' | rev | cut -d ':' -f1 | rev)"
    echo "- ${port} ${nemid}"
done <<<  "$(ss -alnptu | grep LISTEN)")"
echo "Listening ports :
${ports}"

dir="$(echo $PATH | tr ':' '\n' | sed 's/.*/- &/')"
echo "PATH directories :
${dir}"

url="$(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url')"

file="$(file /srv/idcard/random_cat_image | cut -d ':' -f2 | cut -d ' ' -f2)"
echo "Here is your random cat (${file} file) : ${url}"

#!/bin/bash

# Init
echo "Generating report...Standby..."
./tools/printf " ##### Incident Response report #####\n" &>f
./tools/printf "# Time and Date of report: " &>>f
./tools/date &>>f
./tools/printf "\n# System Uptime:" &>>f
./tools/uptime &>>f
./tools/printf "\n" &>>f

# OS info
./tools/printf '\n# OS info: Distribution and Linux version\n' &>> f
./tools/cat /proc/version &>> f

# Banners
./tools/printf "\n# Banners: printing system banners...\n" &>>f
./tools/printf '\n# Printing .. cat /etc/motd\n' &>>f
./tools/cat /etc/motd &>>f
./tools/printf '\n# Printing: cat /etc/banner\n' &>>f
./tools/cat /etc/banner &>>f
./tools/printf '\n# Printing: cat /etc/issue\n'  &>> f
./tools/cat /etc/issue  &>> f
./tools/printf '\n# Printing: cat /etc/issue.net\n'  &>>f
./tools/cat  /etc/issue.net &>>f

# Open Ports
./tools/printf '\n\n# Printing active network and loopback connections\n' &>>f
./tools/netstat -lap &>>f

# Iptables
./tools/printf '\n# Printing IPtables rules...\n' &>>f
./tools/xtables-multi iptables -S &>>f

# Running programs and proccesses
./tools/printf '\n# Listing all running processes:\n' &>>f
./tools/ps -aux &>>f

# Automatically executing programs
./tools/printf '\n# Listing Automatically executing programs:\n' &>> f
./tools/printf 'service --status-all\n' &>> f
service --status-all &>> f
#./tools/printf '\n# Printint contents of /etc/init.d /etc/rcS.d\n' &>>f
#./tools/ls /etc/init.d /etc/rcS.d &>>f

# Chrontab
./tools/printf '\n\n# Displaying all Users and crontab jobs:\n' &>>f
for user in $(./tools/cut -f1 -d: /etc/passwd); do ./tools/echo $user; ./tools/crontab -u $user -l; done &>>f

# Sudo users
./tools/printf '\n\n# Printing all Sudo groups and users:\n' &>>f
./tools/printf 'cat /etc/group | grep -e "root\|sudo\|wheel"\n' &>>f
./tools/cat /etc/group | ./tools/grep -e 'root\|sudo\|wheel' &>>f

# SetGID/SetUID applications
./tools/printf '\n\n# Printing all applications with SetGIG/SetUID permissinons:\n
find / -type f -perm /6000\n' &>>f
./tools/find / -type f -perm /6000 &>>f

# Weak Permitions on key files: 
./tools/printf '\n\n# Printing permissions of key files:\n' &>>f
./tools/printf 'ls -la /etc/passwd /etc/shadow /etc/group /var/log/wtmp /var/run/utmp/ /var/log/syslog /etc/pam.conf\n' &>>f
./tools/ls -la /etc/passwd /etc/shadow /etc/group /var/log/wtmp /var/run/utmp /var/log/syslog /etc/pam.conf &>>f

# PATH variables
./tools/printf '\n\n# Printing PATH and permissions of all PATHs\n' &>>f
./tools/echo $PATH &>>f
./tools/echo $PATH | tr ':' ' ' | sort | uniq | xargs ls -ld &>>f

# User activity Logging
./tools/printf '\n\n# Printing user activity logs:\n' &>>f
./tools/who &>>f
./tools/last &>>f

# PAM modules
./tools/printf '\n# Printing the PAM enabled components in /etc/pam.d/:\n\n' &>>f
./tools/ls -la /etc/pam.d/* &>>f

# finally print file.
./tools/mv ./f ir_report
#./tools/cat ./ir_report
./tools/echo "Incident response report finished: ir_report"
./tools/echo "Generating hashes of report: ir_report_hashes"
./tools/printf '# Time date group and hashes of ir_report:\n' &>ir_report_hashes
./tools/date &>>ir_report_hashes
./tools/printf "MD5sum hash: " &>>ir_report_hashes
./tools/md5sum ir_report &>>ir_report_hashes
./tools/printf "SHA1sum hash: " &>>ir_report_hashes
./tools/sha1sum ir_report &>>ir_report_hashes

# Recovering Logged in Users passwords from memory 
./tools/echo "Recovering Logged in Users passwords from memory to: ir_passwds:"
#./mimipenguin/mimipenguin.sh &>ir_passwds
./tools/cat ir_passwds

# generate image of memory using LiME

./tools/echo "Generating image of system memory..."
cd ./LiME/src
sudo make &> make_log
#sudo insmod lime*.ko path=../../ir_memory_dump.bin format=padded
#sudo rmmod lime
cd ../../
./tools/echo "System memory dumped to: ir_memory_dump"







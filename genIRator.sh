#!/bin/bash
# genIRator : automated forensic incident response and volatile memory acquisition
# Init
./tools/chmod 777 -R ./

echo "Generating report...Standby..."
./tools/printf " ##### Incident Response report #####\n" &>f
./tools/printf "# Time and Date of report: " &>>f
./tools/date &>>f
./tools/printf "\n# System Uptime:" &>>f
./tools/uptime &>>f

# OS info
./tools/printf '\n# OS info: Distribution and Linux version\n' &>> f
./tools/cat /proc/version &>> f

# Banners
./tools/printf "\n# Printing system banners...\n" &>>f
./tools/printf '\n# Printing .. cat /etc/motd\n' &>>f
./tools/cat /etc/motd &>>f
./tools/printf '\n# Printing: cat /etc/banner\n' &>>f
./tools/cat /etc/banner &>>f
./tools/printf '\n# Printing: cat /etc/issue\n'  &>> f
./tools/cat /etc/issue  &>> f
./tools/printf '\n# Printing: cat /etc/issue.net\n'  &>>f
./tools/cat  /etc/issue.net &>>f

# Open ports and network connections
./tools/printf '\n\n# Printing active network and loopback connections\n' &>>f
./tools/netstat -lap &>>f

# Iptables
./tools/printf '\n# Printing IPtables rules...\n' &>>f
./tools/xtables-multi iptables -S &>>f

# Running programs and processes
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
./tools/printf '\n\n# Printing all applications with SetGID/SetUID permissinons:\n
find / -type f -perm /6000\n' &>>f
./tools/find / -type f -perm /6000 &>>f

# Weak Permissions on key files: 
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

./tools/printf '\n# End of Report' &>>f

# finally print file.
./tools/mv ./f ir_report
#./tools/cat ./ir_report
./tools/echo "Incident response report finished: ir_report"
./tools/echo "Generating hashes of report: ir_report.hashes"
./tools/printf '# Time date group and hashes of ir_report:\n' &>ir_report.hashes
./tools/date &>>ir_report.hashes
./tools/printf "MD5sum hash: " &>>ir_report.hashes
./tools/md5sum ir_report &>>ir_report.hashes
./tools/printf "SHA1sum hash: " &>>ir_report.hashes
./tools/sha1sum ir_report &>>ir_report.hashes

# Recovering Logged in Users passwords from memory 
./tools/echo "Recovering Logged in Users passwords from memory to: ir_passwds:"
./tools/echo "...this may take a few minutes..."
./mimipenguin/mimipenguin.sh &>ir_passwds
./tools/cat ir_passwds

# generate image of memory using LiME

./tools/echo "Generating image of system memory...standby..."
cd ./LiME/src
sudo make &> make_log
retVal=$?
if [ $retVal -ne 0 ]; then
    ./tools/echo "Error in make, please check dependancies and try again"
    ./tools/cat make_log
    exit $retVal
else

sudo insmod lime*.ko path=../../ir_memory_dump.bin format=padded
sudo rmmod lime
cd ../../
./tools/echo "System memory dumped to: ir_memory_dump.bin"
./tools/echo "Saving hashes of memory dump to: ir_memory_dump.hashes"
./tools/printf '# Time date group and hashes of ir_memory_dump.hashes:\n' &>ir_memory_dump.hashes
./tools/echo "...depending on images size this may take some time..."
./tools/date &>>ir_memory_dump.hashes
./tools/printf "MD5sum hash: " &>>ir_memory_dump.hashes
./tools/md5sum ir_memory_dump.bin &>>ir_memory_dump.hashes
./tools/printf "SHA1sum hash: " &>>ir_memory_dump.hashes
./tools/sha1sum ir_memory_dump.bin &>>ir_memory_dump.hashes

./tools/echo "PS: Volitility standalone is included in this tool"
fi
./tools/echo "genIRator has finished, have nice day!"






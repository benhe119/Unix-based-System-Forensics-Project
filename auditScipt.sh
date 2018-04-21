#!/bin/bash

# Banners
printf "1: Banners: printing system banners...\n" &>f

printf '\nPrinting .. cat /etc/motd\n' &>>f
cat /etc/motd &>>f

printf '\nPrinting: cat /etc/banner\n' &>>f
cat /etc/banner &>>f

printf '\nPrinting: cat /etc/issue\n'  &>> f
cat /etc/issue  &>> f
printf '\nPrinting: cat /etc/issue.net\n'  &>>f
cat  /etc/issue.net &>>f

# OS info
printf '\n\nOS info: Distribution and Linux version\n' &>> f
cat /proc/version &>> f

# Automatically executing programs
printf '\n\nPrinting Automatically executing programs:\n' &>> f
printf 'service --status-all\n' &>> f
service --status-all &>> f
printf '\nls /etc/init.d /etc/rcS.d\n' &>>f
ls /etc/init.d /etc/rcS.d &>>f

printf '\n\nPrinting all Users crontab jobs:\n' &>>f
for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l; done &>>f

# SetGID/SetUID applications
printf '\n\nPrinting all applications with SetGIG/SetUID permissinons:\n
find / -type f -perm /6000\n' &>>f
find / -type f -perm /6000 &>>f

# Sudo users
printf '\n\nPrinting all Sudo groups and users:\n' &>>f
printf 'cat /etc/group | grep -e "root\|sudo\|wheel"\n' &>>f
cat /etc/group | grep -e 'root\|sudo\|wheel' &>>f

# Weak Permitions on key files: 
printf '\n\nPrinting permissions of key files:\n' &>>f
printf 'ls -la /etc/passwd /etc/shadow /etc/group /var/log/wtmp /var/run/utmp/ /var/log/syslog /etc/pam.conf\n' &>>f
ls -la /etc/passwd /etc/shadow /etc/group /var/log/wtmp /var/run/utmp /var/log/syslog /etc/pam.conf &>>f

# Open Ports
printf '\n\nPrinting active network and loopback connections\n' &>>f
netstat -lap &>>f

# PATH variables
printf '\n\nPrinting PATH and permissions of all PATHs\n' &>>f
echo $PATH &>>f
echo $PATH | tr ':' ' ' | sort | uniq | xargs ls -ld &>>f

# Logging
printf '\n\nPrinting user activity logs:\nwho ; last;\n' &>>f
who &>>f
last &>>f

# Security Modules
printf '\nPrinting IPtables...\n' &>>f
iptables -S &>>f
printf '\nPrinting the PAM enabled components in /etc/pam.d/:\n\n' &>>f
ls -la /etc/pam.d/* &>>f

# finally print file.
mv ./f lab2_audit_output
cat ./lab2_audit_output


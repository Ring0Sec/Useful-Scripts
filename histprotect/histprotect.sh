#/bin/bash
echo HistProtect at le service!
echo Straight up stolen from StackOverflow
echo But it gets the job done so why would I rewrite it
echo Making append-only
chattr +a /root/.bash_history 
chattr +a /root/.bash_profile 
chattr +a /root/.bash_login 
chattr +a /root/.profile 
chattr +a /root/.bash_logout 
chattr +a /root/.bashrc
echo Hardening environment variables
shopt -s histappend 
 echo "readonly PROMPT_COMMAND=\"history -a\"" >> /root/.bashrc
echo readonly HISTFILE >> /root/.bashrc
echo readonly HISTFILESIZE  >> /root/.bashrc
echo readonly HISTSIZE  >> /root/.bashrc
echo readonly HISTCMD  >> /root/.bashrc
echo readonly HISTCONTROL >> /root/.bashrc
echo readonly HISTIGNORE >> /root/.bashrc
chmod 750 csh 
chmod 750 tcsh 
chmod 750 ksh

echo Protecting any other users on the system
for i in $(find / -name .bash_history); do
chattr +a $i
done
for i in $(find / -name .bashrc); do
 echo "readonly PROMPT_COMMAND=\"history -a\"" >> $i
echo readonly HISTFILE >> $i
echo readonly HISTFILESIZE  >> $i
echo readonly HISTSIZE  >> $i
echo readonly HISTCMD  >> $i
echo readonly HISTCONTROL >> $i
echo readonly HISTIGNORE >> $i
done

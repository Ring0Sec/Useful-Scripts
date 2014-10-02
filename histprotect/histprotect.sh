#/bin/bash
echo HistProtect at le service!
echo Straight up stolen from StackOverflow, then improved
# http://superuser.com/questions/308882/secured-bash-history-usage
echo MOST of this is tested
echo But it gets the job done so why would I rewrite it
echo Making append-only
if [ -f /root/.bash_history ] ; then chattr +a /root/.bash_history ; fi
if [ -f /root/.bash_profile ] ; then chattr +a /root/.bash_profile  ; fi
if [ -f /root/.bash_login ] ; then chattr +a /root/.bash_login  ; fi
if [ -f /root/.profile ] ; then chattr +a /root/.profile  ; fi
if [ -f /root/.bash_logout ] ; then chattr +a /root/.bash_logout  ; fi 
if [ -f /root/.bashrc ] ; then chattr +a /root/.bashrc  ; fi
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
for i in $(find / -type f \( -name .bash_history -o -name .bashrc \)); do
if [ -f $i ] ; then  chmod 600 $i; chattr +a $i ; fi

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

echo "for i in \$(find / -type f \( -name .bash_history \)); do cat $i | grep \"history -c\" ; done >> /dev/null" >> /root/.bashrc
if [ $? -eq 1 ] ; then echo History clear detected; fi

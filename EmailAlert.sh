#!/bin/bash


#linkedin : https://www.linkedin.com/in/can-sayın-b332a157/
#cansayin.com

PATH=$PATH:$HOME/ .local/bin:$HOME/bin ; export PATH
ALERT_VX=0
path_dest=/couchbase/inst1/opt/couchbase/var/lib/couchbase/logs
log_name=error.log
logfile=$path_dest/${log_name}
oldlogfile=$path_dest/${log_name}_old
logfile_diff=$path_dest/${log_name}_diff
logfile_diff_codes=$path_dest/${log_name}_diff_error_codes
#cp -rp $log_file $oldlogfile
diff $oldlogfile $logfile > $logfile_diff
cat $logfile_diff | grep -i error | grep ^"> \[" | cut -d '>' -f3 | cut -d ':' -f3 > $logfile_diff_codes
host=`hostname`
usep=`cat $logfile_diff_codes | wc -l`
if [ "${usep}" -gt "${ALERT_VX}" ]; then
echo "There is and Error on $host. Please check." > /tmp/couchbase_db_alerts.out
echo "" >> /tmp/couchbase_db_alerts.out
echo "" >> /tmp/couchbase_db_alerts.out
cat $logfile_diff_codes >> /tmp/couchbase_db_alerts.out
tomail='xxxx@xxxx'
frommail='xxxx@xxxx'
smtpmail='smtp.xxxxx.com'
echo "There is and Error on $host. Please check." | /bin/mailx -s "$host Couchbase Error" -r "$frommail" -S smtp="$smtpmail" $tomail < /tmp/couchbase_db_alerts.out
fi
cp -rp $log_file $oldlogfile 
 
 
chmod 777 couchbase_db_alerts.sh
 
crontab -e 
*/10 * * * * sh /home/couchbase/couchbase_db_alerts.sh > /home/couchbase/couchbase_db_alerts.txt

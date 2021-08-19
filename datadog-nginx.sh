# When enable nginx integration logs, most likely
# Datadog will complain that it doesn't have
# permission to access nginx's log files
# modify group's perission as the following
# and restart Datadog agent

chmod 755 /var/log/nginx
chmod 644 /var/log/nginx/*.log
# if you already have old compressed files:
chmod 644 /var/log/nginx/*.gz
# change 640 to 755 for "create" directive
vim /etc/logrotate.d/nginx 

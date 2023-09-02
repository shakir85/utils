#!/bin/bash

# When you enable nginx integration logs, it's highly likely
# that Datadog will complain about not having
# permission to access nginx's log files.
# Modify the group's permissions as follows
# and then restart the Datadog agent.

chmod 755 /var/log/nginx
chmod 644 /var/log/nginx/*.log
# if you already have old compressed files:
chmod 644 /var/log/nginx/*.gz
# change 640 to 755 for "create" directive
vim /etc/logrotate.d/nginx 

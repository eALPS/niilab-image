#!/bin/bash
cat <<EOF | sudo tee /etc/rsyslog.d/code-server.conf 
:programname, isequal, "code-server"    @@syslog-server:514
EOF
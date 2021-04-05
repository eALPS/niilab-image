#!/bin/bash
curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
echo "source ~/.bash-preexec.sh" | tee -a ~/.bashrc
echo "preexec() { logger -t code-server[ealplus] "$1 exec"; }" | tee -a ~/.bashrc


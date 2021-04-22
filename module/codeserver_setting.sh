#!/bin/bash

#code server add extensions
code-server --install-extension ms-ceintl.vscode-language-pack-ja
code-server --install-extension emeraldwalk.runonsave

# setting code server
# argv.json mod
mkdir -p ~/.local/share/code-server/User/
cat <<EOF | tee ~/.local/share/code-server/User/argv.json
{
    "locale": "ja"
}
EOF
# settings.json mod
cat <<EOF | tee ~/.local/share/code-server/User/settings.json 
{
    "terminal.integrated.shell.linux": "/usr/bin/bash",
    "emeraldwalk.runonsave": {
        "commands": [

            {
                "match": ".*",
                "isAsync": true,
                "cmd": "logger -t code-server[ealplus] \${file} save"
            }
    ]
    
    },
    "workbench.colorTheme": "Default Dark+"
}
EOF
#!/bin/bash


#code server add extensions
#code-server --install-extension ms-ceintl.vscode-language-pack-ja --force
#code-server --install-extension ms-toolsai.jupyter --force
code-server --install-extension emeraldwalk.runonsave --force
#curl -OL https://github.com/microsoft/vscode-cpptools/releases/download/1.5.0/cpptools-linux.vsix
#code-server --install-extension cpptools-linux.vsix --force
#rm  cpptools-linux.vsix
#code-server --install-extension ms-vscode.cpptools

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
            },
            {
                "match": ".*",
                "isAsync": true,
                "cmd": "cd /workspace && git add -A > /dev/null 2>&1 && git commit -m \"\${file} save\" > /dev/null 2>&1 "
            },
    ]
    
    },
    "workbench.colorTheme": "Default Dark+"
}
EOF
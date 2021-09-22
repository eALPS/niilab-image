#!/bin/bash

<<<<<<< HEAD
#code server add extensions
code-server --install-extension ms-ceintl.vscode-language-pack-ja
code-server --install-extension ms-toolsai.jupyter
code-server --install-extension emeraldwalk.runonsave
code-server --install-extension ms-vscode.cpptools

=======
>>>>>>> 83f2b0886b3d38264a2b8da615e6e120c996633d
# setting code server
# argv.json mod
mkdir -p ~/.local/share/code-server/User/
cat <<EOF | tee ~/.local/share/code-server/User/argv.json
{
    "locale": "ja"
}
EOF

#code server add extensions
code-server --install-extension ms-ceintl.vscode-language-pack-ja
code-server --install-extension ms-toolsai.jupyter
code-server --install-extension emeraldwalk.runonsave
curl -OL https://github.com/microsoft/vscode-cpptools/releases/download/1.5.0/cpptools-linux.vsix
code-server --install-extension cpptools-linux.vsix
rm  cpptools-linux.vsix
#code-server --install-extension ms-vscode.cpptools


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
<<<<<<< HEAD
                "cmd": 'cd /workspace && git add -A > /dev/null 2>&1 && git commit -m "\${file} save" > /dev/null 2>&1 '
=======
                "cmd": "cd /workspace && git add -A  && git commit -m \"\${file} save\"  "
>>>>>>> 83f2b0886b3d38264a2b8da615e6e120c996633d
            },
    ]
    
    },
    "workbench.colorTheme": "Default Dark+"
}
EOF
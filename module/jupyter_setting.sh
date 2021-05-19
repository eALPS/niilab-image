#!/bin/bash
cat <<EOF | sudo tee ~/.jupyter/jupyter_notebook_config.py
c = get_config()
c.NotebookApp.allow_root = True # rootでも起動できるように
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.password = u'sha1:833fdc2d2783:1c4db1bf9540710fe6a49c00ffb51829271ff89e'
c.NotebookApp.notebook_dir = '/root/jupyter_files/'
c.IPKernelApp.pylab = 'inline'
EOF

cat <<EOF | sudo tee /etc/systemd/system/notebook.service
[Unit]
Description = Jupyter Notebook

[Service]
Type=simple
ExecStart= /root/anaconda3/bin/jupyter notebook --config=/root/.jupyter/jupyter_notebook_config.py
Restart=always

[Install]
WantedBy = multi-user.target
EOF

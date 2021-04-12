# lxd-build-image-action
このレポジトリは、LXDイメージをLXDサーバー無しで作成することを目的としています。
このレポジトリにタグを付けることで、LXDのイメージをgithub上で作成します。
コンテナにはレポジトリ上のすべてのファイルが「/github-action」にコピーされたあとにinit.shがコンテナ内で実行されます。
init.shの処理が完了したあと、「/github-action」は削除されReleaseにイメージが出力されます。
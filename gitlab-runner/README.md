[![](https://images.microbadger.com/badges/image/qq58945591/gitlab-runner.svg)](https://microbadger.com/images/qq58945591/gitlab-runner "Get your own image badge on microbadger.com")

# 关于本镜像:
这个是基于gitlab官方的Dockerfile使用轻量级alpine linux作为底层系统build的image,增加一些额外需要的软件包,方便在执行build任务时可以扩展功能.

### 包含的常用软件:

ssh-client
git
rsync
wget
python2.7
ansible

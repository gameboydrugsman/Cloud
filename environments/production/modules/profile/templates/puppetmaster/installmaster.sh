sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm ; \
sudo yum update -y ; \
sudo yum -y install puppetserver git && \
sudo rm -rf /etc/puppetlabs/code && \
cd /etc/puppetlabs && \
sudo git clone -b puppet https://github.com/jorisdejosselin/Cloud.git code

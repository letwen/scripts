#!/bin/bash
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel wget curl screen python-devel vim git

cd /usr/local/src
wget https://github.com/letwen/Source-package-upload-plan/raw/master/python-Source-Package/Python-3.7.1.tar.xz
tar xf Python-3.7.1.tar.xz

yum install gcc gcc-c++ zlib zlib-devel libffi-devel -y
cd Python-3.7.1
./configure --prefix=/usr/local/python-3.7.1
make && make install

ln -s /usr/local/python-3.7.1 /usr/local/python
ln -sf /usr/local/python/bin/* /usr/bin/
rm -f /usr/bin/python
ln -s /usr/bin/python3.7 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
pip install --upgrade pip

cd /usr/local
git clone https://github.com/formateddd/Pornhub.git
cd Pornhub && pip install -r requirements.txt

#Github : https://github.com/formateddd/Pornhub

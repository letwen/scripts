yum install unzip wget curl screen vim gcc-c++ openssl-devel python-devel -y
wget https://github.com/letwen/Source-package-upload-plan/raw/master/pip-Source-Package/get-pip-2018-12-03.py
python get-pip-2018-12-03.py
wget https://github.com/letwen/Source-package-upload-plan/raw/master/eoria.anar/xiyouMc-pornhubbot-master.zip
echo "[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" > /etc/yum.repos.d/mongodb.repo
yum makecache fast
yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod
unzip xiyouMc-pornhubbot-master.zip
cd pornhubbot
pip install -r requirements.txt

#### 1.更新openssl

```shell
yum install gcc perl-IPC-Cmd perl-Data-Dumper

cd openssl-3.0.4
./config --prefix=/usr/local/openssl
make
make install
ldd /usr/local/openssl/bin/openssl

#添加动态库的搜索路径（一定要填对）
echo "/usr/local/openssl/lib64">>/etc/ld.so.conf
#查看加载的动态库（看是否加载成功，是否有报错）
ldconfig -v
#  /usr/local/openssl/lib64:
#   ...

mv /usr/bin/openssl /usr/bin/openssl_old_bak
ln -s /usr/local/openssl/lib64/libcrypto.so.3 /usr/lib64/libcrypto.so.3
ln -s /usr/local/openssl/lib64/libssl.so.3 /usr/lib64/libssl.so.3
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
openssl version -a
```

#### 2.更新openssh
```shell
yum install zlib-devel pam-devel

cd  openssh-9.0p1
mv /etc/ssh /etc/ssh_bak
./configure --prefix=/usr/local/openssh --sysconfdir=/etc/ssh --with-pam --with-ssl-dir=/usr/local/openssl --with-md5-passwords --mandir=/usr/share/man --with-zlib=/usr/local/zlib --without-hardening
make
make install

#修改sshd配置

mv /usr/sbin/sshd /usr/sbin/sshd_bak
mv /etc/sysconfig/sshd /opt
mv  /usr/lib/systemd/system/sshd.service  /opt

cp -arf /usr/local/openssh/bin/* /usr/bin/
cp -arf /usr/local/openssh/sbin/sshd /usr/sbin/sshd

cp contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
cp -a contrib/redhat/sshd.pam /etc/pam.d/sshd.pam

systemctl daemon-reload
```

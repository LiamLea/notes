import os
import requests
import wget
import hashlib
import tarfile

def has_new_ver(ver_url,ver_file):

    if  not os.path.isfile(ver_file):
        return 1

    with open(ver_file) as fobj:
        local_ver=fobj.read().strip()

    remote_ver=requests.get(ver_url).text.strip()

    if local_ver==remote_ver:
        return 0
    return 1


def check_app(md5_url,app_fname):
    with open(app_fname,'rb') as fobj:
        md5=hashlib.md5()
        while 1:
            data=fobj.read(4096)
            if not data:
                break
            md5.update(data)
    if md5.hexdigest()==requests.get(md5_url).text.strip():
        return 1
    return 0

def deploy(app_fname,deploy_dir):
    tar=tarfile.open(app_fname)
    tar.extractall(path=deploy_dir)
    tar.close()

    link_dst='/var/www/html/nsd1903'
    link_src=os.path.basename(app_fname).replace('.tar.gz','')
    link_src=os.path.join(deploy_dir,link_src)
    if os.path.exists(link_dst):
        os.remove(link_dst)
    os.symlink(link_src,link_dst)



if __name__ == '__main__':
    # dep_dir='/var/www/html/deploy'
    ver_url='http://192.168.1.3/deploy/live_ver'
    ver_file='/var/www/html/deploy/live_ver'
    down_dir='/var/www/html/download'
    deploy_dir='/var/www/html/deploy'
    if not has_new_ver(ver_url,ver_file):
        print('未发现新版本')
        exit(1)

    version=requests.get(ver_url).text.strip()
    app_url='http://192.168.1.3/deploy/pkgs/myblog-%s.tar.gz' %version
    wget.download(app_url,down_dir)

    md5_url='http://192.168.1.3/deploy/pkgs/myblog-%s.md5' %version
    app_fname=app_url.split('/')[-1]
    app_fname=os.path.join(down_dir,app_fname)

    if  not check_app(md5_url,app_fname):
        print('软件已损坏')
        os.remove(app_fname)
        exit(1)

    deploy(app_fname,deploy_dir)

    if os.path.isfile('/var/www/html/deploy/live_ver'):
        os.remove('/var/www/html/deploy/live_ver')
    wget.download(ver_url,'/var/www/html/deploy/live_ver')

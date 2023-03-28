import os
import sys
import time
import hashlib
import tarfile
import pickle

def check_md5(fname):
    m=hashlib.md5()
    with open(fname,'rb') as fobj:
        while 1:
            data=fobj.read(4096)
            if not data:
                break
            m.update(data)
    return m.hexdigest()

def full_backup(src,dst,md5file):
    fname='%s/%s_full_%s.tar.gz' %(dst,os.path.basename(src),time.strftime('%Y%m%d'))

    tar=tarfile.open(fname,'w:gz')
    tar.add(src)
    tar.close()

    md5dict={}
    for path,folders,files in os.walk(src):
        for file in files:
            key=os.path.join(path,file)
            md5dict[key]=check_md5(key)

    with open(md5file,'wb') as fobj:
        pickle.dump(md5dict,fobj)

def incr_backup(src,dst,md5file):
    fname='%s/%s_incr_%s.tar.gz' %(dst,os.path.basename(src),time.strftime('%Y%m%d'))

    tar=tarfile.open(fname,'w:gz')

    with open(md5file,'rb') as fobj:
        old_md5=pickle.load(fobj)

    for path,folders,files in os.walk(src):
        for file in files:
            key=os.path.join(path,file)
            if old_md5.get(key) != check_md5(key):
                tar.add(key)
                old_md5[key]=check_md5(key)
    tar.close()

    with open(md5file,'wb') as fobj:
        pickle.dump(old_md5,fobj)


if __name__ == '__main__':
    src='/etc/security'
    dst='/tmp/backup'
    # md5file='/tmp/backup/security.md5'
    md5file='%s/%s.md5' %(dst,os.path.basename(src))
    if not os.path.isdir(dst):
        os.makedirs(dst)
    if time.strftime('%a')=='Mon':
        full_backup(src,dst,md5file)
    else:
        incr_backup(src,dst,md5file)
#!/bin/sh
# for RHEL 4.x
# test RHEL 4.8

# Check root
if [ ${EUID:-${UID}} != 0 ]; then
    echo "Not root"
    exit 1
fi

# Network ENV
#export http_proxy=http://192.168.1.1:8080/
#export https_proxy=http://192.168.1.1:8080/

export BSDIR=/tmp/yum-bootstrap

# Check that the prerequisite of yumconf is installed
rpm -q --whatprovides yumconf 2>&1 >/dev/null
if [ $? != 0 ]; then
    if [ !-f $BSDIR/redhat-yumconf-4-4.8.el4.nosrc.rpm ]; then
        wget -O $BSDIR/redhat-yumconf-4-4.8.el4.nosrc.rpm "https://wiki.centos.org/HowTos/PackageManagement/YumOnRHEL?action=AttachFile&do=get&target=redhat-yumconf-4-4.8.el4.nosrc.rpm"
    fi
    if [ !-f /usr/src/redhat/SOURCES/RHEL-Base.repo ]; then
        wget -O /usr/src/redhat/SOURCES/RHEL-Base.repo http://public-yum.oracle.com/public-yum-el4.repo
    fi
    rpmbuild --rebuild $BSDIR/redhat-yumconf-4-4.8.el4.nosrc.rpm
    rpm -Uvh /usr/src/redhat/RPMS/noarch/redhat-yumconf-4-4.8.el4.noarch.rpm
fi

if [ $? != 0 ]; then
        echo "You must have a package installed that provides yumconf."
        echo "See http://wiki.centos.org/HowTos/PackageManagement/YumOnRHEL"
        echo "for more details on how to accomplish this."
        exit 1;
fi
export ARCH=`uname -i`
#export SOURCE=http://mirror.centos.org/centos/4/os/$ARCH/CentOS/RPMS
#export SOURCE=http://vault.centos.org/4.7/os/$ARCH/CentOS/RPMS
export SOURCE=http://vault.centos.org/4.9/os/$ARCH/CentOS/RPMS

mkdir $BSDIR
wget -P $BSDIR -nH $SOURCE/yum-2.4.3-4.el4.centos.noarch.rpm
wget -P $BSDIR -nH $SOURCE/yum-metadata-parser-1.0-8.el4.centos.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/python-urlgrabber-2.9.8-2.noarch.rpm
wget -P $BSDIR -nH $SOURCE/python-elementtree-1.2.6-5.el4.centos.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/python-sqlite-1.1.7-1.2.1.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/sqlite-3.3.6-2.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/libxml2-python-2.6.16-12.6.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/rpm-python-4.3.3-32_nonptl.$ARCH.rpm
#wget -P $BSDIR -nH $SOURCE/rpm-4.3.3-32_nonptl.$ARCH.rpm
#wget -P $BSDIR -nH $SOURCE/rpm-libs-4.3.3-32_nonptl.$ARCH.rpm
#wget -P $BSDIR -nH $SOURCE/rpm-build-4.3.3-32_nonptl.$ARCH.rpm
#rpm -Uvh $BSDIR/yum* $BSDIR/python* $BSDIR/sqlite*
rpm -Uvh $BSDIR/python* $BSDIR/sqlite* $BSDIR/rpm* $BSDIR/libxml2* $BSDIR/yum*
if [ $? -eq 0 ]; then
        rm -rf $BSDIR
fi
# Fix the release package, otherwise $releasever is set to null
sed -i "s/centos-release/redhat-release/" /etc/yum.conf

# move
if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
    mv -v /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.dist
fi

if [ !-f /usr/share/rhn/RPM-GPG-KEY-oracle ]; then
    wget -O /usr/share/rhn/RPM-GPG-KEY-oracle http://public-yum.oracle.com/RPM-GPG-KEY-oracle-el4
fi


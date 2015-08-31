#!/bin/sh
# Check that the prerequisite of yumconf is installed
rpm -q --whatprovides yumconf 2>&1 >/dev/null
if [ $? != 0 ]; then
        echo "You must have a package installed that provides yumconf."
        echo "See http://wiki.centos.org/HowTos/PackageManagement/YumOnRHEL"
        echo "for more details on how to accomplish this."
        exit 1;
fi
export ARCH=`uname -i`
export BSDIR=/tmp/yum-bootstrap
export SOURCE=http://mirror.centos.org/centos/4/os/$ARCH/CentOS/RPMS
mkdir $BSDIR
wget -P $BSDIR -nH $SOURCE/yum-2.4.3-4.el4.centos.noarch.rpm
wget -P $BSDIR -nH $SOURCE/yum-metadata-parser-1.0-8.el4.centos.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/python-urlgrabber-2.9.8-2.noarch.rpm
wget -P $BSDIR -nH $SOURCE/python-elementtree-1.2.6-5.el4.centos.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/python-sqlite-1.1.7-1.2.1.$ARCH.rpm
wget -P $BSDIR -nH $SOURCE/sqlite-3.3.6-2.$ARCH.rpm
rpm -Uvh $BSDIR/yum* $BSDIR/python* $BSDIR/sqlite*
if [ $? -eq 0 ]; then
        rm -rf $BSDIR
fi
# Fix the release package, otherwise $releasever is set to null
sed -i "s/centos-release/redhat-release/" /etc/yum.conf

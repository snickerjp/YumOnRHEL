# YumOnRHEL

yum を RHEL 4.x (Redhat Enterprise Linux) で使えるようにするシェル

* Repository は **OracleLinux** に入れ替えている

元ネタは、ここ

* https://wiki.centos.org/HowTos/PackageManagement/YumOnRHEL

## ざっくり中でやっていること

* check root
* Network 環境設定
* check yumconf
* replace RHEL-Base.repo to OracleLinux **public-yum-el4.repo**
* install redhat-yumconf
* check ARCH
* set URL for wget
* wget require packages
* install yum & require packages
* remove BSDIR
* rename CentOS-Base.repo
* deploy GPG RPM-GPG-KEY-oracle-el4

# test 

* RHEL 4.8


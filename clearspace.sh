#!/bin/bash

# Reduce CentOS 6,7,8 disk space used

# Detect Linux distro/version

CentOS 7
cat /proc/version
(strings showing centos.org and Red Hat)
uname -a
(string has .el7.)
cat /etc/issue
(no info)


    CentOS          ->  /etc/centos-release, /etc/os-release, /etc/redhat-release, /etc/system-release
    Debian (old)    ->  /etc/debian_release, /etc/debian_version
    Debian (new)    ->  /etc/os-release
    Fedora          ->  /etc/fedora-release
    Gentoo          ->  /etc/gentoo-release
    Mandrake        ->  /etc/mandrake-release
    Novell SuSE     ->  /etc/SuSE-release
    Red Hat         ->  /etc/redhat-release, /etc/redhat_version
    Slackware       ->  /etc/slackware-release, /etc/slackware-version
    Solaris/Sparc   ->  /etc/release
    Sun JDS         ->  /etc/sun-release
    Ubuntu          ->  /etc/lsb-release, /etc/os-release
    Yellow dog      ->  /etc/yellowdog-release


if rpm -q yum-utils > /dev/null; then
  echo "yum-utils already installed."
else
  echo "Installing yum-utils..."
  yum -y install yum-utils
fi

echo 'Trimming .log files larger than 50M...'
find /var -name "*.log" \( \( -size +50M -mtime +7 \) -o -mtime +30 \) -exec truncate {} --size 0 \;

echo "Cleaning yum caches..."
yum clean all
rm -rf /var/cache/yum
rm -rf /var/tmp/yum-*

echo "Removing WP-CLI caches..."
rm -rf /root/.wp-cli/cache/*
rm -rf /home/*/.wp-cli/cache/*

echo "Removing old Linux kernels..."
(( $(rpm -E %{rhel}) >= 8 )) && dnf remove $(dnf repoquery --installonly --latest-limit=-3 -q)
(( $(rpm -E %{rhel}) <= 7 )) && package-cleanup --oldkernels --count=3

echo "Removing Composer caches..."
rm -rf /root/.composer/cache
rm -rf /home/*/.composer/cache

echo "Removing core dumps..."
find -regex ".*/core\.[0-9]+$" -delete

echo "Removing cPanel error log files..."
find /home/*/public_html/ -name error_log -delete

echo "Removing Node.JS caches..."
rm -rf /root/.npm /home/*/.npm /root/.node-gyp /home/*/.node-gyp /tmp/npm-*

echo 'Removing mock caches...'
rm -rf /var/cache/mock/* /var/lib/mock/*

echo 'Removing user caches...'
rm -rf /home/*/.cache/* /root/.cache/*



echo "All Done!"
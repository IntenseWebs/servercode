https://cloudspinx.com/build-open-vswitch-from-source-on-rocky-almalinux-rhel/
https://docs.openvswitch.org/en/latest/intro/install/general/

# Install from Git - Clone Repository: Fedora 42 & Bash, /usr/local/etc/openvswitch /usr/local/var
sudo dnf -y install epel-release
sudo dnf config-manager --set-enabled crb
sudo dnf install @'Development Tools' rpm-build dnf-plugins-core
sudo dnf -y install gcc make python3-devel openssl-devel \
    kernel-devel kernel-debug-devel rpm-build desktop-file-utils \
    groff-base libcap-ng-devel numactl-devel selinux-policy-devel \
    systemtap-sdt-devel unbound-devel unbound python3-sphinx \
    libbpf-devel libxdp-devel groff network-scripts
sudo dnf install python3-sphinx python3-devel libxdp-devel \
    numactl-devel selinux-policy-devel systemtap-sdt-devel \
    unbound unbound-devel

mkdir Repos && cd Repos
# VER=3.5.0 && wget https://www.openvswitch.org/releases/openvswitch-$VER.tar.gz

# cd openvswitch-$VER
git clone https://github.com/openvswitch/ovs.git
cd ovs
git checkout v3.5.0
./boot.sh
./configure
make rpm-fedora
# make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"

export PATH=$PATH:/usr/local/share/openvswitch/scripts
# sudo ovs-ctl start
sudo -E env "PATH=$PATH" ovs-ctl start
ovs-vsctl show

cd rpm/rpmbuild/RPMS/x86_64
ls -al

--------------------------------------


sudo systemctl enable --now openvswitch
systemctl status openvswitch.service
● openvswitch.service - Open vSwitch
   Loaded: loaded (/usr/lib/systemd/system/openvswitch.service; enabled; vendor preset: disabled)
   Active: active (exited) since Wed 2025-04-16 00:17:18 EAT; 5s ago
  Process: 93926 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 93926 (code=exited, status=0/SUCCESS)

Apr 16 00:17:18 rocky01.cloudspinx.com systemd[1]: Starting Open vSwitch...
Apr 16 00:17:18 rocky01.cloudspinx.com systemd[1]: Started Open vSwitch.

The command above will start other OVS services:

systemctl status ovs-vswitchd ovsdb-server

Log out of your current shell session, then log back in:

logout

Run the ovs-vsctl show command to verify the Open vSwitch (OVS) version:

$ ovs-vsctl show
8d2d42ed-88e7-45bc-b2d2-eb43e25763b1
    ovs_version: "3.5.0-1.el8"
# Kernel Compatibility: Ensure kernel-devel matches your running kernel (uname -r). If mismatched, update the kernel or install the correct kernel-devel package.
# DPDK (Optional): For high-performance setups, install dpdk and dpdk-devel, then add --with-dpdk to ./configure.
# Troubleshooting: Check logs in /var/log/openvswitch/ if services fail to start. Ensure the user has permissions (e.g., sudo usermod -aG openvswitch $USER).
# Source: The tarball is downloaded from openvswitch.org, and the Git repository is at github.com/openvswitch/ovs, tag v3.5.0


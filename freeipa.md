# FreeIPA requires over 2Gb+ in /usr
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
dnf install freeipa-server
man ipa-server-install
ipa-server-install
# man ipa-server-install --mkhomedir

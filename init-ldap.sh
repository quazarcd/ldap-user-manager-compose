#!/bin/bash
# init-ldap.sh

# Wait for LDAP to be ready
while ! ldapwhoami -x -H ldap://ldap:389 -D "cn=admin,dc=my-domain,dc=com" -w adminpw >/dev/null 2>&1; do
    echo "Waiting for LDAP to be ready..."
    sleep 2
done

echo "LDAP is ready. Creating initial structure..."

# Add the base structure and admin user
ldapadd -x -H ldap://ldap:389 -D "cn=admin,dc=my-domain,dc=com" -w adminpw << 'EOF'
dn: ou=people,dc=my-domain,dc=com
objectClass: organizationalUnit
objectClass: top
ou: people

dn: ou=groups,dc=my-domain,dc=com
objectClass: organizationalUnit
objectClass: top
ou: groups

dn: uid=admin,ou=people,dc=my-domain,dc=com
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: admin
cn: admin
sn: admin
uidNumber: 1000
gidNumber: 1000
homeDirectory: /home/admin
loginShell: /bin/bash
userPassword: adminpw

dn: cn=admins,ou=groups,dc=my-domain,dc=com
objectClass: posixGroup
objectClass: top
cn: admins
gidNumber: 1000
memberUid: admin
EOF

echo "Initial LDAP structure created."
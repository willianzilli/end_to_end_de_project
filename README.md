# ldap

ldapsearch -x -H ldap://host.docker.internal:389 -D "cn=admin,dc=openldap" -w rangerR0cks! -b "ou=group,dc=openldap" "(cn=trino)"
ldapsearch -x -H ldaps://host.docker.internal:636 -D "cn=admin,dc=openldap" -w rangerR0cks! -b "ou=group,dc=openldap" "(cn=trino)"

ldapsearch -H ldapi:/// -Y EXTERNAL -b cn=config olcTLSCertificateFile olcTLSCertificateKeyFile olcTLSCACertificateFile
openssl s_client -connect host.docker.internal:636 -CAfile /container/service/slapd/assets/certs/ca.crt

openssl s_client -connect host.docker.internal:636 -showcerts

ldapsearch -x -H ldaps://host.docker.internal:636 -D "cn=admin,dc=openldap" -w rangerR0cks! -b "dc=openldap" "(objectClass=*)"



ldapsearch -x -H ldaps://openldap:636 -D "cn=admin,dc=openldap" -w rangerR0cks!

openssl s_client -connect openldap:636 -CAfile /container/service/slapd/assets/certs/ca-chain.crt
openssl s_client -connect openldap:636 -CAfile /container/service/slapd/assets/certs/dhparam.pem
openssl s_client -connect openldap:636 -CAfile /etc/openldap/certs/ca-chain.crt

# teste trino connection via ssh
trino --server http://trino:80 --user trino --execute "SHOW CATALOGS"

# OpenMetadata access
trino@willianzilli.com.br
rangerR0cks!

admin@open-metadata.org
admin
# ldap

ldapsearch -x -H ldap://host.docker.internal:389 -D "cn=admin,dc=openldap" -w rangerR0cks! -b "ou=group,dc=openldap" "(cn=trino)"
ldapsearch -x -H ldaps://host.docker.internal:636 -D "cn=admin,dc=openldap" -w rangerR0cks! -b "ou=group,dc=openldap" "(cn=trino)"

ldapsearch -H ldapi:/// -Y EXTERNAL -b cn=config olcTLSCertificateFile olcTLSCertificateKeyFile olcTLSCACertificateFile
openssl s_client -connect host.docker.internal:636 -CAfile /container/service/slapd/assets/certs/ca.crt

openssl s_client -connect host.docker.internal:636 -showcerts

ldapsearch -x -H ldaps://host.docker.internal:636 -D "cn=admin,dc=openldap" -w rangerR0cks! -b "dc=openldap" "(objectClass=*)"



ldapsearch -x -H ldaps://openldap:636 -D "cn=admin,dc=openldap" -w rangerR0cks!

openssl s_client -connect openldap:636 -CAfile /container/service/slapd/assets/certs/ca-root.crt

ldapsearch \
--hostname host.docker.internal \
--port 636 \
--useSSL \
--trustStorePath /home/docker-certificates/truststore.jks \
--trustStorePasswordFile /home/docker-certificates/truststore.credential \
--keyStorePath /home/docker-certificates/keystore.jks \
--keyStorePasswordFile /home/docker-certificates/truststore.credential

trino \
--server https://trino:8443 \
--keystore-path /home/docker-certificates/keystore.jks \
--keystore-password UnIx529p \
--truststore-path /home/docker-certificates/truststore.jks \
--truststore-password UnIx529p \
--user admin
--password

# teste trino connection via ssh
trino --server http://trino:80 --user test --execute "SHOW CATALOGS"

jdbc:trino://trino:8443/?SSL=true&SSLVerification=NONE

# OpenMetadata access
trino@willianzilli.com.br
rangerR0cks!

admin@open-metadata.org
admin
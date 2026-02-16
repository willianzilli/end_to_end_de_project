#  Certificate Generation Script
# 
# This script automates the process of generating a certificate chain with a root CA, an intermediate CA, and a server certificate. The script uses OpenSSL to create and sign the certificates.
# 
# ## Prerequisites
# 
# - OpenSSL installed on your system
# 
# ## Usage
# 
# 1. Make the script executable:
# 
#     ```bash
#     chmod +x selfsigned-certificate.sh
#     ```
# 
# 2. Run the script:
# 
#     ```bash
#     ./selfsigned-certificate.sh
#     ```
# 
# 3. Enter the path to the SAN (Subject Alternative Name) file when prompted.
# 
# ## SAN File Format
# 
# The SAN file should be in the following format:
# 
# ```ini
# [ req ]
# distinguished_name = req_distinguished_name
# req_extensions = v3_req
# 
# [ req_distinguished_name ]
# 
# [ v3_req ]
# basicConstraints = CA:FALSE
# keyUsage = nonRepudiation, digitalSignature, keyEncipherment
# subjectAltName = @alt_names
# 
# [ alt_names ]
# DNS.1 = example.com
# DNS.2 = www.example.com
# IP.1 = 192.168.1.1
# 
# ```
# 
# ## Output
# 
# The script generates the following files:
# 
# - `ca-root.key`: Root CA private key
# - `ca-root.crt`: Root CA certificate
# - `ca-intermediate.key`: Intermediate CA private key
# - `ca-intermediate.csr`: Intermediate CA CSR
# - `ca-intermediate.crt`: Intermediate CA certificate
# - `server.key`: Server private key
# - `server.csr`: Server CSR
# - `server.crt`: Server certificate
# - `ca-chain.crt`: CA chain certificate
# - `keystore.pem`: Combined server key, certificate, and CA chain
# 
# ## Notes
# 
# - The script uses SHA-256 for signing.
# - The root CA certificate is valid for 10 years (3650 days).
# - The intermediate CA certificate is valid for 5 years (1825 days).
# - The server certificate is valid for 2.25 years (825 days).

read -p "Enter SAN file: " san_file

# CN = $(grep '^CN' ${san_file} | awk '{print $3}')

# echo "Generating certificates for CN=${CN} using SAN file: ${san_file}"

# Generate root private key
# openssl genrsa -out ca-root.key 2048

# Create self-signed root certificate
# openssl req -x509 -new -nodes -key ca-root.key -days 3650 -out ca-root.crt -subj "//CN=host.docker.internal"  || exit 1

# # Generate intermediate private key
# openssl genrsa -out ca-intermediate.key 4096

# # Create CSR for intermediate CA
# openssl req -new -key ca-intermediate.key -out ca-intermediate.csr -config $san_file.ca

# # Sign intermediate CA with root CA
# openssl x509 -req -in ca-intermediate.csr -CA ca-root.crt -CAkey ca-root.key -CAcreateserial -out ca-intermediate.crt -days 1825 -sha256

  # Generate server private key
openssl genrsa -out server.key 2048

# Create CSR for server
openssl req -new -key server.key -out server.csr -subj "//CN=host.docker.internal" -config $san_file  || exit 1

# Sign server certificate with intermediate CA
# openssl x509 -req -in server.csr -CA ca-root.crt -CAkey ca-root.key -CAcreateserial -out server.crt -days 825 -sha256 -notext -batch
openssl x509 -req -in server.csr -CA ca-root.crt -CAkey ca-root.key -CAcreateserial -out server.crt -days 825 -extensions v3_req -extfile ${san_file} || exit 1

# TRUSTSTORE
keytool -import -trustcacerts -alias ca-root -file ca-root.crt -keystore truststore.jks -storepass UnIx529p
keytool -import -trustcacerts -alias server-cert -file server.crt -keystore truststore.jks -storepass UnIx529p
openssl pkcs12 -in truststore.jks -out truststore.pem -nokeys -nodes -storepass UnIx529p

# KEYSTORE
# Generate a new JKS keystore
openssl pkcs12 -export -in server.crt -inkey server.key -out keystore.p12 -name server-cert -CAfile ca-root.crt -caname root
keytool -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 -destkeystore keystore.jks -deststoretype PKCS12
openssl pkcs12 -in keystore.p12 -out keystore.pem -nodes

# Create a credential file for the keystore
echo "UnIx529p" > keystore.credential
echo "UnIx529p" > truststore.credential

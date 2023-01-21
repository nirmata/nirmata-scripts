<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the below arguments:

1. secret name
2. namespace
3. pem file path
4. key file path
5. domain name

Ex: ./script. sh secret name server-certificate default file.pem key.key nirmata.io

This script performs the below:
1. Check certs present along with domain and expiry check
2. Check secret and namespace exists or not
3. Take backup of secret
4. Create new secret
5. Restart haprroxy pods

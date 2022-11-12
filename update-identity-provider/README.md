This script is used to update the identity provider of users to SAML using a csv file which consists of a namespaces, usernames and email addresses

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script

<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the Nirmata API token for your tenant. 

Required Arguments:
```sh
$1 - Nirmata URL
$2 - Path to csv file consisting of namespaces, username and email (See example csv file for reference)

```

<ins>**Note:**</ins> 

The script only updates the identity provider to SAML. It does not change anything else.

```sh

$ ./update-identity-provider.sh https://nirmata.io sample-file.csv

Enter the Nirmata API token:

User "sagar-devops5" updated


```


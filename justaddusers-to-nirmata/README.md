This script is used to create new users  in Nirmata using a csv file which consists of a namespaces, usernames and email addresses

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script

<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the Nirmata API token for your tenant. 

<ins>**Required Arguments:**</ins>


```sh
$1 - Nirmata URL
$2 - Path to csv file consisting of namespaces, username and email (See example csv file for reference)

```

<ins>**Note:**</ins> 

If user already exists then the script will not create a user again.

```sh

$ ./addusers.sh https://nirmata.io sample-file.csv

Enter the Nirmata API token:

User "sagar-devops2" created successfully
User "sagar-devops5" created successfully
User "sagar-devops7" created successfully




```


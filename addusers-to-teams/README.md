This script is used to create new users and add them to teams in Nirmata using a csv file which consists of a namespaces, usernames and email addresses

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

If user already exists then the script will not be able to add the user to the required team. This script only works for new users.

```sh

$ ./addusers-to-teams.sh https://nirmata.io sample-file.csv

Enter the Nirmata URL:

User sagar-devops5 added successfully to "random-ns-test-ea1qa-team"



```


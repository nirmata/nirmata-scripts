This script is used to create teams, catalogs and environments in Nirmata using a csv file which consists of a list of namespaces and environment types

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

The teams in Nirmata are created by appending a string `"ea1qa-team"` to the namespace. The catalogs are created by appending a string `"ea1qa-catalog"` to the namespace and the environments are created by appending a string `"ea1qa-team"` to the namespace. The cluster nickname `"ea1qa"` can be updated in the script if needed

```sh

$ ./create-teams-catalog-env-tshirt.sh https://nirmata.io sample-tshirt-size.csv calico-ipip4



```


This script is used to find out the memorycapacity, memorylimit, memoryrequest, memoryUsage and licenses used by a cluster in Nirmata

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script
- 
NOTE: Admin id for the superadmin account can be found from the developer tools under Network tab when logged in with your superadmin email address. 

![alt Admin id](https://github.com/nirmata/nirmata-scripts/blob/main/setpass/setpass.PNG)

Here is the example from developer tools. The role should be sysadmin and the id that follows the "hasSession: false" string the is the id of your Nirmata superadmin account. 

```JavaScript 
{"role":"sysadmin","tenantName":"System Administrators","name":"sagar@nirmata.com","tenantId":"e5deec03-dc1d-4371-9d76-c2756bb6dbf0","hasSession":false,"id":"ecc0ed90-3fd4-484e-ad21-xxxxxxxxxxxx","isDisabled":false,"isActivated":true,"fullname":"sagar@nirmata.com","email":"sagar@nirmata.com","identityProvider":"Local"}
```

<ins>**Usage:**</ins>

Execute the script and provide the inputs requested by the script. This script will allow you to set the password for specific tenant superadmin using their user id's in Nirmata. 

```sh

```


This script is used to set password for superadmins of newly created Nirmata tenant in existing instance of Nirmata.

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script
- Nirmata tenant with a super admin configured
- The script runs in an interactive mode, so make sure you have below information when you execute the script:
  - superadmin email address
  - superadmin password
  - Nirmata URL
  - Tenant name in Nirmata
  - Admin id for the Nirmata superadmin account

NOTE: Admin id for the superadmin account can be found from the developer tools under Network tab when logged in with your superadmin email address. 

![alt Admin id](https://github.com/nirmata/nirmata-scripts/blob/main/setpass/setpass.PNG)

Here is the example from developer tools. The role should be sysadmin and the id that follows the "hasSession: false" string the is the id of your Nirmata superadmin account. 

{"role":"sysadmin","tenantName":"System Administrators","name":"sagar@nirmata.com","tenantId":"e5deec03-dc1d-4371-9d76-c2756bb6dbf0","hasSession":false,"id":"ecc0ed90-3fd4-484e-ad21-xxxxxxxxxxxx","isDisabled":false,"isActivated":true,"fullname":"sagar@nirmata.com","email":"sagar@nirmata.com","identityProvider":"Local"}

<ins>**Usage:**</ins>

Execute the script and provide the inputs requested by the script. This script will allow you to set the password for specific tenant superadmin using their user id's in Nirmata. 

```sh
$ ./setpass.sh

Enter the sysadmin email id:
sagar@nirmata.com

Enter the sysadmin password:

Enter the https Nirmata URL:
https://pe31.nirmata.co

Enter the tenant name:
mytest-tenant

Fetching tenant id
05d60444-6ba3-4009-b145-86549d32cd08

Fetching user ID's
--------------------
mytest-tenant-admin
931abf88-c3c1-4722-918b-93328f29d640
qa-admin
9ce655a7-7d85-462f-9f83-2e103df0a3ee

Enter the user id for whom you want to set the password:
9ce655a7-7d85-462f-9f83-2e103df0a3ee

Enter the password for the userid you just entered:
Updating password
{
  "id" : "9ce655a7-7d85-462f-9f83-2e103df0a3ee",
  "service" : "Users",
  "modelIndex" : "User",
  "uri" : "/users/api/users/9ce655a7-7d85-462f-9f83-2e103df0a3ee",
  "parent" : {
    "id" : "05d60444-6ba3-4009-b145-86549d32cd08",
    "service" : "Users",
    "modelIndex" : "Tenant",
    "uri" : "/users/api/tenants/05d60444-6ba3-4009-b145-86549d32cd08",
    "childRelation" : "users"
  },
  "createdBy" : "sagar@nirmata.com",
  "createdOn" : 1656698462756,
  "modifiedBy" : "sagar@nirmata.com",
  "modifiedOn" : 1658577988083,
  "generation" : 25,
  "ancestors" : [ {
    "service" : "Users",
    "modelIndex" : "Tenant",
    "id" : "05d60444-6ba3-4009-b145-86549d32cd08"
  }, {
    "service" : "Users",
    "modelIndex" : "Root",
    "id" : "824393e7-49c1-4ff1-ae15-b816ce86b9e0"
  } ],
  "additionalProperties" : { },
  "alarms" : [ ],
  "name" : "qa-admin",
  "password" : "gxB4M9/9RlbiiNSJ6LmRIzrPGy2VgauoPfXU8ml5bQN+XdoP",
  "email" : "qa-admin@nirmata.com",
  "role" : "admin",
  "lastLogin" : "7/5/22, 5:51 PM",
  "resetToken" : "0631ccf3-3a44-42ab-9066-74dcd76c792b",
  "resetTokenExpiration" : null,
  "apiKey" : null,
  "pictureUrl" : null,
  "phone" : null,
  "identityProvider" : "Local",
  "mfaKey" : null,
  "mfaEnabled" : false,
  "firstLoginAfterMfaEnable" : false,
  "mfaUri" : null,
  "preferences" : { },
  "oauthProfiles" : [ ],
  "session" : [ ],
  "orgs" : [ {
    "id" : "11b20c6a-ad2b-4837-a8eb-df0705bbb3c4",
    "service" : "Users",
    "modelIndex" : "Organization",
    "uri" : "/users/api/organizations/11b20c6a-ad2b-4837-a8eb-df0705bbb3c4"
  } ],
  "teams" : [ ]
}
```


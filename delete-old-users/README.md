

This script is used to delete the users from Nirmata who have not logged into Nirmata for more than 365 days. 

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script

<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the Nirmata API token for your tenant. 

Required Arguments:
```sh
$1 - Nirmata URL
```

```sh

[root@saas delete-old-users]# ./delete-old-users.sh https://nirmata.io
Enter the Nirmata API token:


Username: Shuting
Last login: 6/29/22 9:21 AM
No of days since last login: 280

Username: damien
Last login: 4/5/23 3:19 PM
No of days since last login: 0

Username: Jim - Gmail
Last login: 8/7/20 4:30 AM
No of days since last login: 971

Deleting user Jim - Gmail from Nirmata...
{"tenantId":"45b34043-2844-48ca-b14c-a1944d322c8c","create":[],"update":[{"service":"Users","modelIndex":"Tenant","id":"45b34043-2844-48ca-b14c-a1944d322c8c","generation":1679,"modifiedBy":"sagar@nirmata.com","modifiedOn":1680724518407,"lastUserModificationBy":"sagar@nirmata.com","lastUserModificationOn":1680724518407,"users":[{"service":"Users","modelIndex":"User","id":"2108f997-b23a-4425-b075-5a2d7295e101"},{"service":"Users","modelIndex":"User","id":"098863b3-0dd7-4443-b030-b7e62b19a5ee"},{"service":"Users","modelIndex":"User","id":"18d35a20-3d3e-42ef-8483-d2af8f2f8ec5"},{"service":"Users","modelIndex":"User","id":"1663f8f4-6209-44a3-aefe-142863bf6e2c"},{"service":"Users","modelIndex":"User","id":"e83efaca-772f-4d08-9955-7d41cdc6f9ff"},{"service":"Users","modelIndex":"User","id":"13aa584d-3612-448b-bfb3-c727dd993862"},{"service":"Users","modelIndex":"User","id":"df764584-69b8-4b82-a8b3-83dad4ab2abc"},{"service":"Users","modelIndex":"User","id":"b4eee4a0-b137-4475-bf15-146ea52ed3de"},{"service":"Users","modelIndex":"User","id":"7454cbc8-09eb-40b2-a1cd-c0ef41fe0144"},{"service":"Users","modelIndex":"User","id":"512e63ff-d88b-4e4a-8ee1-7752ab2ce582"},{"service":"Users","modelIndex":"User","id":"a3baaa34-8073-4e9c-9bce-c7c76cdd1b6e"},{"service":"Users","modelIndex":"User","id":"e42368d1-c852-4aab-bd5c-6c389aec4a49"},{"service":"Users","modelIndex":"User","id":"42f37eb4-9837-4c61-8dac-e4c9b0f4968c"},{"service":"Users","modelIndex":"User","id":"4a405135-6a7b-473d-bb72-b7513a3b830f"},{"service":"Users","modelIndex":"User","id":"48f88d6a-fa68-4062-98ef-4edf9a395360"},{"service":"Users","modelIndex":"User","id":"193d901d-bb4e-4822-aaba-11831374e7bd"},{"service":"Users","modelIndex":"User","id":"cc245c97-5d3a-4ed5-853d-8c8a15b92fd7"},{"service":"Users","modelIndex":"User","id":"8de0f00d-d683-468d-acbe-3be4e42b3f06"},{"service":"Users","modelIndex":"User","id":"d3f6cf65-09cd-40ad-9fdb-7c4b6cc37b08"},{"service":"Users","modelIndex":"User","id":"f27c1d15-1ecc-4ae0-b369-27c118cce612"},{"service":"Users","modelIndex":"User","id":"77aba124-51c5-4d7e-b245-405db113735d"},{"service":"Users","modelIndex":"User","id":"60e9db78-393d-47cc-944b-6b21757b75f1"},{"service":"Users","modelIndex":"User","id":"abe6de0e-bc3b-4cac-bf96-09949ee82f97"},{"service":"Users","modelIndex":"User","id":"ad40b3ed-dbfd-4f0d-8c6c-41599a06601d"},{"service":"Users","modelIndex":"User","id":"e0ab0168-bb44-4e83-a5c6-9c500582a003"},{"service":"Users","modelIndex":"User","id":"fd494fd9-aab6-4af4-b244-1e290c31bf4d"},{"service":"Users","modelIndex":"User","id":"fcdc2805-9614-460b-bbc3-a9f8a972d39e"},{"service":"Users","modelIndex":"User","id":"4a56d57a-bf97-4b3a-b1c6-f8638d76d14b"},{"service":"Users","modelIndex":"User","id":"ca74af52-cf5e-446c-b59e-af608a288396"},{"service":"Users","modelIndex":"User","id":"e56f7e53-66d4-46ba-8c12-9591995f0b5c"},{"service":"Users","modelIndex":"User","id":"836f44a9-7b13-48a3-ab69-7e6db1b5f470"},{"service":"Users","modelIndex":"User","id":"d568665d-200b-45e0-a69d-3a098c062cc7"},{"service":"Users","modelIndex":"User","id":"b3ec671d-db3a-4f39-8aa0-3042f604aa69"},{"service":"Users","modelIndex":"User","id":"7ff26e5c-78a9-41f3-990b-eefbdaba86d6"},{"service":"Users","modelIndex":"User","id":"4cf148fa-f4b1-40c2-8ebc-a8b91660b75f"},{"service":"Users","modelIndex":"User","id":"029d9394-3e37-4301-b170-492d42eb52d4"},{"service":"Users","modelIndex":"User","id":"3a675530-f42a-435b-99c7-5e0c5d4c6429"},{"service":"Users","modelIndex":"User","id":"fcc1894d-289d-4670-ae5c-9d5fa5084034"},{"service":"Users","modelIndex":"User","id":"fc93cdc5-4106-4cfe-9b22-9f020163dece"}]},{"service":"Users","modelIndex":"Team","id":"47826d49-3122-4e91-aaf5-dc345aceccad","generation":7,"modifiedBy":"sagar@nirmata.com","modifiedOn":1680724518404,"lastUserModificationBy":"sagar@nirmata.com","lastUserModificationOn":1680724518404,"users":[]},{"service":"Users","modelIndex":"Organization","id":"7bbf889e-3d82-4a89-bade-87fe5efa3372","generation":821,"modifiedBy":"sagar@nirmata.com","modifiedOn":1680724518399,"lastUserModificationBy":"sagar@nirmata.com","lastUserModificationOn":1680724518399,"users":[{"service":"Users","modelIndex":"User","id":"2108f997-b23a-4425-b075-5a2d7295e101"},{"service":"Users","modelIndex":"User","id":"098863b3-0dd7-4443-b030-b7e62b19a5ee"},{"service":"Users","modelIndex":"User","id":"18d35a20-3d3e-42ef-8483-d2af8f2f8ec5"},{"service":"Users","modelIndex":"User","id":"1663f8f4-6209-44a3-aefe-142863bf6e2c"},{"service":"Users","modelIndex":"User","id":"e83efaca-772f-4d08-9955-7d41cdc6f9ff"},{"service":"Users","modelIndex":"User","id":"13aa584d-3612-448b-bfb3-c727dd993862"},{"service":"Users","modelIndex":"User","id":"df764584-69b8-4b82-a8b3-83dad4ab2abc"},{"service":"Users","modelIndex":"User","id":"b4eee4a0-b137-4475-bf15-146ea52ed3de"},{"service":"Users","modelIndex":"User","id":"7454cbc8-09eb-40b2-a1cd-c0ef41fe0144"},{"service":"Users","modelIndex":"User","id":"512e63ff-d88b-4e4a-8ee1-7752ab2ce582"},{"service":"Users","modelIndex":"User","id":"a3baaa34-8073-4e9c-9bce-c7c76cdd1b6e"},{"service":"Users","modelIndex":"User","id":"e42368d1-c852-4aab-bd5c-6c389aec4a49"},{"service":"Users","modelIndex":"User","id":"42f37eb4-9837-4c61-8dac-e4c9b0f4968c"},{"service":"Users","modelIndex":"User","id":"4a405135-6a7b-473d-bb72-b7513a3b830f"},{"service":"Users","modelIndex":"User","id":"48f88d6a-fa68-4062-98ef-4edf9a395360"},{"service":"Users","modelIndex":"User","id":"193d901d-bb4e-4822-aaba-11831374e7bd"},{"service":"Users","modelIndex":"User","id":"cc245c97-5d3a-4ed5-853d-8c8a15b92fd7"},{"service":"Users","modelIndex":"User","id":"8de0f00d-d683-468d-acbe-3be4e42b3f06"},{"service":"Users","modelIndex":"User","id":"d3f6cf65-09cd-40ad-9fdb-7c4b6cc37b08"},{"service":"Users","modelIndex":"User","id":"f27c1d15-1ecc-4ae0-b369-27c118cce612"},{"service":"Users","modelIndex":"User","id":"77aba124-51c5-4d7e-b245-405db113735d"},{"service":"Users","modelIndex":"User","id":"60e9db78-393d-47cc-944b-6b21757b75f1"},{"service":"Users","modelIndex":"User","id":"abe6de0e-bc3b-4cac-bf96-09949ee82f97"},{"service":"Users","modelIndex":"User","id":"ad40b3ed-dbfd-4f0d-8c6c-41599a06601d"},{"service":"Users","modelIndex":"User","id":"e0ab0168-bb44-4e83-a5c6-9c500582a003"},{"service":"Users","modelIndex":"User","id":"fd494fd9-aab6-4af4-b244-1e290c31bf4d"},{"service":"Users","modelIndex":"User","id":"fcdc2805-9614-460b-bbc3-a9f8a972d39e"},{"service":"Users","modelIndex":"User","id":"4a56d57a-bf97-4b3a-b1c6-f8638d76d14b"},{"service":"Users","modelIndex":"User","id":"ca74af52-cf5e-446c-b59e-af608a288396"},{"service":"Users","modelIndex":"User","id":"e56f7e53-66d4-46ba-8c12-9591995f0b5c"},{"service":"Users","modelIndex":"User","id":"836f44a9-7b13-48a3-ab69-7e6db1b5f470"},{"service":"Users","modelIndex":"User","id":"d568665d-200b-45e0-a69d-3a098c062cc7"},{"service":"Users","modelIndex":"User","id":"b3ec671d-db3a-4f39-8aa0-3042f604aa69"},{"service":"Users","modelIndex":"User","id":"7ff26e5c-78a9-41f3-990b-eefbdaba86d6"},{"service":"Users","modelIndex":"User","id":"4cf148fa-f4b1-40c2-8ebc-a8b91660b75f"},{"service":"Users","modelIndex":"User","id":"029d9394-3e37-4301-b170-492d42eb52d4"},{"service":"Users","modelIndex":"User","id":"3a675530-f42a-435b-99c7-5e0c5d4c6429"},{"service":"Users","modelIndex":"User","id":"fcc1894d-289d-4670-ae5c-9d5fa5084034"},{"service":"Users","modelIndex":"User","id":"fc93cdc5-4106-4cfe-9b22-9f020163dece"}]}],"changeId":"a264a7d9-c5a8-4917-b9dc-4177babc3a88","sequenceId":"ee7cd1e4-c66a-414e-bb32-27b9a961306a","delete":[{"service":"Users","modelIndex":"User","id":"f49ba8f5-69b6-4d4b-9d70-d28cf80639ca"}],"timestamp":1680724518465}

Username: ritesh@nirmata.com
Last login: 5/20/22 3:33 PM
No of days since last login: 320

Username: Ritesh P
Last login: 10/28/21 10:24 PM
No of days since last login: 523

Username: Ritesh Dev
Last login: 11/10/21 6:43 PM
No of days since last login: 510

Username: Yun2
Last login: 2/27/23 9:17 PM
No of days since last login: 36

Username: jim@nirmata.com
Last login: 12/24/21 5:07 PM
No of days since last login: 466

Username: aniket@nirmata.com
Last login: 3/22/23 10:37 AM
No of days since last login: 14

Username: Anubhav-anusharm
Last login: 2/9/23 7:45 PM
No of days since last login: 54

Username: Arundathi
Last login: 2/8/22 12:18 PM
No of days since last login: 421

Username: yun@nirmata.com
Last login: 2/1/23 11:28 PM
No of days since last login: 62

Username: dolis
Last login: 4/5/23 4:59 PM
No of days since last login: 0

Username: sagar
Last login: 4/5/23 7:54 PM
No of days since last login: 0

Username: toledo.damien@gmail.com
Last login: 3/28/23 10:06 PM
No of days since last login: 7

Username: Arundathi-nirmata
Last login: 3/31/23 11:11 AM
No of days since last login: 5

Username: DevOps-user
Last login: 2/16/23 12:02 PM
No of days since last login: 48

Username: Anubhav.Sharma
Last login: 12/8/21 4:18 AM
No of days since last login: 483

Username: Jim.Bugwadia@nirmata.com
Last login: 12/28/21 7:16 PM
No of days since last login: 462

Username: aniket devops
Last login: 10/4/22 10:32 AM
No of days since last login: 183

Username: Somit
Last login: 2/28/23 8:56 AM
No of days since last login: 36

Username: Chip
Last login: 8/2/22 7:21 PM
No of days since last login: 245

Username: Vivek M
Last login: 3/8/23 10:51 AM
No of days since last login: 28

Username: Arjun
Last login: 2/16/23 5:50 AM
No of days since last login: 48

Username: Vikash Kaushik
Last login: 4/4/23 8:20 AM
No of days since last login: 1

Username: Atul
Last login: 4/5/23 11:05 AM
No of days since last login: 0

Username: Parikshit
Last login: 12/28/22 11:17 AM
No of days since last login: 98

Username: Sathya
Last login: 2/15/23 11:50 AM
No of days since last login: 49

Username: sagar-devops
Last login: 12/15/22 3:37 PM
No of days since last login: 110

Username: anubhav@nirmata.com
Last login: 4/5/23 5:34 PM
No of days since last login: 0

Username: Anudeep
Last login: 4/5/23 2:17 PM
No of days since last login: 0

Username: Vivekanandhan
Last login: 1/11/23 2:28 PM
No of days since last login: 84

Username: anuddeephnalla@gmail.com
Last login: 2/16/23 5:14 PM
No of days since last login: 47

Username: anudeep.11703301@gmail.com
Last login: 2/13/23 9:50 AM
No of days since last login: 51

Username: anudeep-devops
Last login: 4/5/23 2:10 PM
No of days since last login: 0

Deleted Users list:
-------------------
Jim - Gmail

```

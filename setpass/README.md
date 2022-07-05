This script is used to set password for superadmins of Nirmata tenants.

Prerequisite:

- Make sure you have created a tenant with a super admin in Nirmata
- Make sure you have below information handy when running the script
  - superadmin email address
  - superadmin password for the tenant
  - Nirmata URL
  - Tenant name in Nirmata
  - Admin id for the Nirmata superadmin account

NOTE: Admin id for the superadmin account can be found from the developer tools under Network tab when logged in by your superadmin email address. 

{"accounts":[{"role":"admin","tenantName":"nirmata-eng","name":"sagar@nirmata.com","tenantId":"fcdf70d5-56e7-4c48-b4c9-254dabe2bf91","hasSession":false,"id":"9ddf9054-4c37-4f0e-b9cf-c9457b6502d2","isDisabled":false,"isActivated":true,"fullname":"sagar@nirmata.com","email":"sagar@nirmata.com","identityProvider":"Local"},{"role":"sysadmin","tenantName":"System Administrators","name":"sagar@nirmata.com","tenantId":"e5deec03-dc1d-4371-9d76-c2756bb6dbf0","hasSession":false,"id":"ecc0ed90-3fd4-484e-ad21-f13b84646d62","isDisabled":false,"isActivated":true,"fullname":"sagar@nirmata.com","email":"sagar@nirmata.com","identityProvider":"Local"},{"role":"admin","tenantName":"mytest-tenant","phone":"","name":"mytest-tenant-admin","tenantId":"05d60444-6ba3-4009-b145-86549d32cd08","hasSession":false,"id":"931abf88-c3c1-4722-918b-93328f29d640","isDisabled":false,"isActivated":false,"fullname":"mytest-tenant-admin","email":"sagar@nirmata.com","identityProvider":"Local"}],"message":"Multiple accounts","email":null,"status":200}

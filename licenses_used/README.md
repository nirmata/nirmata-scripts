This script is used to find out the memorycapacity, memorylimit, memoryrequest, memoryUsage and licenses used by a cluster in Nirmata

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script



<ins>**Usage:**</ins>

Execute the script and provide the Nirmata API token for your tenant. Also, update the NIRMATAURL variable in the script based on your environment. 

```sh
root@ip-172-31-81-194:~/scripts/addcluster# ./collect-memory-info.sh

Enter the Nirmata API token:


------------------------------------------------------------------------------------------------------------------------
CLUSTERNAME                              MEMORY_LIMIT    MEMORY_REQUEST  MEMORY_CAPACITY MEMORY_USAGE    LICENSES_USED
------------------------------------------------------------------------------------------------------------------------
mustufa-on-prem-cilium                   4.88            4.15            16              7.75            1
sb-cluster-01                            2.64            1.62            8               4.96            1
test-conjur                              1.62            1.05            8               2.52            1
testss01                                 4.73            2.31            8               4.61            1
testss22                                 5.17            1.98            16              4.49            1
tests6                                   6.89            2.92            15              7.06            1
calico-ipip4                             13.71           7.89            52              22.10           2
nirmata-prod-poc-aks                     103.63          78.29           102             32.00           4
sb-windows-novartis-01                   1.61            1.21            12              2.83            1
eks-ss                                   1.27            0.85            4               0.73            1
test-mrt-1                               1.45            0.92            8               0.00            1
------------------------------------------------------------------------------------------------------------------------
                                                                                         TOTAL_LICENSES: 15

NOTE: All the memory values defined in the table above are in GiB

```


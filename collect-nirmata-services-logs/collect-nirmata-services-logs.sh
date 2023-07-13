#!/bin/bash

if [ $# -lt 3 ]; then
	echo "Usage: <script> <NirmataURL> <Nirmata-service> <Namespace>"
	echo ""
	echo "Eg: <script> https://www.nirmata.io <Nirmata-service> <Namespace>"
	echo "Eg: <script> https://www.nirmata.io config nirmata"
        echo "Nirmata Services: activity,catalog,cluster,config,environments,users"

else
	NIRMATAURL=$1
	SERVICENAME=$2
        NAMESPACE=$3
	echo "====================="
	echo "Enabling DEBUG Mode"
	echo "====================="
        for i in {1..5}; do
		curl -s -k -X PUT -d "{\"name\": \"com.nirmata\", \"level\": \"DEBUG\"}" $NIRMATAURL/$SERVICENAME//logger?name=com.nirmata
	done
	sleep 10
        echo "Checking is changed to DEBUG Mode"
	curl -k $NIRMATAURL/$SERVICENAME//logger?name=com.nirmata
	sleep 10
	Replicas=$(kubectl -n $NAMESPACE get deployment $SERVICENAME -o jsonpath='{.spec.replicas}')
	echo "Current Replicas of $SERVICENAME: $Replicas"
        echo "Scaling deployment $SERVICENAME to 1"
	kubectl -n $NAMESPACE scale deployment $SERVICENAME --replicas=1
	sleep 5
	pod_name=$(kubectl get pods -n $NAMESPACE -l nirmata.io/service.name=$SERVICENAME -o jsonpath='{.items[0].metadata.name}')
	current_date=$(date +%Y-%m-%d)
	echo "collecting logs of $pod_name and saving in file named '$SERVICENAME-${current_date}'.log"
	echo "Please wait for 10 Mins , dont press anything!"
	kubectl -n $NAMESPACE logs -f $pod_name --tail=500 >> $SERVICENAME-${current_date}.log & sleep 600 ; kill $!
	sleep 10
        echo "====================="
        echo "Disabling DEBUG Mode"
        echo "====================="
	for i in {1..5}; do
                curl -s -k -X PUT -d "{\"name\": \"com.nirmata\", \"level\": \"WARN\"}" $NIRMATAURL/$SERVICENAME//logger?name=com.nirmata
        done
        sleep 10
        echo "Checking is changed to WARN Mode"
	curl -k $NIRMATAURL/$SERVICENAME//logger?name=com.nirmata
	sleep 10
        echo "Scaling deployment $SERVICENAME to $Replicas"
        kubectl -n $NAMESPACE scale deployment $SERVICENAME --replicas=$Replicas
        sleep 5
	echo "The logs are saved in the current directory with name '$SERVICENAME-${current_date}'.log, please share it via JIRA/Email"
fi

#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
G="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script start time $TIMESTAMP"  &>>LOGFILE

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 .. $R FAILED $N"
    else
        echo -e "$2 .. $G success $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " $R EEROR: PLEASE RUN THIS script with root access $N"
    exit 52 # it will stop here
else
    echo  -e " $G you are root user $N"
fi     #it was used to close the if statement 

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "copyied mongodb repo"

yum install mongodb-org -y &>> LOGFILE

VALIDATE $? "installing mongodb"

systemctl enable mongod &>> LOGFILE

VALIDATE $? "enabling mongodb"

systemctl start mongod &>> LOGFILE

VALIDATE $? "start mongodb"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>> LOGFILE

VALIDATE $? "remote access"

systemctl restart mongod &>> LOGFILE

VALIDATE $? "restart mongodb"
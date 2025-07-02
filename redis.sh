#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
G="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
#exec &>$LOGFILE

echo "script start time $TIMESTAMP"  &>>LOGFILE

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 .. $R FAILED $N"
        exit 1
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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "installing remi repo"

yum module enable redis:remi-6.2 -y &>>LOGFILE

VALIDATE $? "installing remi:6.2"

yum install redis -y &>>LOGFILE

VALIDATE $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>LOGFILE

VALIDATE $? "allowing remote connections"

systemctl enable redis &>>LOGFILE 

VALIDATE $? "redis enable"

systemctl start redis &>>LOGFILE

VALIDATE $? "start redis"



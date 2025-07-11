#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
G="\e[33m"
N="\e[0m"
#MONGODB_HOST=

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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

dnf module disable nodejs -y &>>LOGFILE

VALIDATE $? "disable nodejs"

dnf module enable nodejs:18 -y &>>LOGFILE

VALIDATE $? "enable nodejs:18"

dnf install nodejs -y &>>LOGFILE

VALIDATE $? "installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop &>>LOGFILE
    VALIDATE $? "useradding for roboshop"
else
    echo "user already exists"
fi

mkdir -p /app &>>LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>LOGFILE

VALIDATE $? "copying the file from remote"

cd /app &>>LOGFILE

VALIDATE $? "into app directory"

unzip -o /tmp/cart.zip &>>LOGFILE

VALIDATE $? "unzip catalogue the file"

cd /app &>>LOGFILE

VALIDATE $? "into app directory"

npm install &>>LOGFILE

VALIDATE $? "installing dependecies"

#use obslute path because catalougue exist here
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>LOGFILE

VALIDATE $? "copying from remote repo"

systemctl daemon-reload &>>LOGFILE

VALIDATE $? "reload daemon service"

systemctl enable cart &>>LOGFILE

VALIDATE $? "enable cart service"

systemctl start cart &>>LOGFILE

VALIDATE $? "starting cart service"
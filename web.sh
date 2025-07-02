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

dnf install nginx -y &>>LOGFILE

VALIDATE $? "install nginx"

systemctl enable nginx &>>LOGFILE

VALIDATE $? "enable nginx"

systemctl start nginx &>>LOGFILE

VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>LOGFILE

VALIDATE $? "remove default html nginx"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>LOGFILE

VALIDATE $? "downloaded web application"

cd /usr/share/nginx/html &>>LOGFILE

VALIDATE $? "moving to nginx html dir"

unzip -o /tmp/web.zip &>>LOGFILE

VALIDATE $? "unzip web"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>LOGFILE

VALIDATE $? "sopy reverse proxy nginx"

systemctl restart nginx &>>LOGFILE

VALIDATE $? "restart nginx"






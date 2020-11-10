#!/bin/bash

today=$(date "+%Y%m%d")
#today=`date -d "yesterday" +%Y%m%d`
#today=20201111
#收件箱
EMAIL_RECIVER="a@123.net b@123.net c@123.net"

#发送者邮箱
EMAIL_SENDER=xxxx@qq.com
#邮箱用户名
EMAIL_USERNAME=xxxx@qq.com
#邮箱密码
#使用qq邮箱进行发送需要注意：首先需要开启：POP3/SMTP服务，其次发送邮件的密码需要使用在开启POP3/SMTP服务时候腾讯提供的第三方客户端登陆码。
EMAIL_PASSWORD=111122dddxcfdd
EMAIL_SMTPHOST=smtp.qq.com

scp_func(){
scp root@192.168.1.5:/data/interface/abc/zip/$today/abc$today\_99lj.zip /root/aaa/
scp root@192.168.1.5:/data/interface/abb/zip/$today/abb$today\_99lj.zip /root/aaa/
scp root@192.168.1.5:/data/interface/add/zip/$today/add$today\_99lj.zip /root/aaa/
}




sendemail_func(){
#附件路径
FILE1_PATH="/root/aaa/abc${today}_99lj.zip /root/aaa/abb${today}_99lj.zip /root/aaa//add${today}_99lj.zip"
EMAIL_TITLE="文件提取并发送"
EMAIL_CONTENT="
获取文件如附件
"
sendEmail -f ${EMAIL_SENDER} -t ${EMAIL_RECIVER} -s ${EMAIL_SMTPHOST} -u ${EMAIL_TITLE} -o tls=no  -xu ${EMAIL_USERNAME} -xp ${EMAIL_PASSWORD} -m ${EMAIL_CONTENT} -a ${FILE1_PATH} -o message-charset=utf-8

sleep 1
#保留两天文件
find /root/aaa/*.zip -type f -mtime +2 -exec rm {} \;

}

#做一个无限循环，要是没取到他会无限去抓文件，直到抓到
while_fucn(){
while [ ! -f /root/pepsico/invoice$today\_99lj.zip ]
do
scp_func
sleep 5
done
sleep 2
sendemail_func
}


main(){
scp_func
test -f /root/pepsico/invoice$today\_99lj.zip
if [[ $? -eq 0 ]];then
sendemail_func
else
while_fucn
fi

}

main
echo "${today} send successful!!" >> ./sendmail.log



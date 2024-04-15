# shell script that combines all the commands from the previous steps. This script should be run on your EC2 #instance:

#To use this script:

#Save it to a file, for example install_kafka.sh.


#Make it executable:
#   bash
 #  chmod +x install_kafka.sh



#Run it:
 #  bash
 #  ./install_kafka.sh
   
#!/bin/bash

# Update and install necessary software
sudo yum update -y
#sudo yum install -y java-1.8.0-openjdk git

# Download and extract Apache Kafka
wget https://downloads.apache.org/kafka/3.5.2/kafka_2.13-3.5.2.tgz
tar xzf kafka_2.13-3.5.2.tgz

# Start Zookeeper and Kafka server
nohup ~/kafka_2.13-3.5.2/bin/zookeeper-server-start.sh ~/kafka_2.13-3.5.2/config/zookeeper.properties > ~/zookeeper.log 2>&1 &
nohup ~/kafka_2.13-3.5.2/bin/kafka-server-start.sh ~/kafka_2.13-3.5.2/config/server.properties > ~/kafka.log 2>&1 &

# Enable Kafka and Zookeeper on startup
echo "nohup ~/kafka_2.13-3.5.2/bin/zookeeper-server-start.sh ~/kafka_2.13-3.5.2/config/zookeeper.properties > ~/zookeeper.log 2>&1 &" | sudo tee -a /etc/rc.d/rc.local
echo "nohup ~/kafka_2.13-3.5.2/bin/kafka-server-start.sh ~/kafka_2.13-3.5.2/config/server.properties > ~/kafka.log 2>&1 &" | sudo tee -a /etc/rc.d/rc.local
sudo chmod +x /etc/rc.d/rc.local

# Install sbt for Kafka Manager
wget https://github.com/sbt/sbt/releases/download/v1.3.13/sbt-1.3.13.tgz
tar xzf sbt-1.3.13.tgz
sudo mv sbt /usr/local
export PATH=/usr/local/sbt/bin:$PATH

# Download and start Kafka Manager
git clone https://github.com/yahoo/CMAK.git
cd CMAK
sbt clean dist
unzip target/universal/cmak-*.zip -d ~/ 
nohup ~/cmak-*/bin/cmak -Dconfig.file=conf/application.conf -Dhttp.port=9000 > ~/cmak.log 2>&1 &

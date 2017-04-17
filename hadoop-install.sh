#/bin/bash
#set -x
export HADOOP_VERSION=2.7.2 HIVE_VERSION=1.2.1 SPARK_VERSION=1.6.1
if [ -z "$HADOOP_VERSION" -o -z "$HIVE_VERSION" -o -z "$SPARK_VERSION" ];then
    echo "not exists"
    exit
else
    echo "HADOOP_VERSION = $HADOOP_VERSION,HIVE_VERSION=$HIVE_VERSION,SPARK_VERSION=$SPARK_VERSION"
fi
echo "start install hadoop-cluster"
sleep 2s
echo "1.check install dir /install-hadoop"
mkdir -p /install-hadoop && mkdir -p /opt/java/
echo  "2. install jdk8 "
tar -zxvf /install-hadoop/jdk-8u121-linux-x64.tar.gz -C /opt/java/
echo " 3.check env java_home && hadoop_home "
if [ -z "$JAVA_HOME" -o -z "$HADOOP_HOME" -o -z "$HIVE_HOME" ];then
    echo "not exists"
    exit
else
    echo "$JAVA_HOME && $HADOOP_HOME && $HIVE_HOME "
fi
chown -R root:root $JAVA_HOME
if [ $? -ne 0 ]; then
	exit
fi
echo  "4. install hadoop,hive,spark,glibc and create softlink to hadoop,hive,spark"
tar -zxvf /install-hadoop/hadoop-2.7.2.tar.gz -C /opt/ && \
tar -zxvf /install-hadoop/apache-hive-1.2.1-bin.tar.gz -C /opt/ && \
tar -zxvf /install-hadoop/spark-1.6.1-bin-2.7.2.tgz -C /opt/ && \
tar -zxvf /install-hadoop/glibc-2.14.tar.gz -C /opt/
ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop && \
ln -s /opt/apache-hive-${HIVE_VERSION}-bin /opt/hive && \
ln -s /opt/spark-${SPARK_VERSION}-bin-${HADOOP_VERSION} /opt/spark && \
mkdir -p $HADOOP_HOME/logs

if [ $? -ne 0 ]; then
	exit
fi
echo " 5. add hadoop-lzo-nativelib && hadoop-lzo-0.4.20.jar && mysql jdbc && json-serde && json-udf && "
tar -zxvf /install-hadoop/hadoop-lzo-lib.tar && \
cp -r /install-hadoop/lib/* ${HADOOP_HOME}/lib/native && \
cp /install-hadoop/hadoop-lzo-0.4.20.jar ${HADOOP_HOME}/share/hadoop/common && \
cp /install-hadoop/mysql-connector-java-5.1.41.jar ${HIVE_HOME}/lib && cp /install-hadoop/json-*.jar ${HIVE_HOME}/lib

echo " 6. add update hadoop,hive,spark configs shell to opt dir "
cp -r /install-hadoop/update_*.sh /opt/

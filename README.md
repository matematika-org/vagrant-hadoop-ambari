# vagrant hadoop ambary

**original:**  
https://github.com/wardviaene/hadoop-ops-course


vagrant up

$ vi /etc/hosts 

remove localhost


http://192.168.0.10:8080/#/login


admin/admin

master.ambari
node1.ambari
node2.ambari
node3.ambari


* HDFS
* YARN + MapReduce2
* ZooKeeper
* Ambari Metrics



./usr/hdp/2.3.6.0-3796/hadoop-mapreduce/sbin/mr-jobhistory-daemon.sh start historyserver







$ sudo su - hdfs
$ hadoop fs -mkdir /user/ambari

$ hadoop fs -chown ambari:ambari /user/ambari

s su - ambari

$ git clone https://github.com/wardviaene/hadoop-ops-course

$ hadoop fs -put /home/ambari/hadoop-ops-course/data/constitution.txt 

$ hadoop fs -ls

$ yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar wordcount constitution.txt wordcount_output

$ hadoop fs -ls wordcount_output

$ hadoop fs -cat wordcount_output/part-r-00000


<br/>

### Spark2


    # yum install -y mysql-connector-java

    # ls -l  /usr/share/java/mysql-connector-java.jar

    # ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar

    # ls -l /var/lib/ambari-server/resources/mysql-connector-java.jar 


<br/>

$ pyspark

text_file = sc.textFile("hdfs:///user/ambari/constitution.txt");

counts = text_file.flatMap(lambda line: line.split(" ")).map(lambda word: (word,1)).reduceByKey(lambda a, b: a + b)

counts.collect()

counts.saveAsTextFile("hdfs:///user/ambari/wordCount_spark_output")




```
Traceback (most recent call last):
  File "/usr/lib/ambari-agent/lib/resource_management/core/source.py", line 195, in get_content
    web_file = opener.open(req)
  File "/usr/lib64/python2.7/urllib2.py", line 437, in open
    response = meth(req, response)
  File "/usr/lib64/python2.7/urllib2.py", line 550, in http_response
    'http', request, response, code, msg, hdrs)
  File "/usr/lib64/python2.7/urllib2.py", line 475, in error
    return self._call_chain(*args)
  File "/usr/lib64/python2.7/urllib2.py", line 409, in _call_chain
    result = func(*args)
  File "/usr/lib64/python2.7/urllib2.py", line 558, in http_error_default
    raise HTTPError(req.get_full_url(), code, msg, hdrs, fp)
HTTPError: HTTP Error 404: Not Found

The above exception was the cause of the following exception:

Traceback (most recent call last):
  File "/var/lib/ambari-agent/cache/stacks/HDP/3.0/services/HIVE/package/scripts/hive_client.py", line 60, in <module>
    HiveClient().execute()
  File "/usr/lib/ambari-agent/lib/resource_management/libraries/script/script.py", line 352, in execute
    method(env)
  File "/var/lib/ambari-agent/cache/stacks/HDP/3.0/services/HIVE/package/scripts/hive_client.py", line 40, in install
    self.configure(env)
  File "/var/lib/ambari-agent/cache/stacks/HDP/3.0/services/HIVE/package/scripts/hive_client.py", line 48, in configure
    hive(name='client')
  File "/var/lib/ambari-agent/cache/stacks/HDP/3.0/services/HIVE/package/scripts/hive.py", line 114, in hive
    jdbc_connector(params.hive_jdbc_target, params.hive_previous_jdbc_jar)
  File "/var/lib/ambari-agent/cache/stacks/HDP/3.0/services/HIVE/package/scripts/hive.py", line 634, in jdbc_connector
    File(params.downloaded_custom_connector, content = DownloadSource(params.driver_curl_source))
  File "/usr/lib/ambari-agent/lib/resource_management/core/base.py", line 166, in __init__
    self.env.run()
  File "/usr/lib/ambari-agent/lib/resource_management/core/environment.py", line 160, in run
    self.run_action(resource, action)
  File "/usr/lib/ambari-agent/lib/resource_management/core/environment.py", line 124, in run_action
    provider_action()
  File "/usr/lib/ambari-agent/lib/resource_management/core/providers/system.py", line 123, in action_create
    content = self._get_content()
  File "/usr/lib/ambari-agent/lib/resource_management/core/providers/system.py", line 160, in _get_content
    return content()
  File "/usr/lib/ambari-agent/lib/resource_management/core/source.py", line 52, in __call__
    return self.get_content()
  File "/usr/lib/ambari-agent/lib/resource_management/core/source.py", line 197, in get_content
    raise Fail("Failed to download file from {0} due to HTTP error: {1}".format(self.url, str(ex)))
resource_management.core.exceptions.Fail: Failed to download file from http://master.ambari:8080/resources/mysql-connector-java.jar due to HTTP error: HTTP Error 404: Not Found
```


<br/>

### HIVE

# sudo mv /usr/hdp/3.1.4.0-315/hive/lib/log4j-slf4j-impl-2.10.0.jar /usr/hdp/3.1.4.0-315/hive/lib/log4j-slf4j-impl-2.10.0.jar.backup

sudo -u hdfs hadoop fs -chown -R hive:hadoop /warehouse/tablespace/managed/hive

sudo -u hdfs hadoop fs -chown -R ambari /warehouse/tablespace/managed/hive

$ beeline

ambari/ambari

// Not works for me
// !connect jdbc:hive2://master.ambari:10000

CREATE TABLE customers (id INT, firstname STRING, lastname STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;

INSERT INTO customers (id, firstname, lastname) VALUES (1, 'John', 'Smith');

INSERT INTO customers (id, firstname, lastname) VALUES (2, 'Bob', 'Smith');

INSERT INTO customers (id, firstname, lastname) VALUES (3, 'Emma', 'Smith');

quit

<br/>

$ sudo -u hdfs hadoop fs -mkdir -p /apps/hive/warehouse/customers/

$ sudo -u hdfs hadoop fs -chown -R ambari /apps/hive/warehouse/customers/

$ hadoop fs -put ./hadoop-ops-course/data/names-tabs.csv /apps/hive/warehouse/customers/

$ hadoop fs -ls /apps/hive/warehouse/customers/


<br/>


$ beeline

ambari/ambari

select * from customers;


<br/>

$ spark-shell

sqlContext.sql("SELECT * from customers").take(2);





 vi /var/lib/ambari-server/ambari-env.sh

<!-- title: Monitoring -->
<!-- subtitle: Monitoring@CD -->

# Overview
Monitoring values a lot in continuous delivery daily operation. 
This document summaries monitoring solutions used in SCO(SmartCloud Orchestrator) CD(Continuous Delivery) team. 


As seen in this [wiki](https://w3-connections.mycompany.com/wikis/home?lang=en-us#!/wiki/Wa164cdefa962_4f64_a55c_4a0b956c9b07/page/Infrastructure)
Multiple systems running in SCO CD infrastructure, including build system, FVT system, cloud platform, etc. 
These applications are all critical for product, and impacts availability, quality and even release of product.
So monitoring is essential for these applications to make sure the availability and no degrade in application performance.

# Monitoring Solutions

## Introduction
SCO monitoring solution covers both server monitoring and application monitoring. 
	
+ **Server monitoring** monitors resources of xServers, blade centers, virtual machines, and other server which used in CD infrastructure, 
	matrix includes CPU, memory, hard disk, network IO, and other matrix that impact application availability and performance; 
	For VMware products, we adopt monitoring solutions supplied VMware.
+ **Application monitoring** monitors the health of applications, includes two types of matrix:
	* Statable matrix: Monitors status of an application, indicate whether it is available;
	* Numeric matrix: Monitors numeric data for applications. E.g., how many concurrent connections for Apache server, 
		how many builds generated per day, average testing time, etc.

## Monitoring Protocols
`Protocols` here indicates which method is used for each server/application to talk to monitoring server.
Table 1 below summaries protocols and sample monitoring tools used for each type of monitoring.

<html>
	<head>
		<title></title>
	</head>
	<body>
		<table align="center" border="1" cellpadding="1" cellspacing="1" style="width: 500px;">
			<thead>
				<tr>
					<th scope="col" style="background-color: rgb(204, 204, 204);">
						Category</th>
					<th scope="col" style="background-color: rgb(204, 204, 204);">
						Protocols</th>
					<th scope="col" style="background-color: rgb(204, 204, 204);">
						Sample Tools</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th style="text-align: center; vertical-align: middle; background-color: rgb(204, 204, 204);">
						Server</th>
					<td>
						<p>
							SNMP;Scripts</p>
					</td>
					<td style="text-align: left; vertical-align: top;">
						<p>
							Cacti;Graphite;Ganglia</p>
					</td>
				</tr>
				<tr>
					<th style="text-align: center; vertical-align: middle; background-color: rgb(204, 204, 204);">
						Application</th>
					<td>
						<p>
							JMX;Scripts</p>
					</td>
					<td style="text-align: left; vertical-align: top;">
						<p>
							Graphite;AWStat</p>
					</td>
				</tr>
			</tbody>
		</table>
		<p style="text-align: center;">
			Table 1.Summary of Monitoring Protocol in SCO CD</p>
	</body>
</html>

## Deployment and Maintenance
We use `Chef` for all the monitoring solution deployment and maintenance, just as addressed in `Chef` website:

+	<p>&ldquo;Chef is an automation platform that transforms infrastructure into code. 
	Stop thinking in terms of physical and virtual servers.
	With Chef, your real asset is the code that brings those servers and the services they provide to life.
	An automated infrastructure can accelerate your time to market, help you manage scale and complexity, 
	and safeguard your systems. &rdquo;<sup>[1]</sup></p>

With all deployment available via codes in cookbooks, roles, environments, the only thing need do to deploy and maintain
monitoring infrastructure is just drag and drop items in `run_list` and customize `nodes` for designated servers/applications.
Each monitoring server/client is actually a combination of multiple recipes, roles in certain environment.

# Monitoring Tools Introduction
In the following sections, it will introduce tools used in SCO CD monitoring solutions.
There also will be a sample code on how to customize to monitor your application.

## Cacti

Cacti is a complete network graphing solution. Although it's targeted at network graphing, 
it is useful for server basic utilization monitoring. There are also plenty of templates 
and plug-ins available in the internet. It supplies easy user interface to setup and configure.


We use cacti to monitor xServers, VMs, blade centers, VMware vCenter and ESXi, we also use cacti
to perform some application level monitoring, like Apache concurrent connection.


As illustrates in Graph 1. Cacti server translates the data receives from cacti client and illustrates them in web UI, 
cacti client is server or device running with snmpd client.


![Graph 1. Cacti Logical Flow](http://bejgsa.mycompany.com/~lijs/public/images/Cacti-Logical-Flow.png)


## Graphite

**Notes:** SCO FVT system developed [on line charts](scbvt.rtp.raleigh.mycompany.com/charts) as a replacement to Graphite  
Graphite is an easy tool to monitor numeric time-series data. It's useful when you want to monitor numeric data 
which changing over time. But what Graphite does not do is to collect data. Graph 2 is an illustration of Graphite logical flow


![Graph 2. Graphite Logical Flow](http://bejgsa.mycompany.com/~lijs/public/images/Graphite-Logical-Flow.png)


There are some tools that can send data to graphite for common monitoring matrix, for example JMXTrans, Ganglia. 
But if you want to monitor some specific matrix based on your application, it requires a little code. 
Even though, coding and sending data to Graphite is very simple. 

We have multiple specialized systems in SCO CD infrastructure. and Graphite is a good choice for us to monitor application 
specific matrix. For example, how many builds run in FVT per day, average OS install time for each round of FVT, etc.

Here is sample code to send data to graphite server, it calculates the total installs in FVT system. Since for each install,
it will generate one 'install.log' file, this sample code used it to calculates the count:

	#!/bin/bash
	TMP_DIR=`mktemp -d`
	find <%= node[:nose][:logDir] %> -name install.log -exec stat -c %Y {} \; > $TMP_DIR/install-times.txt
	sort -n $TMP_DIR/install-times.txt > $TMP_DIR/install-times-sorted.txt
	awk 'BEGIN {count=0}; {count++; print "bvt-master.rtp.installs.total", count, $1};' $TMP_DIR/install-times-sorted.txt > $TMP_DIR/installs-metrics.txt
	cat $TMP_DIR/installs-metrics.txt | nc <%= node[:graphite][:ip] %> 2003

## JMXTrans
JMXTrans is a connector between Java applications with exposed JMX and monitoring server. We use JMXTrans to monitor selenium grid.
Since JXMTrans outputs data in whatever format, the monitor server can be Graphite, StatsD, Ganglia, cacti/rrdtool, etc. 
The logical workflow as in Graph 3.


![Graph 3. JMXTrans Logical Flow](http://bejgsa.mycompany.com/~lijs/public/images/JMXTrans-Logical-Flow.png)


## Ganglia
Ganglia is a scalable distributed monitoring system for high-performance computing systems such as clusters and Grids. 
Main reason we adopt this tool is that it can monitor hyper-visors including virtual machines dynamically changing on it.
Here is logical workflow for ganglia to monitor hypervisors:


![Graph 4. Ganglia Logical Flow](http://bejgsa.mycompany.com/~lijs/public/images/Ganglia-Logical-Flow.png)

## vSphere monitoring
VMware provides several applications to monitor virtual environments. vCenter server and vSphere web client are two of them:

* vCenter Server: vCenter Server unifies resources from individual hosts so that those resources 
can be shared among virtual machines in the entire datacenter.

* vSphere web client: The vSphere Web Client is the interface to vCenter Server and multi-host environments, 
it runs in your browser and lets you manage and monitor your vSphere environment.

Both the two applications can monitor:
	
  + Performance of each inventory objects, such as 'datacenters', 'hosts', etc
  + Guest OS performance
  + Host Health status
  + Storage Resources
  + Events, Alarms and Automated Actions
  + etc.

Here is a simple demo on [VMware monitoring using vSphere web client](http://bejgsa.mycompany.com/home/l/i/lijs/web/public/demo/demo-vsphere-webclient.mp4).

References on vSphere web client:

* [vCenter Server VS. vSphere web client](http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-588861BB-3A62-4A01-82FD-F9FB42763242.html)

* [vSphere web client installation guide](http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.install.doc%2FGUID-74AA3EF1-BDF3-4752-89DB-A522CDE30A66.html) 

* [vSphere Monitoring and Performance](http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.monitoring.doc%2FGUID-A8B06BE0-E5FC-435C-B12F-A31618B21E2C.html)

* [Toubleshooting: vSphere web client can not get vCenter information ](http://lostdomain.org/2012/11/11/vsphere-web-client-must-be-registered-with-the-lookup-service/)


# Use cases in SCO CD

## Monitoring@SCO FVT system
SCO FVT system is an automation framework which enables developers to verify code changes by performing installation and 
basic feature testings. The input is SCO binaries, and output is FVT testing report with all kinds of log files. 
Chef resources used in monitoring of FVT system is as shown in Graph 5.


![Graph 5. Chef Resources for FVT monitoring](http://bejgsa.mycompany.com/~lijs/public/images/FVT-Monitoring.png)


Here is links for the monitoring server deployed using the above chef resources(since they locate at CIL, 
need to authenticate [CIL-VPN](http://cil-vpn.rtp.raleigh.mycompany.com/) first)

+ [Cacti server](http://172.17.36.15/cacti)
+ [Graphite server](http://172.17.36.2)

## Monitoring@Statuscode
`Statuscode` is a cloud platform based on OpenStack, it's maintained by SCO CDL team, besides features shipped with OpenStack,
it also includes hardware management, CI tools, collaboration tools, etc. Graph 6 shows chef resources used in `Statuscode`


![Graph 6. Chef Resources for FVT monitoring](http://bejgsa.mycompany.com/~lijs/public/images/statuscode.png)


Links for the monitoring server

+ [Statuscode](https://statuscode.gemini.cdl.mycompany.com/) (Navigate to "Monitoring" and "Graphite" tab)

# Reference
[1]. [Chef](http://www.opscode.com/chef/)

[2]. [Graphite 5-minute Overview](http://graphite.readthedocs.org/en/1.0/overview.html)

[3]. [Cacti](http://www.cacti.net/index.php)

[4]. [JMXTrans](http://www.jmxtrans.org/)

[5]. [Ganglia](http://ganglia.sourceforge.net/)

[6]. [OpenStack](http://www.openstack.org/)

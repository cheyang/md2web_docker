<!-- title: SCO Build System -->
<!-- subtitle: Getting Started, Chef cookbooks, Get support. -->

# Overview
SCO build system is infrastructure to support packaging and publishing SCO product binaries.
It consists of Jazz Build Engine(JBE), build definition, build scripts, storage server and squid proxy server.

This doc will describe how to setup a build system and how to monitor each component mentioned above.

# Setup and configure

## JBE

+ Install and configure using [Chef cookbook](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/chef-toolkit/sco-build-system/README.html)
+ Monitor hardware resource using cacti, need to install [cacti client](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/html/cacti.html) in JBE to enable the monitoring

	Note: 
	
	1. If you installed JBE using `role[sco_build_engine]` in the run list, then the cacti client is already installed
	2. Manually configure all JBEs in cacti web UI to enable the monitoring. Here is [cacti document](http://www.cacti.net/documentation.php) on how to add monitoring to cacti server. 

+ Example: [cacti server](http://172.17.35.15/cacti) for all JBEs of SCO in RTP
	

## Storage server

+ Install and configure using [Chef cookbook](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/html/storage_server.html)
+ Monitor:
	+ Using cacti to monitor hardware(disk/memory/etc) and apache server
		+ Install [cacti client](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/html/cacti.html) on storage server
		+ Configure in cacti web UI to enable the monitoring
		
## Squid Server
	
Squid server is the improve performance of downloading component builds for SCO build

+ Install and configure using [Chef cookbook](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/html/squid_cookbook.html)
	+ To use squid server in SCO build, need to add 'recipe[sco_build_node::proxy]' in the run list of JBE, please refer 
	to [JBE cookbook](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/html/sco_build_node.html) for more details
+ Best practice and performance tuning
	+ `[cache_dir][Mbytes]` is the amount of disk space (MB) to use under `[cache_dir][path]` directory.  The default is 100 MB. 
	For SCO build, should change this to >51200MB
	+ `maximum_object_size`: Objects larger than this size will NOT be saved on disk. 
	For SCO build, some package consumes almost 3GB for a single file, so we need to change this value to be able to cache it.
	
	Sample attribute for squid shows in below:
	<pre><code>
	"squid": {
	      "cache_dir": {
	        "Mbyte": 51200,
	        "path": "/iaas/squid"
	      },
	      "maximum_object_size": 3072000,
	      "port": 8085,
	      "network": "9.115.0.0/16",
	      "version": 31,
	      "transparent": true
	    }

# Testing

Testing availability of build infrastructure is running on [jenkins](http://scbvt.rtp.raleigh.mycompany.com/jenkins/view/feature-tests/job/build_infra_testing/)

# Access

All servers in build infra are running in `starwars` cloud, in tanent `sco-build-rtp`, it can be accessed using [key](https://github.rtp.raleigh.mycompany.com/distillery/keys/blob/master/ssh_keys/jbe.key)

<!-- title: Test Frameworks for Automation -->
<!-- subtitle: a collection of automated test techniques -->

# About this page

It provides automated test techniques adopted by Common Cloud Stack development
and testing teams.

# Requirement
Test framework requires the following Ruby gems:

* `rake` - Perform `gem install rake`
* `chef` - Perform `gem install chef`
* `rspec` - Perform `gem install rspec`
* `rspec_junit_formatter` - Perform `gem install rspec_junit_formatter`
* `selenium-webdriver` - Perform `gem install selenium-webdriver`

For example:

    # gem install rake chef rspec rspec_junit_formatter selenium-webdriver


# Frameworks

This list is the most often used frameworks and you can pick up by following the
 guides provided below.

## JUnit

[JUnit](http://www.junit.org/) is used in SmartCloud UI development in:

* _code coverage_ - It uses to cover Java code in both N3 and SmartCloud UI.
* _build verification_ - It reports the JUnit test result to every build in both
 GSA and RTC.
* _Web UI function test organization_ - It uses Selenium but the test cases are
organized and reported over JUnit.

We also uses variations in other programming languages like Ruby unittest and
Python unittest. However, they end up with the same test report in JUnit XML
format.

## JMeter

[JMeter](http://jmeter.apache.org/) is used for performance test in SmartCloud
UI. Where it allows to describe the test plan in XML format, and generate loads
 to target application from JMeter server.

We recommend following the [JMeter user manual](http://jmeter.apache.org/usermanual/build-web-test-plan.html)
 to create a test plan, then save it as jmx file.

A test plan can be executed over local JMeter application:

    $ jmeter -n -t test-plan.jmx -r

Or over remote JMeter server:

    $ jmeter -n -t test-plan.jmx -R server1,server2,...

Please use the [JMeter cookbook](jmeter.html) to see how to configure JMeter
server.


## Cucumber

We use [Cucumber](cukes.info) for automating the Green thread user scenarios
 execution across different CCS components. It allows writing feature spec in
 plain text while developers can automate the execution and end up with report.
 See [this video](http://bejgsa.mycompany.com/~zhukecdl/public/videos/ccs_continuous_delivery_demo_sprint24.webm) for how it works.

Cucumber itself benefits the communication among software component
developers where it keeps __software behavior__ unchanged with different
implementation underneath. So that it makes the `Test Driven Development`
become easier.

For example, we use 3 green thread tests to verify if the CCS component
integration works while the component code

## Rspec

An installer developers can use ruby `rspec` since it can import ruby chef API
directly. Here's a sample test in ruby for the IaaS gateway:

    require 'rubygems'
    require 'rspec'
    require 'rspec-expectations'
    require 'chef/search/query'

    describe 'IaaS Gateway' do

      @node_attr = nil
      before(:all) do
        # import default knife config file
        Chef::Config[:config_file] = File.expand_path('.chef/knife.rb', ENV['HOME'])

        Chef::Config.from_file(Chef::Config[:config_file])

        query = Chef::Search::Query.new
        # query node
        query.search(:node, "roles:iaas_gateway") do |item|
          @node_attr = item
        end
      end

      it '/providers' do
        # extract node configurat ion data
        node_id = @node_attr[:fqdn]
        ip_addr = @node_attr[:ipaddress]
        port    = @node_attr[:iaas_gateway][:listen_port]

        # connecting
        providers_json = %x[curl -sS http://#{ip_addr}:#{port}/providers]
        providers = JSON.parse(providers_json)

        puts "verify the iaas gateway on node #{ip_addr}"
        # verifying
        providers.should have_key('serviceCatalog')
      end
    end

Please use the build `Installer Acceptance Test` to do personal build on your
installer workspace before deliver changes to installer code stream.

**Note**: the default execution environment is the Gemini cloud. For development
 on your local workstation, you can remove the chef configuration and query over
 chef server by using given configuration directly. For example:

    @node_attr = nil
    before(:all) do
      @node_attr = {
        "ipaddress" => "9.115.77.65",
        "iaas_gateway" => {
          "listen_port" => 9973
        }
      }
    end

Another RSpec example that using mock object in unit test.

    #taken from <gems>/ci_reporter-1.8.4/spec/ci/reporter/report_manager_spec.rb
    describe "The ReportManager" do
      ...
      it "should write reports based on name and xml content of a test suite" do
        reporter = CI::Reporter::ReportManager.new("spec")
        suite = mock("test suite")
        suite.should_receive(:name).and_return("some test suite name")
        suite.should_receive(:to_xml).and_return("<xml></xml>")
        reporter.write_report(suite)
        filename = "#{REPORTS_DIR}/SPEC-some-test-suite-name.xml"
        File.exist?(filename).should be_true
        File.open(filename) {|f| f.read.should == "<xml></xml>"}
      end
      ...
    end

## Selenium WebDriver

[Selenium](code.google.com/p/selenium/) is used for Web UI function test. It
 provides the capabilities to run test cases in browsers. Developers are
allowed to use Selenium IDE to generate test cases or write in programming
languages including Java, Ruby, Python and JavaScript.

In N3 developement, we developed an Eclipse plugin to integrate the Selenium
 within Eclipse. It's very simple to use it because you only need to check
out the project `org.openqa.selenium` code from the component `Web Infrastructure`
 and add it into your project dependencies. Please look at this [video](http://bejgsa.mycompany.com/~zhukecdl/public/videos/how_ui_developer_run_ui_function_test_n3.webm)
 for how to run Selenium test cases within Eclipse.

Developer who needs to run the Selenium test on local machine out of Eclipse,
please start a Selenium standalone server first:

    $ curl -L https://code.google.com/p/selenium/downloads/detail?name=selenium-java-2.28.0.zip
    $ unzip selenium-java-2.28.0.zip
    $ java -jar selenium-server-standalone-2.28.0.jar

For Ruby, it depends on the gem `selenium-webdriver` to run test:

    $ sudo gem install selenium-webdriver

## Selenium Test Framework
Selenium is a tool to create functional testcase for web app. We provide a
framework in `rspec example_steps` to help you to create re-usable testcases 
conveniently.

Refer to article [Development](dev_guide.html#7) in "Acceptance test" section
 on how to access the project

Notes: `rspec example_steps` is a tool to write test scenario in steps with order
details in [rspec-example_steps ](https://github.com/railsware/rspec-example_steps).
It is usefull to define a long user secnario into Cucumber style of steps.
Selenium test framework includes it in lib/rspec/example_steps. 

Our selenium test framework has 4 layers:
    * spec: rspec testcase
    * lib/steps: rspec shared steps that can be reused between differnet test, 
        eg: login to IWD
    * lib/appobject: classes that represent an element in web page, 
        eg: check out image form in VIL
    * lib/widget: classes that represent web widgets, and a wrapper for selenium.
        The web widgets in this layer refer to none-buildin web widgets that need extra 
        effort to test against, eg: dijit dropdown button, which need a method to 
        select drop down item

When you develop testcase, please also contribute code to lower layer to be 
reused by others, rather than define everything in testcase

This is a sample testcase for deploying vSys pattern:

    require 'spec_helper'

    # provide your test data in this array. The test scenario can be repeated for all data
    [
    ["KVM image.ova", "mycompany OS Image for RHEL in KVM", kvm_sample_image_url],
    ["VMware image.ova", "mycompany OS Image for RHEL in VMWare", vmware_sample_image_url]
    ].each do |description, image_name, image_url|
      
      describe "IWD Deploy vSys Pattern based on Image: #{description}" do
      
        before(:all) do
          ... # code to read chef conf. Refer to pervious example
        end
        
        
        Steps "Deploy vSys Pattern" do
          driver = SeleniumDriver.instance
          Given "Open Virtual Images page in IWD" do
            driver.navigate.to iwd[:url]
            # shared steps have prefix of app name, eg "IWD ..."
            include_steps "IWD login", admin 
            driver.title.should include(iwd[:home_title]) 
            # "navigate" is a shared step to click element by text
            include_steps "navigate", L[:IWD_NAV_IMAGE_PATTERNS],L[:IWD_NAV_VIRTUAL_IMAGES]
            
            # verify if it open the expected page from checking new button existance
            expect(IWDVirtualImages.new.exists?(5)).to be_true
          end

          When "Import an image #{image[:name]}" do
            ... # skip details
          end
          
          And "Check out the image in VIL" do
            ... # skip details
          end
          
          And "Create a vSys pattern #{pattern_name}" do
            ... # skip details      
         end      
          
          # Verify test result in "Then" block
          Then "The instance can be started" do
            # Wait for the instance page to load then poll the current status
            status_image_url = ""
            Selenium::WebDriver::Wait.new(:timeout => 20*60).until{
              sleep 5 # wait 5 seconds between refreshes
              element = iwd_vsys_instances.get_status_img(10)
              status_image_url = element.attribute('src')
              span_element = iwd_vsys_instances.get_status
              puts "STATUS ==> " + span_element.text
              driver.navigate.refresh
              # not empty and not end with progress...gif
              status_image_url != nil and status_image_url.size > 0 and not status_image_url.end_with?('/images/progress-indicator-static.gif')
              
            }.should be_true
            # test pass if the instance status icon is not fail-icon
            expect(status_image_url).not_to include( 'fail-icon.gif' )
          end
        end
        # exit the browser to release webdriver resource
        after(:all) do
            driver = SeleniumDriver.instance.quit
        end
      end
    end

How to execute test:

If you have web browser and X system installed on your dev env, you can execute
it directly as other rspec test, eg: 

    $ rspec spec/vsys_spec.rb.


## Selenium Grid Service
There is a Selenium grid service in CDL that provide browsers environment to run selenium
test. For example, if you want to run test on env without installing web browser, You can 
run test from setting REMOTE_WEBDRIVER_URL env var to use the grid service. eg:

    $ export REMOTE_WEBDRIVER_URL=http://172.17.36.20:4444/wd/hub
    $ rspec spec/vsys_spec.rb

This service will launch browser on a remote Selenium node to perform your test scenario.

You can check service status and avaliable Selenium nodes in [console page](http://172.17.36.20:4444/grid/console)
 

## Jenkins

Take the performance test job for N3 development for example, it uses an Ant
task for JMeter to execute JMeter test plan.

    <taskdef name="jmeter"
	 classname="org.programmerplanet.ant.taskdefs.jmeter.JMeterTask"
	 classpathref="ant.jmeter.classpath" />
    <target name="run-jmeter-remote" depends="init-jmeter,clean-jmeter">
	 <jmeter jmeterhome="${jmeter-home}"
	       	resultlogdir="results/jtl"
		runremote="true">

	  <jmeterarg value="-R 172.17.0.224"/>
	    <testplans dir="${basedir}${file.separator}jmeter"
	    		       includes="*.jmx"/>
	 </jmeter>
    </target>

Then it uses the [performance plugin](https://wiki.jenkins-ci.org/display/JENKINS/Performance+Plugin)
 to publish the performance test result in diagrams. See the job publisher:

    <hudson.plugins.performance.PerformancePublisher>
      <errorFailedThreshold>0</errorFailedThreshold>
      <errorUnstableThreshold>0</errorUnstableThreshold>
      <parsers>
        <hudson.plugins.performance.JMeterParser>
          <glob>n3.app.test.performance/results/**/*.jtl</glob>
        </hudson.plugins.performance.JMeterParser>
      </parsers>
    </hudson.plugins.performance.PerformancePublisher>



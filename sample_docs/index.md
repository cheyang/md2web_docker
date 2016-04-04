<!-- title: Common Cloud Stack Continuous Delivery Setup Reference -->
<!-- subtitle: Getting Started, team & code. -->
# About this Guide

This site contains documentation about the continuous delivery team's work, how
to contribute, and how code gets deployed.

## Update this Document

It generates html pages from Markdown formats under git repo [chef-toolkit/delivery-doc](http://github.rtp.raleigh.mycompany.com/chef-toolkit/delivery-doc).

# How To Contact the Team

If you have problems with the continuous delivery infrastructure, please use the
following methods to acquire support:







## Contacts

+ [Heidi Eissler](http://faces.tap.mycompany.com/#uid:062269724/Heidi%20Eissler)
 
    * Email: h.eissler@de.mycompany.com

# Important Links

**Knowledge Base**

- [Continuous Delivery Knowledge Base](https://w3-connections.mycompany.com/wikis/home?lang=en#!/wiki/W3cfc52416a59_406d_8e18_445dc4fb4934/page/Continuous%20Delivery%20Team%20corner)
- [Continuous Delivery Team wiki](https://w3-connections.mycompany.com/wikis/home?lang=en#!/wiki/W3cfc52416a59_406d_8e18_445dc4fb4934/page/Continuous%20Delivery%20Team%20corner)

**Development Guide**

- [Development Guide](http://rtpgsa.mycompany.com/projects/i/ico_build/delivery_doc/html/dev_guide.html)

**Distillery**

- [Distillery](https://github.rtp.raleigh.mycompany.com/groups/distillery)
- [Distillery docs](http://rtpgsa.mycompany.com/projects/i/ico_build/delivery_doc/distillery/)

**Deployinator**

- [Deployinator](https://github.rtp.raleigh.mycompany.com/deployinator/cil_deployinator)
- [Deployinator docs](https://github.rtp.raleigh.mycompany.com/distillery/keys/blob/master/Deployinator.docx)

**Chef-toolkit**

- [chef-toolkit](https://github.rtp.raleigh.mycompany.com/groups/chef-toolkit)
- [chef-toolkit docs](http://rtpgsa.mycompany.com/projects/i/ico_build/delivery_doc/chef-toolkit/)

# Developer Information

If you wish to contribute to the infrastructure that runs the deployment
pipeline, please read through the following information and the [source code](http://rtpgsa.mycompany.com/projects/i/ico_build/doc/html/dev_guide.html).

## Server Access

Join [distillery group](https://github.rtp.raleigh.mycompany.com/groups/distillery), and see docs in this project:

+ [key access](https://github.rtp.raleigh.mycompany.com/distillery/keys/)


## Rational Team Concert and Code Setup

1. Set up your Rational Team Concert client using the [steps outlined here](https://w3-connections.mycompany.com/wikis/home?lang=en#!/wiki/W3cfc52416a59_406d_8e18_445dc4fb4934/page/Initial%20Setup).
2. **Ignore the the "Download Code" section**
3. Open your RTC Client, go to the "Team Artifacts" view
3. Expand "Common Cloud Stack" > Source Control
4. Right click on the "Continuous Delivery" stream > New > Repository Workspace
5. Follow the steps in the wizard to create a **Public** workspace and load the
   contents of the "Continuous Delivery" component.

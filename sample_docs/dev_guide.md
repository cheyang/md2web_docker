<!-- title: Development Guide -->
<!-- subtitle: how to work with code -->

# Overview

It manages everything in source code repository via [git](http://www.git-scm.com).

# Source code

So far, we use the following projects hosted on github:

* [distillery](http://github.rtp.raleigh.mycompany.com/groups/distillery)
* [chef-toolkit](http://github.rtp.raleigh.mycompany.com/groups/chef-toolkit)

Please see individual project documents from [here](http://bejgsa.mycompany.com/projects/c/ccs-delivery/doc/)

# Review process

It uses the [gerrit](https://scbvt.rtp.raleigh.mycompany.com/review/) review system. anyone can sign in by w3 intranet id only.

One can get code delivered by this simple process:

1. any registered user on review system can submit or review changes.
1. team leads can merge changes.
1. the review system will replicate git repositories to github automatically.

## tool

* [git-review](http://www.mediawiki.org/wiki/Gerrit/git-review)

## example steps

Setup user on review system:

1. Sign in by clicking top right link of the [review system](https://scbvt.rtp.raleigh.mycompany.com/review/).
1. Fill in w3 intranet id and password.
1. Navigate to <your-name> -> Settings -> HTTP Password, click the button `Generate Password`.

Please remember this password for git repo configuration.

Checkout code (use project `chef-toolkit/review_system` for example):

    $ export GIT_SSL_NO_VERIFY=true
    $ git clone https://scbvt.rtp.raleigh.mycompany.com/review/chef-toolkit/review_system
    $ git remote add gerrit https://<http username>:<http password>@scbvt.rtp.raleigh.mycompany.com/review/chef-toolkit/review_system
    $ git config http.sslVerify false

Ensure that you have run these steps to let git know about your email address:

    git config --global user.name "Firstname Lastname"
    git config --global user.email "your_email@youremail.com"

To check your git configuration:

    git config --list

Set up the _git-review_ tool:

    $ sudo pip install git-review
    $ cd <your project directory>
    $ curl -k https://scbvt.rtp.raleigh.mycompany.com/review/tools/hooks/commit-msg -o .git/hooks/commit-msg
    $ chmod 0755 .git/hooks/commit-msg 

Example .gitreview format:

    [gerrit]
    host=scbvt.rtp.raleigh.mycompany.com/review
    port=443
    project=chef-toolkit/review_system

Submit changes:

    # do some code change
    $ git diff  # review the changes you made
    $ git add <the files you changed>
    $ git commit -m '<commit message>'
    $ git review

Apply new change sets to an existing change:

    $ git fetch https://scbvt.rtp.raleigh.mycompany.com/review/chef-toolkit/review_system refs/changes/02/2/1 && git cherry-pick FETCH_HEAD
    # fix conflicts and do code changes from review comments
    $ git diff  # review the changes you made
    $ git add <the files you changed>
    $ git commit --amend
    $ git review

Detail usage can be found [here](https://github.com/openstack-infra/git-review/blob/master/README.rst)

# Project setup

Please contact administrators and guide [here](https://scbvt.rtp.raleigh.mycompany.com/review/Documentation/project-setup.html).

# Limitations

* anyone needs to pass BSO against 9.37.196.48 to access the review system.
* only **HTTPS** is accepted. which means you can't use ssh protocol.

# Reference

* http://www.mediawiki.org/wiki/Gerrit/git-review
* https://scbvt.rtp.raleigh.mycompany.com/review/Documentation/index.html
* https://github.com/openstack-infra/

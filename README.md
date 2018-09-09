# docker-jenkins-starter

## Installation

### Requirements

Firstly, install docker and docker-compose.

### Customising

Read the `docker-compose.yml` file, and note the `VIRTUAL_HOST` line.

This is a comma separated list of domains to map to the service, by assuming you are using the 
[jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) image. You should customise these to the relevant
domains for your project, by creating a `docker-compose.override.yml` file. It would look similar to this:

```yml
version: '2'

services:
    jenkins:
        environment:
            VIRTUAL_HOST: custom.example.com,another.example.com
```

If you are not using the jwilder/nginx-proxy image, you will need to configure some other way to access the service.

As you can see from the `docker-compose.yml` file, it runs on port 8080 by default.

### Start Jenkins

```shell
docker-compose up -d   # start the service as a daemon (backgrounded)
docker-compose logs -f # view the logs as the service is running
```

> press 'ctrl' + 'c' to disconnect from the logs.

### Unlock Jenkins

If you visit the jenkins url you configured earlier, you will see a screen asking for the initial admin password. 
This will be visible in the logs; it is a long hexadecimal string. Enter it and click 'continue'.

This is just to stop someone quickly jumping in and configuring the server to do bad things before we get chance to set
it up properly. It is a one-time setup step.

### Select plugins

Plugins have already been installed, but the Jenkins setup wizard does not know this.

In the 'customize jenkins' screen, choose 'Select plugins to install'.

Select 'none' near the search box

Select 'install' in the bottom right

### Create admin user

* Username: `admin`
* Password: free choice, but it should be a secure password you can remember for an hour or so
* Name: `admin`
* Email: an email address that you would want error reports to be sent to

Select 'Save and Continue'

### Instance Configuration

The Jenkins URL should be where you are accessing it from. It will use this later to generate links back to itsself, 
including for OAuth, so this should be set correctly.

Select 'Save and Finish'

Select 'Start using Jenkins'

## Setup GitHub

From GitHub, you will need:

* An access token with the `repo`, `admin:repo_hook` and `admin:org_hook` scopes
* A 'OAuth App' client id/secret pair

> Recommend the above are set up on a 'company' account, so if a developer leaves the organisation the integrations do 
> not fail.

### Allow repository access

From the Jenkins homepage:

* Manage Jenkins
* Configure System
* Github > Github Servers
  * Add github server
  * Add a credential
    * Kind: secret text
    * Secret: the github access token you prepared
    * Description: enter a description of this access token
  * Make sure the newly added secret is selected
  * Test the connection; it should show a username and a rate limit if successful.
* Select 'Save'

### Allow OAuth login

From the Jenkins homepage:

* Manage Jenkins
* Configure Global Security
* Access Control > Security Realm > Github Authentication Plugin
  * Enter the client id/secret pair you prepared
* Access Control > Authorization > GitHub Committer Authorization Strategy
  * Admin User Names: Enter 'admin', plus all github usernames you want to grant admin access to. (case sensitive)
  * Participant in Organisation: Enter the organisation name. (case sensitive)
  * Check 'Use GitHub repository permissions'
* Select 'Save'
* Select 'log out' in the top right
* Go to the jenkins homepage
* You should now be directed to the GitHub OAuth flow.

### Set up scanning repositories

From the Jenkins homepage:

* New Item
* Enter the name of the organisation (case sensitive)
* Select 'GitHub Organisation'
* Select 'Save'
* Add a credential
  * Select 'jenkins' folder
  * kind: username & password
  * username: username that generated the access token (case sensitive)
  * password: the access token you prepared
  * Select 'Add'
* Select the credential you just chose
* Select 'Save'
* The output shown should show the names of each repo as it is scanned.


## Setting up repositories

As long as a repository contains a `Jenkinsfile` at the root of the project, it will be automatically built by Jenkins
and have the status reported back to GitHub.

Deploy is not yet set up. 

## Backup

Not yet prepared. Simply involves dumping /var/jenkins_home and restoring it. See example in commented out line in
Dockerfile

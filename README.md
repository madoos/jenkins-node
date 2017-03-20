# madoos-jenkins-dod

Jenkins imagen with dood implementation and jenkins plugins for Nodejs CI.

## Getting Started

`docker pull madoos/jenkins-node:latest`

## Run container

Execute: 

`./bin/run`

Or:

`docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
-v /path/to/your/jenkins/home:/var/jenkins_home \
-p 8080:8080 \
madoos/jenkins-node:latest`


## Jenkin plugins for Nodejs CI

 * `github`
 * `github-organization-folder`
 * `workflow-aggregator`
 * `nodejs`
 * `embeddable-build-status`
 * `sonar`
 * `htmlpublisher`


## Considerations

* This image is adapted for the Jenkins file of the generator-madoos-node-module  to facilitate the CI automation of new modules.
* It is very important to add the node version with which the unit tests are executed. The node configuration parameter must be the same as the Jenkinsfile.

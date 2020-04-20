This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: https://facebook.github.io/create-react-app/docs/code-splitting

### Analyzing the Bundle Size

This section has moved here: https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size

### Making a Progressive Web App

This section has moved here: https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app

### Advanced Configuration

This section has moved here: https://facebook.github.io/create-react-app/docs/advanced-configuration

### Deployment

This section has moved here: https://facebook.github.io/create-react-app/docs/deployment

### `npm run build` fails to minify

This section has moved here: https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify

### Application Environment

Environment values for application has been externalized for React app based
on .env files.

All environment variables should start with prefix REACT_APP_*

#### Environment variable:

REACT_APP_S3_URL=https://s3-us-west-2.amazonaws.com/s.cdpn.io/3/posts.json 

### GitOps

In GitOps we want the whole system to be managed declaratively and using convergence.  
By a “whole system” we mean a collection of environments both on-prem or cloud. Each environment includes machines, clusters,
applications, as well as interfaces to external services eg. data, monitoring. 

### DevSecOps:

In DevOps practice Security is also one big concern which should be part of CI/CD
pipeline while delivering change requests or any Product Releases.

Security can come as SAST, DAST or monitoring threat detection using SEIM tools like Splunk
or Guard Duty from AWS using Kibana dashboard.

AWS Secrets Manager for saving credentials or API keys.

SAST: SonarQube
DAST: Runtime container scan using Anchor

Files:

sonar-project.properties, 
tslint.json

### Cloud-native Container:

In order to build application as a cloud-native, containarization of application is a good technique,
which abstracts it from underlying host machine by including all its run time binaries and commands to execute
in its own isolated runtime environment. It will help application portable to any host machine and
bring up application quickly if compare with VM. It also make application available and resilient in ephemeral
environment.

Docker comes in picture to include all runtime binaries and commands baked in 
docker image.

Reference: https://docs.docker.com/engine/reference/builder/

Created two separate files for two different environment.

Container files include in repository: Dockerfile, Dockerfile.production

### CI/CD:

For building the react app to deploy and pushed Docker images, Jenkins pipeline as code has been used
to maintain the code change. It can use multi-branch pipeline which will trigger based on any code change in
Git repository. Pipeline has the following stages:

For all branches: It will run install, test using npm tool and SAST security scan for code
using SonarQube.

For Development and Production branches: It will build Docker image with proper image tag
and push those images into ECR which will be image repository in AWS.

Two branches will triggered with environment value:
development ---> Non-Prod environment
master ---> Prod environment

Pipeline as code file: Jenkinsfile

${scannerHome} will be setup in Jenkins as environment variable.

Please replace with appropriate values:

ECR_REPOSITORY_URI = 'REPLACE_ME'

ECR_REPOSITORY_PROD_URI = 'REPLACE_ME'

ECR_PASSWORD = 'REPLACE_ME'

ECR_USERNAME = 'REPLACE_ME'

Automating Deployment to ECS still to be considered:

https://aws.amazon.com/blogs/devops/set-up-a-build-pipeline-with-jenkins-and-amazon-ecs/

### Infrastructure:

For infrastructure we use public cloud to provision infrastructure to deploy our Docker
into AWS ECS Fargate as container orchestrator tool, which is serverless using Cloudformation as our IaC. This file has also been 
checked-in Git repository as part of GitOps.

Serverless managed service is good in Agility, pricing pay as you go and no Ops task maintain
server provisioning, patching and Capacity provisioning.

File templates for Iac: public-vpc.yaml, service.yaml

Parameterized Cloudformation template:

#### Parameters:
  
  StackName:
  
  ServiceName:
 
  ImageUrl:
  
  ContainerPort:
  
  ContainerCpu:
  
  ContainerMemory:
  
  Path:
  
  Priority:
  
  DesiredCount:
  
  Role:

Cloudformation Reference is here: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ECS.html

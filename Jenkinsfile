#!/bin/groovy

pipeline {
    environment {
        ECR_REPOSITORY_URI = 'https://297041898255.dkr.ecr.us-east-2.amazonaws.com'
        ECR_REPOSITORY_PROD_URI = 'REPLACE_ME'
        ECR_REGION = 'us-east-2'
        ECR_USERNAME = 'AWS'
        IMAGE_TAG = "build-${env.BUILD_ID}"
        IMAGE_RELEASE_TAG = "release-${env.BUILD_ID}"
        REPO_URL = 'https://github.com/ifaridi79/code-challenge-ifaridi.git'
    }
    
    agent {
        label 'docker'
    }

    environment {
        CI = 'true'
    }
    stages {
        stage('Code checkout') {
        agent any
          steps {
            sh 'echo Repository URL is $REPO_URL'
            git '$REPO_URL'
          }
        }
        stage('Install dependencies') {
        agent any
          steps {
            sh 'npm install'
          }
        }
        stage('Test') {
        agent any
          steps {
             sh 'npm test'
          }
        }
        stage('Security Scan') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('build Docker Image') {
        agent any
          when {
             branch 'development'
          }
          steps{
            script {
              sh 'echo Building the Docker image...'
              sh 'docker build -t $ECR_REPOSITORY_URI:latest .'
              sh 'docker tag $ECR_REPOSITORY_URI:latest $ECR_REPOSITORY_URI:$IMAGE_TAG'
            }
          }
        }
        stage('build Production Image') {
        agent any
          when {
             branch 'production'
          }
          steps{
            script {
              sh 'echo Building the Docker image...'
              sh 'docker build -t $ECR_REPOSITORY_PROD_URI:latest -f Dockerfile.production --no-cache .'
              sh 'docker tag $ECR_REPOSITORY_PROD_URI:latest $ECR_REPOSITORY_PROD_URI:$IMAGE_RELEASE_TAG'
            }
          }
        }
        stage('Image analyze') {
            steps {
                sh 'echo "$ECR_REPOSITORY_URI:latest `pwd`/Dockerfile" > anchore_images'
                anchore name: 'anchore_images'
            }
        }
        stage('Deploy Image') {
        agent any
          when {
             branch 'development'
          }
          steps{
            script {
                sh 'echo Build completed on `date`'
                sh 'echo Fetching ECR login....'
                sh 'ECR_LOGIN=$(aws ecr get-login --region $ECR_REGION --no-include-email)'
                sh 'echo Logging in to Amazon ECR....'
                sh '$ECR_LOGIN'
                sh 'echo Pushing the Docker images...'
                sh 'docker push $ECR_REPOSITORY_URI:latest'
                sh 'docker push $ECR_REPOSITORY_URI:$IMAGE_TAG'
                sh 'docker rmi -f $ECR_REPOSITORY_URI:latest $ECR_REPOSITORY_URI:$IMAGE_TAG'
            }
          }
        }
        stage('Deploy Production Image') {
        agent any
          when {
             branch 'production'
          }
          steps{
            script {
                sh 'echo Build completed on `date`'
                sh 'echo Pushing the Docker images...'
                sh 'docker login –u ECR_USERNAME –p ECR_PASSWORD –e none $ECR_REPOSITORY_PROD_URI'
                sh 'docker push $ECR_REPOSITORY_PROD_URI:latest'
                sh 'docker push $ECR_REPOSITORY_PROD_URI:$IMAGE_RELEASE_TAG'
                sh 'docker rmi -f $ECR_REPOSITORY_PROD_URI:latest $ECR_REPOSITORY_PROD_URI:$IMAGE_RELEASE_TAG'
            }
          }
        }
    }
}

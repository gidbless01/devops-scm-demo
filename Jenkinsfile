pipeline {
  agent any

  tools {
    maven 'maven3'
    jdk 'jdk17'
  }

  environment {
    SONARQUBE_SERVER = 'sonarqube'
    NEXUS_REPO = 'maven-releases'
    NEXUS_URL = 'http://nexus:8081'
    ECR_REPO = '123456789012.dkr.ecr.us-east-1.amazonaws.com/devops-app'
    IMAGE_TAG = "${BUILD_NUMBER}"
    AWS_REGION = 'us-east-1'
  }

  stages {

    stage('Code Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/your-org/devops-app.git'
      }
    }

    stage('Unit Tests') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Code Quality') {
      steps {
        withSonarQubeEnv("${SONARQUBE_SERVER}") {
          sh 'mvn sonar:sonar'
        }
      }
    }

    stage('Build Artifact') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Push Artifact to Nexus') {
      steps {
        sh 'mvn deploy'
      }
    }

    stage('Docker Build') {
      steps {
        sh """
          docker build -t devops-app:${IMAGE_TAG} .
          docker tag devops-app:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
        """
      }
    }

    stage('Security Scan') {
      steps {
        sh 'trivy image devops-app:${IMAGE_TAG}'
      }
    }

    stage('Push Image to ECR') {
      steps {
        sh """
          aws ecr get-login-password --region ${AWS_REGION} \
          | docker login --username AWS --password-stdin ${ECR_REPO}

          docker push ${ECR_REPO}:${IMAGE_TAG}
        """
      }
    }
  }

  post {
    success {
      echo "CI Pipeline completed successfully"
    }
    failure {
      echo "CI Pipeline failed"
    }

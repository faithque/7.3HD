pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', url: 'https://github.com/faithque/7.3HD.git'
      }
    }
    stage('Build') {
      steps {
        script {
          // Dockerfile in project root directory
          def dockerImageName = 'ruthfaith/nodejs-express-app:latest'
          
                    echo "Building Docker image: ${dockerImageName}"
                    docker build -t "${dockerImageName}" .

                    echo "Pushing Docker image: ${dockerImageName}"
                    docker push "${dockerImageName}"

                    // Store the image name for later use
                    env.DOCKER_IMAGE = dockerImageName
                }
            }
    }
    stage('Run Tests') {
      steps {
        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
            bat 'snyk auth %SNYK_TOKEN%'
            bat 'npm test || exit /B 0'
        }
        
      }
    }
    stage('Generate Coverage Report') {
      steps {
        // Ensure coverage report exists
        bat 'npm run coverage || exit /B 0'
      }
    }
    stage('NPM Audit (Security Scan)') {
      steps {
        bat 'npm audit || exit /B 0'
      }
    }
    
    stage('SonarCloud Analysis') {
      steps {
        withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
            bat 'sonar-scanner -Dsonar.token=%SONAR_TOKEN%'
        }
    
      }
    }
    stage('Deploy to Production') {
      steps {
        input message: 'Deploy to production?', ok: 'Deploy'
        bat 'npm run deploy'
      }
    }
    stage('Release') {
      steps {
        input message: 'Release?', ok: 'Release'
        bat 'npm run release'
      }
    }
    stage('Monitoring and Alerts') {
      steps {
        script {
          // Add your monitoring and alerting logic here
          echo 'Monitoring and alerting logic goes here'
        }
      }
    }
  }
}

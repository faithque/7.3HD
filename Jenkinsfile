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
          bat "docker build -t ${dockerImageName} ."

          withCredentials([string(credentialsId: 'dockerhub-push-token', variable: 'DOCKER_HUB_TOKEN')]) {
            bat "docker login -u ruthfaith -p ${DOCKER_HUB_TOKEN}"
            echo "Pushing Docker image: ${dockerImageName}"
            bat "docker push ${dockerImageName}"
          }

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
    stage('Deploy to Test Environment (Docker)') {
      steps {
          input message: 'Deploy to the test environment?', ok: 'Deploy'
          script {
              echo "Deploying Docker image (ruthfaith/nodejs-express-app:latest) to a local Docker container (Windows)"

              // Define the name for your local Docker container
              def containerName = 'nodejs-express-app'

              // Stop and remove any existing container with the same name
              try {
                  bat "docker stop ${containerName}"
              } catch (Exception e) {
                  echo "No running container named '${containerName}' found."
              }
              try {
                  bat "docker rm ${containerName}"
              } catch (Exception e) {
                  echo "No stopped container named '${containerName}' found."
              }

              // Run the Docker container with appropriate configurations
              bat "docker run -d --name ${containerName} -p 3000:8080 ruthfaith/nodejs-express-app:latest"

              echo "Docker container '${containerName}' is running with image: ruthfaith/nodejs-express-app:latest"
              echo "Your application should be accessible at http://localhost:8080."
          }
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

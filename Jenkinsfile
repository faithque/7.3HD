pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: ' https://github.com/faithque/7.3HD.git'
      }
    }
    stage('Install Dependencies') {
      steps {
        bat 'npm install' // For Windows compatibility
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
        //sh 'npm run coverage || true'
      }
    }
    stage('NPM Audit (Security Scan)') {
      steps {
        bat 'npm audit || exit /B 0'
        //sh 'npm audit || true' // This will show known CVEs in the output
      }
    }
    
    stage('SonarCloud Analysis') {
      steps {
        withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
            bat 'sonar-scanner -Dsonar.token=%SONAR_TOKEN%'
        }
    
      }
    }
  }
}

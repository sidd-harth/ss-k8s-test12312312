pipeline {
  agent any

triggers { pollSCM('') }

  tools {
    nodejs 'nodejs-22-6-0'
  }

  stages {
    stage('Print Version') {
      steps {
        sh 'npm -v'
        sh 'node -v'
      }
    }
  }
}
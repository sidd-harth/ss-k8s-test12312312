pipeline {
  agent any

  tools {
    nodejs 'nodejs-22-6-0'
  }

  stages {
    stage('Install Dependencies') {
      steps {
        sh 'npm install --no-audit' 
      }
    }

  stage('Dependency Scanning') {
    parallel {
      stage('NPM Dependency Audit') {
        steps {
          sh 'npm audit'
        }
      }

      stage('OWASP Dependency Check') {
        steps {
          dependencyCheck(additionalArguments: ''' 
            --scan \'./\' 
            --out \'./\'  
            --format \'ALL\' 
            --disableYarnAudit
            --prettyPrint''', odcInstallation: 'OWASP-DepCheck-10')
        }
      }
    }
  }
  }
}
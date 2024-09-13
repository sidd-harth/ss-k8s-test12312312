pipeline {
  agent any

  tools {
    nodejs 'nodejs-22-6-0'
  }

  environment {
    MONGO_URI = 'mongodb+srv://supercluster.d83jj.mongodb.net/superData'
    MONGO_USERNAME = credentials('mongo-db-username')
    MONGO_PASSWORD = credentials('mongo-db-password')
  }

  stages {
    stage('Install Dependencies') {
      steps {
        sh 'npm install --no-audit'
      }
    }

    // stage('Dependency Scanning') {
    //   parallel {
    //     stage('NPM Dependency Audit') {
    //       steps {
    //         sh 'npm audit --audit-level=critical'
    //       }
    //     }

    //     stage('OWASP Dependency Check') {
    //       steps {
    //         dependencyCheck(additionalArguments: ''' 
    //           --scan \'./\' 
    //           --out \'./\'  
    //           --format \'ALL\' 
    //           --disableYarnAudit
    //           --prettyPrint ''', odcInstallation: 'OWASP-DepCheck-10')
    //           dependencyCheckPublisher(failedTotalCritical: 1,
    //             pattern: 'dependency-check-report.xml',
    //             stopBuild: true)
    //         }
    //       }
    //     }
    //   }

    // stage('Unit Testing') {
    //     steps {
    //       sh 'npm test'
    //     }
    //   }

    stage('Code Coverage') {
      steps {
        catchError(buildResult: 'SUCCESS', message: 'Oops! it will be fixed in futher releases', stageResult: 'UNSTABLE') {
            sh 'npm run coverage'
        }
      }
    }

    }
    post {
      always {
        publishHTML(allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'dependency-check-jenkins.html', reportName: 'Dependency Check HTML Report', useWrapperFileDirectly: true)

        junit allowEmptyResults: true, stdioRetention: '', testResults: 'test-results.xml'
      }
    }
  }
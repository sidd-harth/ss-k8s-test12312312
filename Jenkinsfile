pipeline {
  agent any

  tools {
    nodejs 'nodejs-22-6-0'
  }

  environment {
    MONGO_URI = 'mongodb+srv://supercluster.d83jj.mongodb.net/superData'
    MONGO_USERNAME = credentials('mongo-db-username')
    MONGO_PASSWORD = credentials('mongo-db-password')
    SONAR_SCANNER_HOME = tool 'sonarqube-scanner-610'
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

 stage('SonarQube - SAST') {
      steps {
        sh '''
          $SONAR_SCANNER_HOME/bin/sonar-scanner \
            -Dsonar.projectKey=solar-system-lab \
            -Dsonar.sources=. \
            -Dsonar.host.url=http://localhost:9000 \
            -Dsonar.javascript.lcov.reportPaths=./coverage/lcov.info \
            -Dsonar.login=sqp_3162e8f82cb55cb33ff415e217914e72b0db33d9
        '''
      }
    }

    }
    post {
      always {
        publishHTML(allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'dependency-check-jenkins.html', reportName: 'Dependency Check HTML Report', useWrapperFileDirectly: true)

        junit allowEmptyResults: true, stdioRetention: '', testResults: 'test-results.xml'

        publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'coverage/lcov-report', reportFiles: 'index.html', reportName: 'Code Coverage HTML Report', reportTitles: '', useWrapperFileDirectly: true])
      }
    }
  }
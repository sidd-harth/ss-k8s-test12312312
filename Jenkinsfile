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
    GITEA_TOKEN = credentials('gitea-api-token')
  }

  stages {
   stage('Install Dependencies') {
     steps {
      sh 'ls .'
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

//     stage('Code Coverage') {
//       steps {
//         catchError(buildResult: 'SUCCESS', message: 'Oops! it will be fixed in futher releases', stageResult: 'UNSTABLE') {
//             sh 'npm run coverage'
//         }
//       }
//     }

//  stage('SonarQube - SAST') {
//       steps {
//         withSonarQubeEnv('sonar-qube-server') {
//         sh '''
//           $SONAR_SCANNER_HOME/bin/sonar-scanner \
//             -Dsonar.projectKey=ss2 \
//             -Dsonar.sources=. \
//             -Dsonar.javascript.lcov.reportPaths=./coverage/lcov.info
//         '''
//       }
//       timeout(time: 5, unit: 'MINUTES') {
//           waitForQualityGate abortPipeline: true
//        }
//       }
//     }

   stage('Build Docker Image') {
     steps {
       sh  ''' 
             docker build -t siddharth67/solar-system:$GIT_COMMIT .
           '''
     }
   }

    // stage('Trivy Scan') {
    //   steps {
    //     sh  ''' 
    //           trivy image siddharth67/solar-system:$GIT_COMMIT \
    //           --severity HIGH,CRITICAL \
    //           --exit-code 1 \
    //           --format json -o trivy-image-CRITICAL-results.json
    //         '''
    //   }
    // }
    stage('Publish Image - DockerHub') {
      steps {
        withDockerRegistry(credentialsId: 'docker-hub-credentials', url: "") {
          sh  'docker push siddharth67/solar-system:$GIT_COMMIT'
        }
      }
    }

    // stage('Upload - AWS S3') {
    //   steps {
    //     withAWS(credentials: 'localstack-aws-credentials', endpointUrl: 'http://localhost:4566', region: 'us-east-1') {
    //       sh  '''
    //           ls -ltr
    //           mkdir reports-$BUILD_ID
    //           cp -rf coverage/ reports-$BUILD_ID/
    //           cp test-results.xml reports-$BUILD_ID/
    //           ls -ltr reports-$BUILD_ID/
    //         '''
    //       s3Upload(
    //           file: "reports-$BUILD_ID", 
    //           bucket:'solar-system-jenkins-reports-bucket', 
    //           path:"jenkins-$BUILD_ID/",
    //           pathStyleAccessEnabled: true
    //       )
    //     }
    //   }
    // }

//    stage('Integration Testing - EC2') {
//      steps {
//          sh '''
//              bash dev-integration-test-ec2.sh
 //           '''
 //       }  
 //   }

    //  stage('Integration Testing - EC2') {
    //   when {
    //     branch 'feature/*'
    //   }
    //   steps {
    //       sh 'printenv'
          
    //     }  
    // }

    //      stage('Integration Testing - EC2222222222222') {
    //   when {
    //             expression {
    //                 env.GIT_BRANCH.startsWith('feature')
    //             }
    //         }
    //   steps {
    //       sh 'printenv'
          
    //     }  
    // }

    stage('Update and Commit Image Tag') {
      steps {
        sh 'ls .'
        sh 'git clone -b main http://192.168.0.104:5555/dasher-org/solar-system-gitops-argocd'
        sh 'ls .'
        dir("solar-system-gitops-argocd/kubernetes") {
          sh '''
            ls ../../
            git checkout main
            ls ../../
            git checkout -b feature-$BUILD_ID
            ls ../../
            sed -i "s#siddharth67.*#siddharth67/solar-system:$GIT_COMMIT#g" deployment.yml
            ls ../../
            cat deployment.yml
            ls ../../
            git config --global --unset-all user.name
            git config --global user.email "jenkins@dasher.com"
            git remote set-url origin http://$GITEA_TOKEN@192.168.0.104:5555/dasher-org/solar-system-gitops-argocd
            git checkout feature-$BUILD_ID
            git add .
            git commit -am "Updated docker image"
            git push -u origin feature-$BUILD_ID
          '''
        }
      }
    }

    stage('Kubernetes Deployment - Raise PR') {
      steps {
        sh """
          curl -X 'POST' \
            'http://192.168.0.104:5555/api/v1/repos/dasher-org/solar-system-gitops-argocd/pulls' \
            -H 'accept: application/json' \
            -H 'Authorization: token $GITEA_TOKEN' \
            -H 'Content-Type: application/json' \
            -d '{
            "assignee": "dasher-admin",
            "assignees": [
              "dasher-admin"
            ],
            "base": "main",
            "body": "Updated docker image in deployment manifest",
            "head": "feature-$BUILD_ID",
            "title": "Updated Docker Image"
          }'
        """
      }
    } 
    }
    post {
      always {
        script {
            if (fileExists('solar-system-gitops-argocd')) {
            sh 'rm -rf solar-system-gitops-argocd'
            }
        }
        publishHTML(allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'dependency-check-jenkins.html', reportName: 'Dependency Check HTML Report', useWrapperFileDirectly: true)

        junit allowEmptyResults: true, stdioRetention: '', testResults: 'test-results.xml'

        publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'coverage/lcov-report', reportFiles: 'index.html', reportName: 'Code Coverage HTML Report', reportTitles: '', useWrapperFileDirectly: true])

        // sh ''' trivy convert \
        //         --format template --template "@/usr/local/share/trivy/templates/html.tpl" \
        //         --output trivy-image-CRITICAL-results.html trivy-image-CRITICAL-results.json
        //   '''
        publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'trivy-image-CRITICAL-results.html', reportName: 'Trivy Image Critical Vul Report', reportTitles: '', useWrapperFileDirectly: true])
      }
    }
  }
@Library('dasher-trusted-shared-library') _

pipeline {
  agent {
      kubernetes {
          yamlFile 'k8s-agent.yaml'
          defaultContainer 'node-18'
      }
  }

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
          sh 'node -v'
          sh 'npm install --no-audit'
        
      }
    }

    stage('Dependency Scanning') {
      parallel {
        stage('NPM Dependency Audit') {
          steps {
              sh 'node -v'
              sh 'npm audit --audit-level=critical'
            
          }
        }

        // stage('OWASP Dependency Check') {
        //   steps {
        //     dependencyCheck(additionalArguments: ''' 
        //       --scan \'./\' 
        //       --out \'./\'  
        //       --format \'ALL\' 
        //       --disableYarnAudit
        //       --prettyPrint ''', odcInstallation: 'OWASP-DepCheck-10')
        //       dependencyCheckPublisher(failedTotalCritical: 1,
        //         pattern: 'dependency-check-report.xml',
        //         stopBuild: true)
        //     }
        //   }
        }
      }

      stage('Unit Testing') {
          parallel {
              stage('NodeJS 18') {
                  steps {
                      sh 'node -v'
                      sh 'npm test'
                  }
              }
              stage('NodeJS 19') {
                  steps {
                      container('node-19') {
                          sh 'sleep 10s'
                          sh 'node -v'
                          sh 'npm test'
                      }
                  }
              }
              stage('NodeJS 20') {
                  agent {
                      docker {
                          image 'node:20-alpine'
                      }
                  }
                  steps {
                      sh 'node -v'
                      sh 'npm test'
                  }
              }
          }
      }    

    stage('Code Coverage') {
      steps {
          catchError(buildResult: 'SUCCESS', message: 'Oops! it will be fixed in futher releases', stageResult: 'UNSTABLE') {
              sh 'npm run coverage'
          
        }
      }
    }

    // stage('SonarQube - SAST') {
    //   steps {
    //     withSonarQubeEnv('sonar-qube-server') {
    //       sh '''
    //         $SONAR_SCANNER_HOME/bin/sonar-scanner \
    //           -Dsonar.projectKey=<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Project name in sonarqube>>>>>>>>>>>>>>>>>>>>>\
    //           -Dsonar.sources=. \
    //           -Dsonar.javascript.lcov.reportPaths=./coverage/lcov.info
    //       '''
    //     } 
    //     timeout(time: 5, unit: 'MINUTES') {
    //       waitForQualityGate abortPipeline: true
    //     }
    //   }
    // }

    stage('Build Docker Image') {
      agent any
      steps {
        sh  ''' 
              docker build -t siddharth67/solar-system:$GIT_COMMIT .
        '''
      }
    }

    stage('Trivy Scan') {
      agent any
      steps {
        script {
          trivyScan.vulnerability("siddharth67/solar-system:$GIT_COMMIT")
        }
      }
    }

    // stage('Publish Image - DockerHub') {
    //   steps {
    //     withDockerRegistry(credentialsId: 'docker-hub-credentials', url: "") {
    //       sh  'docker push siddharth67/solar-system:$GIT_COMMIT'
    //     }
    //   }
    // }

    // stage('Localstack - AWS S3') {
    //   steps {
    //     withAWS(credentials: 'localstack-aws-credentials', endpointUrl: 'http://localhost:4566', region: 'us-east-1') {
    //       sh  '''
    //           ls -ltr
    //           mkdir reports-$BUILD_ID
    //           cp -rf coverage/ reports-$BUILD_ID/
    //           cp dependency*.* test-results.xml trivy*.* reports-$BUILD_ID/
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

    // stage('Deploy to AWS EC2') {
    //   when {
    //     branch 'feature/*'
    //   }
    //   steps {
    //     script {
    //       sshagent(['aws-dev-deploy-ec2-instance']) {
    //         sh '''
    //             ssh -o StrictHostKeyChecking=no <<<<replace-ec2-username>>>>>@<<<<replace-ec2-ip>>>>> "
    //             if sudo docker ps -a | grep -q "solar-system"; then
    //             echo "Container found. Stopping..."
    //                     sudo docker stop "solar-system" && sudo docker rm "solar-system"
    //             echo "Container stopped and removed."
    //             fi
    //             sudo docker run --name solar-system \
    //             -e MONGO_URI=$MONGO_URI \
    //             -e MONGO_USERNAME=$MONGO_USERNAME \
    //             -e MONGO_PASSWORD=$MONGO_PASSWORD \
    //             -p 3000:3000 -d <<<<replace-dockerhub-username>>>>>/solar-system:$GIT_COMMIT
    //             "
    //         '''
    //       }
    //     }
    //   }
    // }

    // stage('Integration Testing - EC2') {
    //   when {
    //     branch 'feature/*'
    //   }
    //   steps {
    //       sh '''
    //           bash dev-integration-test-ec2.sh
    //         '''
    //     }  
    // }

    // stage('Update and Commit Image Tag') {
    //   when {
    //     branch 'PR*'
    //   }
    //   steps {
    //     sh 'git clone -b main <<<replace-gitea-url>>>/dasher-org/solar-system-gitops-argocd'
    //     dir("solar-system-gitops-argocd/kubernetes") {
    //       sh '''
    //         git checkout main
    //         git checkout -b feature-$BUILD_ID
    //         sed -i "s#<<<<REPLACE-dockerhub-username>>>.*#<<<<REPLACE-dockerhub-username>>>/solar-system:$GIT_COMMIT#g" deployment.yml
    //         cat deployment.yml
    //         git config --global --unset-all user.name
    //         git config --global user.email "jenkins@dasher.com"
    //         git remote set-url origin http://$GITEA_TOKEN@<<<replace-gitea-domain>>>/dasher-org/solar-system-gitops-argocd
    //         git add .
    //         git commit -am "Updated docker image"
    //         git push -u origin feature-$BUILD_ID
    //       '''
    //     }
    //   }
    // }

    // stage('Kubernetes Deployment - Raise PR') {
    //   when {
    //     branch 'PR*'
    //   }
    //   steps {
    //     sh """
    //       curl -X 'POST' \
    //         '<<<replace-gitea-url>>>/api/v1/repos/dasher-org/solar-system-gitops-argocd/pulls' \
    //         -H 'accept: application/json' \
    //         -H 'Authorization: token $GITEA_TOKEN' \
    //         -H 'Content-Type: application/json' \
    //         -d '{
    //         "assignee": "<<<replace-gitea-username>>>",
    //         "assignees": [
    //           "<<<replace-gitea-username>>>"
    //         ],
    //         "base": "main",
    //         "body": "Updated docker image in deployment manifest",
    //         "head": "feature-$BUILD_ID",
    //         "title": "Updated Docker Image"
    //       }'
    //     """
    //   }
    // }

    // stage('DAST - OWASP ZAP') {
    //   when {
    //     branch 'PR*'
    //   }
    //   steps {
    //     sh '''
    //       chmod 777 $(pwd)
    //       echo $(id -u):$(id -g)  
    //       docker run -v $(pwd):/zap/wrk/:rw  ghcr.io/zaproxy/zaproxy zap-api-scan.py \
    //         -t https://815f-49-206-36-222.ngrok-free.app/api-docs/ \
    //         -f openapi \
    //         -r zap_report.html \
    //         -w zap_report.md \
    //         -J zap_json_report.json \
    //         -c zap_ignore_rules
    //     '''
    //   }
    // }

    // stage('Deploy to Prod?') {
    //   when {
    //     branch 'main'
    //   }
    //   steps {
    //     timeout(time: 1, unit: 'DAYS') {
    //       input message: 'Is the PR Merged and ArgoCD Synced?', ok: 'YES! PR is Merged and ArgoCD Application is Synced', submitter: 'admin'
    //     }
    //   }
    // }

    // stage('Lambda - S3 Upload & Deploy') {
    //   when {
    //     branch 'main'
    //   }      
    //   steps {
    //     withAWS(credentials: 'localstack-aws-credentials', endpointUrl: 'http://localhost:4566', region: 'us-east-1') {
    //       sh '''
    //         sed -i "/^app\\.listen(3000/ s/^/\\/\\//" app.js
    //         sed -i "s/^module.exports = app;/\\/\\/module.exports = app;/g" app.js
    //         sed -i "s|^//module.exports.handler|module.exports.handler|" app.js
    //         tail -5 app.js
    //       '''
    //       sh  '''
    //         zip -qr solar-system-lambda-$BUILD_ID.zip app* package* index.html node*
    //         ls -ltr solar-system-lambda-$BUILD_ID.zip
    //       '''
    //       s3Upload(
    //           file: "solar-system-lambda-${BUILD_ID}.zip", 
    //           bucket:'solar-system-lambda-bucket',
    //           pathStyleAccessEnabled: true
    //         )
    //       sh '''
    //         aws --endpoint-url http://localhost:4566 lambda update-function-code \
    //          --function-name solar-system-lambda-function \
    //          --s3-bucket solar-system-lambda-bucket \
    //          --s3-key solar-system-lambda-${BUILD_ID}.zip
    //       '''
    //       sh """
    //         aws --endpoint-url http://localhost:4566  lambda update-function-configuration \
    //         --function-name solar-system-lambda-function \
    //         --environment '{"Variables":{ "MONGO_USERNAME": "${MONGO_USERNAME}","MONGO_PASSWORD": "${MONGO_PASSWORD}","MONGO_URI": "${MONGO_URI}"}}'
    //       """
    //     }
    //   }
    // }
    // stage('Lambda - Invoke Function') {
    //   when {
    //     branch 'main'
    //   }   
    //   steps {
    //     withAWS(credentials: 'localstack-aws-credentials', endpointUrl: 'http://localhost:4566', region: 'us-east-1') {
    //      sh '''
    //         sleep 5s
    //         function_url_data=$(aws --endpoint-url http://localhost:4566  lambda get-function-url-config --function-name solar-system-lambda-function)
    //         function_url=$(echo $function_url_data | jq -r '.FunctionUrl | sub("/$"; "")')
    //         curl -Is  $function_url/live | grep -i "200 OK"
    //      '''
    //     }
    //   }
    // }   
    }
  //  post {
//      always {
        // script {
        //     if (fileExists('solar-system-gitops-argocd')) {
        //     sh 'rm -rf solar-system-gitops-argocd'
        //     }
        // }
        // publishHTML(allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'dependency-check-jenkins.html', reportName: 'Dependency Check HTML Report', useWrapperFileDirectly: true)

        // junit allowEmptyResults: true, stdioRetention: '', testResults: 'test-results.xml'

        // publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'coverage/lcov-report', reportFiles: 'index.html', reportName: 'Code Coverage HTML Report', reportTitles: '', useWrapperFileDirectly: true])
             
             
              // script {
              //  trivyScan.reportConverter()
              // }

              
       // publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: './', reportFiles: 'trivy-image-CRITICAL-results.html', reportName: 'Trivy Image Critical Vul Report', reportTitles: '', useWrapperFileDirectly: true])
   //   }
 //   }
}

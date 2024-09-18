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
        sh 'echo 1'
      }
    }

    stage('Dependency Scanning') {
      parallel {
        stage('NPM Dependency Audit') {
          steps {
            sh 'echo 1'
          }
        }

        stage('OWASP Dependency Check') {
          steps {
sh 'echo 1'
            }
          }
        }
      }

    stage('Unit Testing') {
        steps {
          sh 'echo 1'
        }
      }

    stage('Code Coverage') {
      steps {
        catchError(buildResult: 'SUCCESS', message: 'Oops! it will be fixed in futher releases', stageResult: 'UNSTABLE') {
            sh 'echo 1'
        }
      }
    }

    stage('SonarQube - SAST') {
      steps {
       sh 'echo 1'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh  ''' 
              sh 'echo 1'
        '''
      }
    }

    stage('Trivy Scan') {
      steps {
        sh  ''' 
             sh 'echo 1'
            '''
      }
    }

    stage('Publish Image - DockerHub') {
      steps {
       sh 'echo 1'
      }
    }

    stage('Localstack - AWS S3') {
      steps {
        sh 'echo 1'
      }
    }

    stage('Deploy to AWS EC2') {
      when {
        branch 'feature/*'
      }
      steps {
        sh 'echo 1'
      }
    }

    stage('Integration Testing - EC2') {
      when {
        branch 'feature/*'
      }
      steps {
          sh 'echo 1'
        }  
    }

    stage('Update and Commit Image Tag') {
      when {
        branch 'PR*'
      }
      steps {
       sh 'echo 1'
      }
    }

    stage('Kubernetes Deployment - Raise PR') {
      when {
        branch 'PR*'
      }
      steps {
sh 'echo 1'
      }
    }

    stage('DAST - OWASP ZAP') {
      when {
        branch 'PR*'
      }
      steps {
        sh 'echo 1'
      }
    }

    stage('Deploy to Prod?') {
      when {
        branch 'main'
      }
      steps {
        timeout(time: 1, unit: 'DAYS') {
          input message: 'Is the PR Merged and ArgoCD Synced?', ok: 'YES! PR is Merged and ArgoCD Application is Synced', submitter: 'admin'
        }
      }
    }

    stage('Lambda - S3 Upload & Deploy') {
      when {
        branch 'main'
      }      
      steps {
        sh 'echo 1'
      }
    }
    stage('Lambda - Invoke Function') {
      when {
        branch 'main'
      }   
      steps {
        sh 'echo 1'
      }
    }   
    

//   stage('Install Dependencies') {
//     steps {
//       sh 'printenv'
//     sh 'npm install --no-audit'
//  }
// }

//   stage('dummy file') {
//     steps {
//       sh 'touch test-reposts.xml'
//       sh 'touch trivy-image-reposts.xml'
//       sh 'touch dependency-reposts.xml'
//       sh 'touch zap-reposts.xml'
//       sh 'touch reports-reposts.xml'
//       sh 'mkdir coverage'

//  }
// }

    // stage('Lambda - S3 Upload & Deploy') {
  //     steps {
  //       script{
  //       withAWS(credentials: 'localstack-aws-credentials', endpointUrl: 'http://localhost:4566', region: 'us-east-1') {
  //         sh '''
  //           tail -5 app.js
  //           echo "************************************"
            
  //           sed -i "/^app\\.listen(3000/ s/^/\\/\\//" app.js
  //           sed -i "s/^module.exports = app;/\\/\\/module.exports = app;/g" app.js
  //           sed -i "s|^//module.exports.handler|module.exports.handler|" app.js

  //           echo "************************************"
  //           tail -5 app.js
  //         '''
  //         sh  '''
  //           ls
  //           zip -qr solar-system-lambda-$BUILD_ID.zip app* package* index.html node*
  //           ls -ltr solar-system-lambda-$BUILD_ID.zip
  //         '''
  //         s3Upload(
  //             file: "solar-system-lambda-${BUILD_ID}.zip", 
  //             bucket:'solar-system-lambda-bucket',
  //             pathStyleAccessEnabled: true
  //           )
  //         sh """
  //         /usr/local/bin/aws --endpoint-url http://localhost:4566  lambda update-function-configuration \
  //         --function-name solar-system-lambda-function \
  //         --environment '{"Variables":{ "MONGO_USERNAME": "${MONGO_USERNAME}","MONGO_PASSWORD": "${MONGO_PASSWORD}","MONGO_URI": "${MONGO_URI}"}}'
  //         """
  //       }
  //     }
  //     }
  //   }
  //   stage('Lambda - Invoke Function') {
  //     steps {
  //       withAWS(credentials: 'localstack-aws-credentials', endpointUrl: 'http://localhost:4566', region: 'us-east-1') {
  //        sh '''
  //           sleep 5s
  //           function_url_data=$(/usr/local/bin/aws --endpoint-url http://localhost:4566  lambda get-function-url-config --function-name solar-system-lambda-function)
  //           function_url=$(echo $function_url_data | jq -r '.FunctionUrl | sub("/$"; "")')
  //           curl -Is  $function_url/live | grep -i "200 OK"
  //        '''
  //     }
  //   }

  //   }
// stage('DAST - OWASP ZAP') {
//   steps {
//     sh '''
//               echo $(id -u):$(id -g)
//       chmod 777 $(pwd)
//       echo $(id -u):$(id -g)  
//       #### REPLACE below with Kubernetes http://IP_Address:30000/api-docs/ #####
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


//     stage('Deploy to Prod?') {
//       when {
//         branch 'main'
//       }
//       steps {
//         timeout(time: 1, unit: 'DAYS') {
//           input message: 'Is the PR Merged and ArgoCD Synced?', ok: 'YES! PR is Merged and ArgoCD Application is Synced', submitter: 'admin'
//         }
//       }
//     }
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

  //  stage('Build Docker Image') {
  //    steps {
  //      sh  ''' 
  //            docker build -t siddharth67/solar-system:$GIT_COMMIT .
  //          '''
  //    }
  //  }


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
    //     stage('Publish Image - DockerHub') {
    //   steps {
    //     withDockerRegistry(credentialsId: 'docker-hub-credentials', url: "") {
    //       sh  'docker push siddharth67/solar-system:$GIT_COMMIT'
    //     }
    //   }
    // }

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

//stage('Update and Commit Image Tag') {
//     steps {
//       sh 'git clone -b main http://192.168.0.104:5555/dasher-org/solar-system-gitops-argocd'
//       dir("solar-system-gitops-argocd/kubernetes") {
//         sh '''
//           git checkout main
//           git checkout -b feature-$BUILD_ID
//           sed -i "s#siddharth67.*#siddharth67/solar-system:$GIT_COMMIT#g" deployment.yml
//           cat deployment.yml
// git config --global --unset-all user.name
// git config --global user.email "jenkins@dasher.com"
// git remote set-url origin http://$GITEA_TOKEN@192.168.0.104:5555/dasher-org/solar-system-gitops-argocd
// git checkout feature-$BUILD_ID
// git add .
// git commit -am "Updated docker image"
// git push -u origin feature-$BUILD_ID
//         '''
//       }
//     }
//   }

// stage('Kubernetes Deployment - Raise PR') {
//     steps {
//       sh """
//         curl -X 'POST' \
//           'http://192.168.0.104:5555/api/v1/repos/dasher-org/solar-system-gitops-argocd/pulls' \
//           -H 'accept: application/json' \
//           -H 'Authorization: token $GITEA_TOKEN' \
//           -H 'Content-Type: application/json' \
//           -d '{
//           "assignee": "dasher-admin",
//           "assignees": [
//             "dasher-admin"
//           ],
//           "base": "main",
//           "body": "Updated docker image in deployment manifest",
//           "head": "feature-$BUILD_ID",
//           "title": "Updated Docker Image"
//         }'
//       """
//     }
//   } 
    }
    post {
      always {
        script {
            if (fileExists('solar-system-gitops-argocd')) {
            sh 'rm -rf solar-system-gitops-argocd'
            }
            if (fileExists('solar-system-lambda-$BUILD_ID.zip')) {
            sh 'rm -f solar-system-lambda-$BUILD_ID.zip'
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
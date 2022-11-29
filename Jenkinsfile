pipeline{
    agent any
    tools {
        maven 'maven386'
    }
    
    stages {
        stage('1.SCM Clone') {
            steps {
                sh 'echo Starting Git clone'
                git credentialsId: 'Github-Cred', url: 'https://github.com/owseaman/maven-web-app.git'
            }
        }
        
        stage('2.Build the app') {
            steps {
                sh 'echo Building the app package'
                sh 'mvn clean package'
                
            }
              
             
        }
        
        stage('3. Code Test SAST e.g sonarqube, selenium') {
            steps {
                sh 'echo install sonarQube first then use mvn sonar:sonar for code quality test'
                //sh "mvn sonar:sonar"
            }
        }
        
        stage('4. Artifactory') {
            steps {
                sh 'echo artifact backup to artifactory e.g Nexus'
                //sh 'mvn deploy'
            }    
        }
        
        stage('5. Docker Image Build') {
            steps {
                sh 'docker build -t owseaman/dpc-demo .'
		//If you get an error in this "Docker Image Build" section, uncomment the next line
		//sh 'sudo chmod 666 /var/run/docker.sock'
            }
        }
        
        stage('6. Push image to Container Registry-Dockerhub/ECR etc') {
            steps {
               withCredentials([string(credentialsId: 'Dockerhub-Cred', variable: 'DHC_Var')]) {
    
                sh 'docker login -u owseaman -p $DHC_Var'
                
                sh 'docker push owseaman/dpc-demo'
                
                    
                }
            }
        }
        
        stage('7. Remove Container Images') {
            steps {
		sh 'echo gotta save some space in the instance'    
                sh 'docker rmi $(docker images -q)'
            }
        }
        
        stage('8. K8s Deployment') {
			steps {
			    sh 'kubectl apply -f maven-web-app.yml'
			}	
        }
        
        stage('9. slackMessage') {
            steps {
                sh 'echo Awaiting approval from Team/project Lead'
                //slackSend message: 'DeployedforUAT, expecting approval'
            }
        }
        
        stage('10. Deploy to UAT') {
            steps {
                sh 'echo deploy to web server e.g Nginx or Apache Tomcat for User Acceptance Testing'
            }
        }
        
        stage('11. Approval Needed for Production') {
            steps {
                input message: 'for your approval for Production', parameters: [choice(choices: ['Proceed', 'Wait', 'Abort'], description: 'Description to show user', name: 'Proceed?')]
                // timeout(time:5, unit:'DAYS') {input message: 'Approval for Production'}
            }
        }
        
        stage('12. Deploy to Production') {
            steps {
                sh 'echo deployed to Production'
            }
        }    
        
       stage('13. Email Notifs') {
           steps {
               emailext body: 'You are one of the Build users', recipientProviders: [buildUser()], subject: 'Hey, Build User!', to: 'esowoeye@gmail.com'
            }   
        }
    }
}    

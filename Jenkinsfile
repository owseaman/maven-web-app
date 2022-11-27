pipeline{
    agent any
    tools {
        maven 'maven386'
    }
    
    stages {
        stage('1.gitClone') {
            steps {
                sh "echo start git clone"
                git credentialsId: 'Github-Cred', url: 'https://github.com/owseaman/maven-web-app.git'
            }
        }
        
        stage('2.build the app') {
            steps {
                sh 'echo Building the app package'
                sh 'mvn clean package'
                
            }
              
             
        }
        
        stage('3. Code Test') {
            steps {
                sh "echo install sonarQube first then use mvn sonar:sonar for code quality test"
                //sh "mvn sonar:sonar"
            }
        }
        
        stage('4. Artifactory') {
            steps {
                sh 'echo artifact backup to artifactory e.g Nexus'
                //sh 'mvn deploy'
            }    
        }
        
        stage('Docker Image Build') {
            steps {
                sh "docker build -t owseaman/dpc-demo ."
            }
        }
        
        stage("Push image to Container Registry-Dockerhub/ECR etc") {
            steps {
               withCredentials([string(credentialsId: 'Dockerhub-Cred', variable: 'DHC_Var')]) {
    // some block


                sh 'docker login -u owseaman -p $DHC_Var'
                
                sh 'docker push owseaman/dpc-demo'
                
                    
                }
            }
        }
        
        stage(removeContainerImages) {
            steps {
                sh 'docker rmi $(docker images -q)'
            }
        }
        
        stage('K8s Deployment') {
			steps {
			    sh 'kubectl apply -f maven-web-app.yml'
			}	
        }
        
        stage('5.slackMessage') {
            steps {
                sh "echo Awaiting approval"
                //slackSend message: 'DeployedforUAT, expecting approval'
            }
        }
        
        stage("6.deploytoUAT") {
            steps {
                sh "echo deploy to web server e.g Nginx or Apache Tomcat for User Acceptance Testing"
            }
        }
        
        stage('7.approvalNeededforProduction') {
            steps {
                input message: 'for your approval for Production', parameters: [choice(choices: ['Proceed', 'Wait', 'Abort'], description: 'Description to show user', name: 'Proceed?')]
                // timeout(time:5, unit:'DAYS') {input message: 'Approval for Production'}
            }
        }
        
        stage("8.deploytoPROD") {
            steps {
                sh "echo deploy to Production"
            }
        }    
        
       stage('9.emailNotifs') {
           steps {
               emailext body: 'You are one of the Build users', recipientProviders: [buildUser()], subject: 'Hey, Build User!', to: 'esowoeye@gmail.com'
            }   
        }
    }
}    

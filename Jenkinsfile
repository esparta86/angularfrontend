// Template Jenkinsfile
//
// Lisandro Antonio Rafaelano Colocho -  DevOps
//
// This Jenkinsfile allows create a smart pipeline in order to deploy in production, 
// if there are changes in the branch  selected.
//
//  Please replace the variables between brackets  
//  example:  '{ID_GCP_PROJECT}'  will be  'ti-is-devenv-01'
//


// @project will store the GCP PROJECT ID
 
def project ='devops8687'


//  @appNameI will have the name of DockerImage and it will store in the gcr.io of gcp project
//  please start with  is-
def  appNameI = 'is-{APP_NAME}'

//  @branchName will have the name of git branch
def  branchName = "{BRANCH}"

// @imageTag dont touch it
// this variable is generated by some other dynamic variables and you will have like this
// gcr.io/devops8687/java-v8-alpine-base:master.1
def  imageTag = "gcr.io/${project}/${appNameI}:${branchName}.${env.BUILD_NUMBER}"

// @imageContainerBase It will have the complete docker image name and version
// this value have to be the same in the deployment file in the image property. 
// this value is helpful in order to find that and replace with the new docker image name stored in imageTag (How to do that ? check out stage('Deploy ') )
//def  imageContainerBase = "gcr.io/${project}/glogger-web-app:v1"
def  imageContainerBase = "gcr.io/${project}/{DOCKER-IMAGE}:v#"


// @changesCommit boolean variable  that could be change to TRUE if there are changes in the branch
def  changesCommit = 'FALSE'


// def  namePipeline = "web-app-ti-is-devenv-external"
def  namePipeline = "{PIPELINE_NAME}"


//@workspacePipeline Nothing to do here, it will store the complete path of workspace where the slave pod will clone the repository
def  workspacePipeline = "/home/jenkins/agent/workspace/${namePipeline}"

//@emailsList It will store a list of recipients. If the Jenkins already configured in order to use the SMTP.
// It wil send a report if the pipeline finished with sucess or not
def  emailsList = 'debora.guardado@novatechdev.com'

// @environment It will store the environment used 
// environment name accepted :  production, testing and development
// It will be the same as the structure folder
// Example
// /home/lisandro.rafaelano/repository-git-ci-cd/WEB_TEAM/limesurvey_cicd/k8s/Deployment/production
def  environment = "{ENVIRONMENT}"

// -- variables deploy into kubernetes
// These variables is important because store the relative path of your yaml files that you need to create or apply changes on the cluster
// Please be carefully check before if a object already exists with the same name in order to avoid conflicts on that.
//  helpful command 
//  kubectl get svc -n namespace 
//  kubectl get deployments -n namespace
//  kubectl get configmap/secrets -n namespace
//
// Uncoment and  set the file name that you need

//def secretCredentials = "k8s/volumen/secrets/${environment}/cloudsql-db-credentials-applicationname.yaml"
//def configmapBucketSA = "k8s/volumen/Configmap/${environment}/configmapBucketSA.yaml"
//def configmapSettings = "k8s/volumen/Configmap/${environment}/configmapSettings-appname.yaml"
//def deploymentApp = "k8s/Deployment/${environment}/deployment.yaml"

//@namespace It will store the namespace where you are going to use in order to deploy your applications/
// available namespace in Testing Cluster
// Check here https://docs.google.com/presentation/d/1FDegGob2ZWybULpLcADVB1XuSFBOuvqVH8nXu0pqDZc/edit#slide=id.g60dd7cd549_0_5
// Please use according your team
// If you will need an ingress controller that will need a internal dns then you must to use production namespace
// If the internal dns does not matter then you can use according your team
def namespace = "{NAMESPACE}"

// @imageContainerBaseM this will store the docker image of maven.
// this stores a custom mvnseeting.xml in order to access to our Nexus server if you need to dowload from a repository.
// Maven Docker Images available in each projet.
// gcr.io/devops8687/is-maven-3-6-jdk8:v1
def imageContainerBaseM = "gcr.io/devops8687/is-maven-3-6-jdk8:v1"
def nameImageM = "node:latest"

//@projectKey It will store  the project name if you will need scan the repository in SonarQube Server
// http://172.25.29.38:8080
// 
//def projectKey = "{PROJECTKEY}"
//@source PATH java files
//def sources = "src-app/src/main/java"
//def binaries = "src-app/target/classes"
//def javaVersion = "1.8"
//def tokenSonar = "d3142e0782984dc107c4820881a00f82c51cea71"


//@warname defined of pom.xml
// Tomcat usually take the name of war in order to set the context path of application
def warname = "WARNAME.war"

//@src-app it will store the name folder of src-app where you have the code
// Check the slide how to Structure my projects
// https://docs.google.com/presentation/d/1FDegGob2ZWybULpLcADVB1XuSFBOuvqVH8nXu0pqDZc/edit#slide=id.g60dd7cd549_0_91
def srcapp= "APPLICATION_SRC"


// This function send a notification via Slack
def sendNotificationSlack(String buildResult = 'STARTED') {
  buildResult = buildResult ?: 'SUCCESS'
  if(currentBuild.changeSets.size() > 0 ){
 	  // Default values
	  def colorName = 'RED'
	  def colorCode = '#FF0000'
	  def subject = "${buildResult} :  Integration Job '${env.JOB_NAME} Build# [$env.BUILD_NUMBER]"
	  def summary = "${subject} (${env.BUILD_URL})"

	  def detail = """<p>${buildResult} : Integration Job '${env.JOB_NAME} Build# [$env.BUILD_NUMBER]':</p>
				   <p> Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""
    
	  if( buildResult == 'STARTED'){
		 color = 'YELLOW'
		 colorCode = '#FFFF00'
	  }else if( buildResult == 'SUCCESS'){
		 color = 'GREEN'
		 colorCode = '#00FF00'
	  }else{
		 color = 'RED'
		 colorCode = '#FF0000'
	  }
	  slackSend color: colorCode, message : summary
  }  
}

// This function retrieve all new changes in a string 
def getChangeString() {
    MAX_MSG_LEN = 100
    def changeString = "<table>"
    echo "Gathering SCM changes"
    def changeLogSets = currentBuild.changeSets
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            truncated_msg = entry.msg.take(MAX_MSG_LEN)
            changeString += " <tr><td> - ${truncated_msg} [${entry.author}]</td></tr>"
        }
    }

    if (!changeString) {
        changeString = " - No new changes"
    }
    changeString += "</table>"
    return changeString
}

// This function send a notification email
def sendNotificationEmail(String buildResult = 'STARTED',String emailsList) {
  buildResult = buildResult ?: 'SUCCESS'
  if(currentBuild.changeSets.size() > 0 ){
  def detail = """${buildResult} : Integration Job '${env.JOB_NAME} Build# [$env.BUILD_NUMBER]':
				    New changes is coming, please check console output at '${env.BUILD_URL}   ${env.JOB_NAME}  [${env.BUILD_NUMBER}] """
  
  emailext body: """ <title>${env.JOB_NAME}</title>
      <STYLE>
          body table, td, th, p, h1, h2 {
          margin:0;
          font:normal normal 100% Georgia, Serif;
          background-color: #ffffff;
          }
          h1, h2 {
          border-bottom:dotted 1px #999999;
          padding:5px;
          margin-top:10px;
          margin-bottom:10px;
          color: #000000;
          font: normal bold 130% Georgia,Serif;
          background-color:#f0f0f0;
          }
          tr.gray {
          background-color:#f0f0f0;
          }
          h2 {
          padding:5px;
          margin-top:5px;
          margin-bottom:5px;
          font: italic bold 110% Georgia,Serif;
          }
          .bg2 {
          color:black;
          background-color:#E0E0E0;
          font-size:110%
          }
          th {
          font-weight: bold;
          }
          tr, td, th {
          padding:2px;
          }
          td.test_passed {
          color:blue;
          }
          td.test_failed {
          color:red;
          }
          td.test_skipped {
          color:grey;
          }
          .console {
          font: normal normal 90% Courier New, monotype;
          padding:0px;
          margin:0px;
          }
          div.content, div.header {
          background: #ffffff;
          border: dotted
          1px #666;
          margin: 2px;
          content: 2px;
          padding: 2px;
          }
          table.border, th.border, td.border {
          border: 1px solid black;
          border-collapse:collapse;
          }
</STYLE> 
    <BODY>
        <div class="header">
          <!-- GENERAL INFO -->
          <p><b> Hi team.
            This mail is autogenerated as part of CICD pipeline execution of the job  ${env.JOB_NAME} </b>
            New Changes is coming, Please read this email for more detail or go to the Jenkins</p>
        </div>
    <div class="content">
      <h1>Build Details - IS Production environment in Kubernetes </h1>
      <table>
              <tr class="gray">
                <td align="right">
                </td>
                <td valign="center">
                  <b style="font-size: 200%;">BUILD ${buildResult}</b>
                </td>
              </tr>
              <tr>
                <td>Build URL</td>
                <td>
                  <a href="${env.BUILD_URL}">URL</a>
                </td>
              </tr>
              <tr>
                <td>Project:</td>
                <td>${env.JOB_NAME}</td>
              </tr>
              <tr>
                <td>Build Number:</td>
                <td>${env.BUILD_NUMBER}</td>
              </tr>
              <tr>
                <td>Build duration(If Build has been Finished):</td>
                <td>${currentBuild.durationString}</td>
              </tr>
            
        </table>
    </div>
    <h1>Changes list </h1> """+getChangeString()+"""

    <h3>Please Contact IS SUPPORT [ support@novatechdev.com ] If the build has been finished with errors</h3>

    Best Regards</br>
    CI&CD Team
    </BODY>
""", mimeType: 'text/html',
   recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Status of pipeline: ${currentBuild.fullDisplayName} is ${buildResult}", to: "${emailsList}"
   }
}

// Start the definition of pipeline
pipeline {
   agent {
    kubernetes {
      label '{SLAVE_NAME}'
      slaveConnectTimeout 200
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  # This service account is intern and it was created inside cluster
  # Don't confuse with GCP SA
  serviceAccountName: main-jenkins
  tolerations:
  - key: dedicated
    operator: Equal
    value: jobs
    effect: "NoSchedule"
  containers:
  - name: jnlp
    tty: true  
  - name:  ${nameImageM}
    image: ${imageContainerBaseM}
    resources:
      requests:
        cpu: 200m
        memory: 200Mi
      limits:
        cpu: 200m
        memory: 200Mi    
    command:
      - cat
    tty: true
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud:latest
    resources:
      requests:
        cpu: 100m
        memory: 200Mi
      limits:
        cpu: 100m
        memory: 200Mi    
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl:latest
    resources:
      requests:
        cpu: 200m
        memory: 200Mi
      limits:
        cpu: 200m
        memory: 200Mi    
    command:
    - cat
    tty: true
"""
}
  }
  stages {
  
   stage('Start'){

      steps {
          script{
              if(currentBuild.changeSets.size() > 0) {
                    changesCommit = 'TRUE'
                }
                else {
                    changesCommit = 'FALSE'
                }           
            }
          //sendNotificationSlack 'STARTED'
          //sendNotificationEmail 'STARTED',emailsList 
        }
   }

   stage('Install Dependencies') {
      steps {
         sh 'npm install'
      }
   }

     stage('Lint') {
      steps {
         sh 'npm run lint'
      }
   }

   stage('Unit Testing') {
      steps {
        sh 'npm run test'
    }
  }
  
  stage('SonarQube Analysis') {
        when {
           expression { currentBuild.changeSets.size() > 0 }
        }
        steps{
          script  {
                  sonarqubeScannerHome = tool 'sonarqub-scanner';
                  }
              withSonarQubeEnv('SonarIS') {
                sh "${sonarqubeScannerHome}/bin/sonar-scanner -Dsonar.projectKey=${projectKey}  -Dsonar.sources=${workspacePipeline}/${sources} -Dsonar.java.binaries=${workspacePipeline}/${binaries} -Dsonar.java.source=${javaVersion} -Dsonar.host.url=http://172.25.29.38:8080 -Dsonar.login=${tokenSonar} -Dsonar.exclusions=${workspacePipeline}/conf/,${workspacePipeline}/lib/ -Dsonar.sourceEncoding=UTF-8"
              }
        }
	  }

//    stage('SonarQube Quality Gate') {
//        when {
//             expression { currentBuild.changeSets.size() > 0 }
//          }
//          steps{
//             script  {
//                def qualitygate = waitForQualityGate()
//                 if (qualitygate.status == "ERROR"  ) {
//                    error "Pipeline aborted due to quality gate coverage failure: ${qualitygate.status}"
//                 }
//             }
//          }
//      }

     stage('Build') {
      steps {
        sh 'npm run build'
    }
  }


   stage('Create & Publish Container') {

      steps {
            container('gcloud') {
              sh "gcloud config set project ${project} "
              sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${imageTag}  ."
            }
            sleep 30
           }
    }

    

  }
  
    post {
        always {
	         // sendNotificationSlack currentBuild.currentResult
            sendNotificationEmail currentBuild.currentResult,emailsList
        }
       
    }
}
pipeline {
  agent {
    docker { image 'node:latest' }
  }
  stages {
    stage('Install') {
      steps { sh 'npm install' }
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


  stage('Build') {
      steps {
        sh 'npm run build'
    }
  }
  }
}
pipeline {
  agent any

  options { timestamps(); ansiColor('xterm') }

  environment {
    IMAGE_NAME = 'shagovvladislav/docker-demo'        // только нижний регистр!
    DOCKER_CRED_ID = 'dockerhub-credentials'          // ID кредов в Jenkins
    SHORT_SHA = "${env.GIT_COMMIT?.take(7)}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Set up Python & Test') {
      steps {
        sh '''
          python3 -V || true
          pip3 -V || true
          python3 -m pip install --upgrade pip
          pip3 install -r requirements.txt pytest
          pytest -q
        '''
      }
    }

    stage('Docker Build') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:${SHORT_SHA} -t ${IMAGE_NAME}:latest .
          docker image ls ${IMAGE_NAME}
        '''
      }
    }

    stage('Docker Push') {
      when { anyOf { branch 'main'; branch 'master' } }
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${IMAGE_NAME}:${SHORT_SHA}
            docker push ${IMAGE_NAME}:latest
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Built and (if on main) pushed ${IMAGE_NAME}:${SHORT_SHA}"
    }
    always {
      archiveArtifacts artifacts: 'Dockerfile, build.sh, deploy.sh, Jenkinsfile, requirements.txt, src/**, tests/**', onlyIfSuccessful: false
      cleanWs()
    }
  }
}

pipeline {
 agent any
 environment {
 // Docker Hub image name — change to your Docker Hub username
 DOCKER_IMAGE = "prakashlearner13/jenkinsproject"
 DOCKER_TAG = "${BUILD_NUMBER}" // unique tag per build
 LEMP_SERVER = "13.220.92.251" // IP of your Nginx/LEMP EC2
 LEMP_USER = "ubuntu"
 }
 stages {
 // ── Stage 1: Checkout code from GitHub ──────────────────────
 stage('Checkout') {
 steps {
 git branch: 'main',
 credentialsId: 'gitcredentials',
 url: 'https://github.com/prakashlearner13/Learning/'
 }
 }
 // ── Stage 2: Build Docker image from the Dockerfile ─────────
 stage('Build Docker Image') {
 steps {
 script {
 dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
 }
 }
 }
 // // ── Stage 3: Push image to Docker Hub ───────────────────────
 // stage('Push to Docker Hub') {
 // steps {
 //   script {
 // docker.withRegistry('https://hub.docker.com/repository/docker/prakashlearner13/jenkinsproject/',
 // 'dockerhubcredential') {
 // dockerImage.push("${DOCKER_TAG}")
 // dockerImage.push('latest') // also tag as latest
 // }
 // }
 // }
 // }
  // ── Stage 3: Push image to Docker Hub ───────────────────────
stage('Push to Docker Hub') {
    steps {
        script {
            docker.withRegistry('', 'dockerhubcredential') {
                dockerImage.push("${DOCKER_TAG}")
                dockerImage.push("${BUILD_NUMBER}")
            }
        }
    }
}
 // ── Stage 4: SSH into LEMP server & deploy container ─────────
 stage('Deploy to LEMP Server') {
 steps {
 sshagent(credentials: ['lemp-server-ssh']) {
 sh '''
 ssh -o StrictHostKeyChecking=no ${LEMP_USER}@${LEMP_SERVER}
\
 "docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER} && \
 docker stop myapp || true && \
 docker rm myapp || true && \
 docker run -d --name myapp \
 -p 5000:5000 \
 ${DOCKER_IMAGE}:${BUILD_NUMBER}"
 '''
 }
 }
 }
 }
 post {
 success {
 echo '✅ Pipeline succeeded — app is live on LEMP server!'
 }
 failure {
 echo '❌ Pipeline failed — check the stage logs above.'
   }
 }
}

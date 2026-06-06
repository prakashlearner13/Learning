pipeline {
agent any
environment {
    // Docker Hub image
    DOCKER_IMAGE = "prakashlearner13/jenkinsproject"
    DOCKER_TAG   = "${BUILD_NUMBER}"

    // Target EC2 / LEMP Server
    LEMP_SERVER = "13.220.92.251"
    LEMP_USER   = "ubuntu"
}

stages {

    // ── Stage 1: Checkout code ──────────────────────────────
    stage('Checkout') {
        steps {
            git branch: 'main',
                credentialsId: 'gitcredentials',
                url: 'https://github.com/prakashlearner13/Learning/'
        }
    }

    // ── Stage 2: Build Docker image ────────────────────────
    stage('Build Docker Image') {
        steps {
            script {
                dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
            }
        }
    }

    // ── Stage 3: Push image to Docker Hub ──────────────────
    stage('Push to Docker Hub') {
        steps {
            script {
                docker.withRegistry('', 'dockerhubcredential') {
                    dockerImage.push("${DOCKER_TAG}")
                    dockerImage.push('latest')
                }
            }
        }
    }

    // ── Stage 4: Deploy to EC2 ─────────────────────────────
    stage('Deploy to LEMP Server') {
        steps {
            sshagent(credentials: ['lemp-server-ssh']) {
                sh """
                    ssh -o StrictHostKeyChecking=no ${LEMP_USER}@${LEMP_SERVER} "
                        sudo docker pull ${DOCKER_IMAGE}:${DOCKER_TAG} &&
                        sudo docker stop myapp || true &&
                        sudo docker rm myapp || true &&
                        sudo docker run -d \
                            --name myapp \
                            -p 5000:5000 \
                            --restart unless-stopped \
                            ${DOCKER_IMAGE}:${DOCKER_TAG}
                    "
                """
            }
        }
    }
}

post {
    success {
        echo '✅ Pipeline succeeded — app is live on EC2!'
    }

    failure {
        echo '❌ Pipeline failed — check the stage logs above.'
    }
}

}

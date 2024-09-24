pipeline {
    agent any
    
    environment {
        // 配置相关变量
        DOCKER_IMAGE = 'auto-test-image'  // Docker 镜像名称
        ECS_IP = '8.149.129.172'          // 阿里云 ECS 的 IP 地址
        SSH_CREDENTIALS = 'ecs-ssh-credentials' // Jenkins 中设置的 SSH 凭据 ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                // 从 GitHub 仓库克隆代码，使用 HTTPS 方式
                git branch: 'main', url: 'https://github.com/taicilang-lcy/Automation_Test.git', credentialsId: 'github-automation-test-token'
            }
        }

        stage('Build Docker Image on ECS') {
            steps {
                // SSH 到阿里云 ECS，并在远程服务器上构建 Docker 容器
                script {
                    sshagent([SSH_CREDENTIALS]) { // 使用环境变量
                        sh """
                        ssh -o StrictHostKeyChecking=no root@${ECS_IP} 'cd /usr/automation_pipeline/automation_test && git pull'
                        ssh -o StrictHostKeyChecking=no root@${ECS_IP} 'cd /usr/automation_pipeline/automation_test && docker build -t ${DOCKER_IMAGE} .'
                        """
                    }
                }
            }
        }

        stage('Run Tests in Docker on ECS') {
            steps {
                // 在 ECS 上的 Docker 容器中运行测试
                script {
                    sshagent([SSH_CREDENTIALS]) { // 使用环境变量
                        sh """
                        ssh -o StrictHostKeyChecking=no root@${ECS_IP} 'docker run --rm ${DOCKER_IMAGE} pytest tests/'
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // 构建结束后清理工作区
            cleanWs()
        }
        success {
            // 测试成功后发送通知
            echo 'Tests ran successfully!'
        }
        failure {
            // 构建或测试失败时输出消息
            echo 'Build or tests failed.'
        }
    }
}

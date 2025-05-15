pipeline {
    agent any

    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Check to destroy infrastructure instead of applying')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
         stage('Checkout Code') {
            steps {
                git url: 'https://github.com/ArmanNavodia/GoldenImages.git', branch: 'main'
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan or Destroy') {
            steps {
                dir('terraform') {
                    script {
                        if (params.DESTROY_INFRA) {
                            sh 'terraform destroy -auto-approve'
                        } else {
                            sh 'terraform plan -out=tfplan'
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY_INFRA }
            }
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            script {
                if (params.DESTROY_INFRA) {
                    echo '✅ Resources destroyed.'
                } else {
                    echo '✅ Resources created/updated.'
                }
            }
        }
        failure {
            echo '❌ Something went wrong.'
        }
    }
}

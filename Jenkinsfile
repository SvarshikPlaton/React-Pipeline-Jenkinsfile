pipeline {
    agent { label 'node.js' }
    environment {
        SERVER_CREDENTIALS = 's3-test'
        WEBHOOK_URL = 'DiscordWebHook'
        BUCKET = 'test.khai'
    }
    stages {
        stage('clone') {
            steps {
                sh ("git clone git@github.com:SvarshikPlaton/ReactDeploy.git")
            }
        }
        stage('build') {
            steps {
                sh '''
                cd ReactDeploy
                npm install
                yarn build
                chmod -R 755 ./build/*
                '''
            }
        }
        stage('deploy') {
            steps {
                sh('scp -rp ./ReactDeploy/build/* react-app@172.31.31.67:/var/www/react-application/html')
            }
        }
        stage('upload to s3') {
            steps {
                withAWS(credentials: "${SERVER_CREDENTIALS}", region: 'eu-central-1') {
                    script {
                        println 'Uploading artifacts...'
                        sh '''
                        cd ./ReactDeploy/build/
                        tar -cvzf "build-${BUILD_NUMBER}.tar.gz" ./*
                        '''
                        s3Upload(file: "./ReactDeploy/build/build-${BUILD_NUMBER}.tar.gz", bucket: "${BUCKET}")
                    }
                }
            }
        }
        stage('clear workspace') {
            steps {
                sh('rm -rf ReactDeploy')
            }
        }
    }
    post {
        always {
                discordSend description: "Jenkins pipeline build: ${currentBuild.currentResult}",
                    link: env.BUILD_URL,
                    result: currentBuild.currentResult,
                    title: JOB_NAME,
                    webhookURL: "${WEBHOOK_URL}"
        }
    }
}

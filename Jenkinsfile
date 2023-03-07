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
                script {
                    if (fileExists("ReactDeploy")) {
                        println 'ReactDeploy is already existing'
                        if (fileExists("./ReactDeploy/node_modules") && !(fileExists("./node_modules"))) {
                            sh "cp -r ./ReactDeploy/node_modules ./node_modules"
                        }
                        sh '''
                            cd ReactDeploy
                            git pull
                        '''
                    } else {
                        println 'ReactDeploy is not existing. Cloning...'
                        git url: 'git@github.com:SvarshikPlaton/ReactDeploy.git', force: true
                    }
                }
            }
        }
        stage('build') {
            steps {
                script {
                    if (fileExists("./node_modules")) {
                       sh "cp -r ./node_modules ./ReactDeploy/"
                    } else {
                        sh "npm install --prefix ./ReactDeploy"
                    }
                }
                sh '''
                cd ReactDeploy
                npm run build
                chmod -R 755 ./build/*
                '''
                
            }
        }
        stage('deploy') {
            steps {
                sh '''
                    ssh react-app@172.31.31.67 "rm -rf /var/www/react-application/html/*"
                    scp -rp ./ReactDeploy/build/* react-app@172.31.31.67:/var/www/react-application/html
                '''
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

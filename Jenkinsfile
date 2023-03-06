pipeline {
    agent { label "yarn" }
    environment {
        SERVER_CREDENTIALS = "s3-test"
        WEBHOOK_URL = "https://discord.com/api/webhooks/1076817137320079390/pT9byWIX3_MR1mdqa19a2H2gHAHX7xFtQfpOMluj7VHf7PKt0s4uIIHE0qNcwZHPROe6"
    }
    stages {
        stage('clone') {
            steps {
                sh """
                rm -rf ReactDeploy
                git clone git@github.com:SvarshikPlaton/ReactDeploy.git
                """
            }
        }
        stage("build") {
            steps {
                sh """
                cd ReactDeploy
                npm install
                yarn build
                chmod -R 755 ./build/*
                """
            }
        }
        stage("deploy") {
            steps {
                sh("scp -rp ./ReactDeploy/build/* react-app@172.31.31.67:/var/www/react-application/html")
            }
        }
        stage("upload to s3") {
            steps {
                withAWS(credentials: "${SERVER_CREDENTIALS}", region: 'eu-central-1') { 
                    script {
                        println "Uploading artifacts..."
                        s3Upload(file: "./ReactDeploy/build", bucket: 'test.khai')
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
}

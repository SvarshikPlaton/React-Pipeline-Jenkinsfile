pipeline {
    agent { label 'React' }

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
                npm run build
                cd build
                chmod -R 755 ./*
                """
            }
        }

        stage("deploy") {
            steps {
                sh """
                scp -rp ./ReactDeploy/build/* react-app@172.31.17.100:/home/react-app/react-production
                """
            }
        }
    }   
}

pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64', 'all'], description: 'Pick ARCH')
    }
    environment {
        REPO = 'https://github.com/telest0/kbot'
        BRANCH = 'main'
    }

    stages {
        stage('clone') {
            steps {
                echo 'Clone Repository'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }

        stage('test') {
            steps {
                echo 'Testing started'
                sh "make test"
            }
        }

        stage('build') {
            steps {
                echo "Building binary started"
                sh "make build -e OS=${params.OS} -e ARCH=${params.ARCH}"
            }
        }

        stage('image') {
            steps {
                echo "Building image started"
                sh "make image -e OS=${params.OS} -e ARCH=${params.ARCH}"
            }
        }

        stage('login to GHCR') {
             environment {
                GITHUB_TOKEN = credentials('github')
            }
            steps {
                sh "echo $GITHUB_TOKEN_PSW | docker login ghcr.io -u $GITHUB_TOKEN_USR --password-stdin"
            }
        }
        
        stage('push image') {
            steps {
              sh "make push -e OS=${params.OS} -e ARCH=${params.ARCH}"
            }
        } 
    }
}
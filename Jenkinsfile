pipeline {
  agent { label 'jenkins-dynamic-slave' }
  stages {
    stage('Test') {
      when {
        expression { env.BRANCH_NAME != 'main' }
      }
      steps {
        script {
          sh('''
              ls -la /home/$USER/.kube/
              ls -la /.kube/
              ls -la
          ''')
//           sh('''
//               docker build -t terraform-k8s-app-test -f Dockerfile-test .
//               docker run -v $HOME/.kube/config:/home/tester/.kube/config:ro --net=host  terraform-k8s-app-test
//               docker rm terraform-k8s-app-test
//           ''')
        }
      }
    }

    stage('Tag') {
      when {
        expression { env.BRANCH_NAME == 'main' }
      }
      steps {
        script {
          env.VERSION = readFile(file: '.version')
        }
        withCredentials([gitUsernamePassword(credentialsId: 'sf-reference-arch-devops',
           gitToolName: 'git-tool')]) {
           sh('''
                git config user.name 'sfdevops'
                git config user.email 'sfdevops@sourcefuse'
                git tag -a \$VERSION -m \$VERSION
                git push origin \$VERSION
            ''')
        }
      }
    }
  }
}

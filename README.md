# AWS Cloud9 Docker image
Docker image for AWS cloud9 prepared environment with preinstalled golang and activated SSH daemon

### Examples
```docker run -d -p 20022:22 -e SSH_PUBLIC_KEY=<AWS Cloud9 environment SSH pulic key> serjs/aws-cloud9-docker```
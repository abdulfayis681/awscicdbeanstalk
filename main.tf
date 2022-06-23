resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = var.elasticapp
}
 
# Create elastic beanstalk Environment
 
resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = var.beanstalkappenv
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier
 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "True"
  }
 
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
 
}

#codebuild
resource "aws_codebuild_source_credential" "githubcredential" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "githubtoken>>>>"
}


resource "aws_codebuild_project" "codebuild" {
  name          = "codebuild"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = "arn:aws:iam::815421850354:role/codebuil-role1"

  

  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    
  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/abdulfayis681/aws-elastic-beanstalk-express-js-sample.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "main"
}
resource "aws_codebuild_webhook" "webhook" {
  project_name = aws_codebuild_project.codebuild.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}

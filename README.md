# Terraform setup Aws
<small><b><i>Terraform</i></b> is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.</small> Configuration files in this directory creates to setup ec2 instances, lambda function, cloudwatch event, s3, dynamodb, and route53(DNS) on Amazon Web Service as a provider. 

## Prerequisites
<ul>
  <li>Should have <b>AWS</b> <i>secret key</i> and <i>access key</i> on local machine (home directory)</li>
</ul>

## Usage 
<ul>
  <li>
    Clone repository to your directory 
    <code>$ git clone https://github.com/iv1310/Terraform_Aws.git && cd Terraform_Aws</code>
  </li>
  <li>
    After placing it into your work directory, run
    <code>$ terraform init</code>
    to initialize it.
  </li>
  <li>
    Then, run 
    <code>$ terraform plan</code>
    used to create an execution plan.
  </li>
  <li>
    And then, run 
    <code>$ terraform apply</code>
  </li>
  <li>
    You can inspect the current state using
    <code>$ terraform show</code>
  </li>
</ul>


# Steps to execute IAC scripts and ansible playbooks
* Checkout the repository to your local and switch to `terraform` folder
* Verify whether remote backend is correctly configured in `backend.tf` file.
* Provide required parameters to configure access  to aws via aws configure command.
* Apply `terraform init` command to download required terraform modules into local.
* Apply `terraform fmt` to fix linting issues.
* Apply `terraform validate` to verify whether there is any logical errors in the written code.
* Apply `terraform plan` to pre-check the blue-print of the AWS resources that will generated.
* Once you have confirmed above output, apply `terraform apply` to deploy required changes into AWS.
* Terraform will provision required infrastructure, executes ansible playbooks using `remote-exec` and `local-exec` provisioners.
* You can use `terraform destroy` to deprovision all the changes that you done above.
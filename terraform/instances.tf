#GET Linux AMI ID using SSM Parameter endpoint in us-east-a
data "aws_ssm_parameter" "UbuntuAmi" {
  provider = aws.region-devopstest
  name     = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

#data "template_file" "app" {
#  template = file("templates/django_app.json.tpl")
#
#  vars = {
#    docker_image_url_django = var.docker_image_url_django
#    region                  = var.region
#    db_name                = var.mysql_db_name
#    db_username            = var.mysql_username
#    db_password            = var.mysql_password
#    db_hostname            = var.mysql.hostname
#  }
#}

#Create key-pair for logging into ec2-instance in us-east-1a
resource "aws_key_pair" "app1_key" {
  provider   = aws.region-devopstest
  key_name   = "app1_key"
  public_key = file(var.ssh_pubkey_file)
}

#Create key-pair for logging into ec2-instance in us-east-1b
resource "aws_key_pair" "app2_key" {
  provider   = aws.region-devopstest
  key_name   = "app2_key"
  public_key = file(var.ssh_pubkey_file)
}

#Create and bootstrap EC2 in us-east-1a
resource "aws_instance" "ec2_app1" {
  provider                    = aws.region-devopstest
  ami                         = data.aws_ssm_parameter.UbuntuAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.app1_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app1_sg_devopstest.id]
  subnet_id                   = aws_subnet.subnet_1_devopstest.id
  tags = {
    Name = "django_app1_tf"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install curl python3 python3-pip -y", "echo Done!"]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_pvtkey_file)
    }
  }

  provisioner "local-exec" {
    #command = <<EOF
    #aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-devopstest} --instance-ids ${self.id}
    #ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/django-app-server01.yml
    #EOF
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.ssh_pvtkey_file} -e 'pub_key=${var.ssh_pubkey_file}' ansible_templates/django-app-server01.yml"
  }
}

#Create and bootstrap EC2 in us-east-1b
resource "aws_instance" "ec2_app2" {
  provider                    = aws.region-devopstest
  ami                         = data.aws_ssm_parameter.UbuntuAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.app2_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app2_sg_devopstest.id]
  subnet_id                   = aws_subnet.subnet_2_devopstest.id
  tags = {
    Name = "django_app2_tf"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install curl python3 python3-pip -y", "echo Done!"]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_pvtkey_file)
    }
  }

  provisioner "local-exec" {
    #command = <<EOF
    #aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-devopstest} --instance-ids ${self.id}
    #ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/django-app-server02.yml
    #EOF
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.ssh_pvtkey_file} -e 'pub_key=${var.ssh_pubkey_file}' ansible_templates/django-app-server02.yml"
  }

  provisioner "local-exec" {
    command = <<EOF
ANSIBLE_HOST_KEY_CHECKING=False ansible all -i '${self.public_ip},' -m shell -a "sudo docker run -d -t -i -e DATABASE_HOST=${aws_instance.ec2_app1.private_ip} -e DATABASE_NAME=devopstest -e DATABASE_PORT=3306 -e DATABASE_USER=devopstest -e DATABASE_PWD=devopstest -p 8000:8000 --name web coolboynova/devopstest:latest" -u ubuntu --private-key ${var.ssh_pvtkey_file} -e 'pub_key=${var.ssh_pubkey_file}'
EOF
  }
}

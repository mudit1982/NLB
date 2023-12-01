#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-2"
}

variable "account_id" {
  type        = number
  description = "AWS Account Id"
}

variable "VPCID" {
  type        = string
  description = "The ID of the VPC that the instance security group belongs to"
}

#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user"
  type        = string
  sensitive   = true
  default     = ""
}
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "subnet_cidr_public" {
  description = "cidr blocks for the public subnets"
  default     = ["10.20.20.0/28", "10.20.20.16/28", "10.20.20.32/28"]
  type        = list(any)
}

variable "availability_zone" {
  description = "availability zones for the public subnets"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  type        = list(any)
}

variable "instance" {
  description = "EC2 instances to be added as target group"
  default     = [""]
  type        = list(any)
}

variable "port" {
  description = "List of Ports for the Listners"
  default     = [""]
  type        = list(any)
}

variable "protocol" {
  description = "List of Protocols for the Listeners"
  default     = [""]
  type        = list(any)
}


variable "SUBNET_ID" {
  description = "Subnets of the EC2 Instances"
  default     = [""]
  type        = list(any)
}


variable "security_groups" {
  description = "New Security Group to be provisioned for ALB"
  type        = string
  default     = "sg1"
}

variable "existing_security_group_ids" {
  description = "A list of existing Security Group IDs to associate with the Load Balancer."
  type        = list(string)
  default     = [""]
}

variable "secgroupdescription" {
  description = "Description of the Security Group"
  type        = string
  default     = "ELB Security Group"
}

variable "awsprops" {
  type = map(any)
  default = {
    region       = "us-east-2"
    vpc          = "vpc-033eda327b526ea8b"
    ami          = "ami-00744e52917f35c39"
    itype        = "t2.micro"
    subnet       = "subnet-0da6c40068a31c6b8"
    publicip     = true
    keyname      = "myseckey"
    secgroupname = "IAC-Sec-Group"
  }
}

variable "s3_bucket_for_logs" {
  type    = string
  default = ""
}


variable "Environment" {
  type    = string
  default = "Dev"

validation {
   condition     = contains(["Dev", "Test" ,"Sandbox", "Staging", "Production"], var.Environment)
   error_message = "Please provide a valid value for variable Envrionment. Allowed values are Dev, Test, Sandbox, Staging and Production"
 }
}

variable "ApplicationName" {
  type    = string
  default = ""

}

variable "ApplicationFunctionality" {
  type    = string
  default = ""

}

variable "ApplicationOwner" {
  description = "Owner of the Application"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@hotmail.com", "abc@gmail.com"], var.ApplicationOwner)
   error_message = "Please provide a valid Application Owner"
 }
}


variable "ApplicationTeam" {
  description = "Owner of the Application"
  type        = string
  default     = ""

  validation {
   condition     = contains(["Team1","Team2"], var.ApplicationTeam)
   error_message = "Please provide a valid Application Team"
 }
}



variable "BusinessTower" {
  description = "Business Tower"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@gmail.com","xyz@gmail.com"], var.BusinessTower)
   error_message = "Please provide a valid BusinessTower"
 }
}



variable "BusinessOwner" {
  description = "Business Owner"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@gmail.com","xyz@gmail.com"], var.BusinessOwner)
   error_message = "Please provide a valid BusinessOwner"
 }
}


variable "ServiceCriticality" {
  description = "Business Criticality of the Service"
  type        = string
  default     = ""

  validation {
   condition     = contains(["High","Low","Medium"], var.ServiceCriticality)
   error_message = "Please provide a valid Service Criticality, Valid values are High, Low and Medium"
 }
}



variable "alb_tags" {
    default = {
    }
    description = "Tags for WIndows Ec2 instances"
    type        = map(string)
  }


  variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [

  ]
}


variable "preserve_client_ip" {
  type    = bool
  default = true

}

variable "internal_load_balancer" {
  type    = bool
  default = true
}




variable "target_group" {
  type = map(string)
  default ={
    healthy_threshold  =  3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
  
}


   
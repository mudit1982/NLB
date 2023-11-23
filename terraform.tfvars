VPCID="vpc-0419802ed12eec58a"
#EC2 instances to be added as target group
instance=["i-06450e21d58084255","i-0ea77aa338a3ed31b"]
SUBNET_ID=["subnet-0b86a94123ccf1094","subnet-04eff055558594bd7"]
existing_security_group_ids=["sg-0fa3f7060ad66d3be"]
port = ["80","443"]
protocol=["TCP","TCP"]
stick_session=true

alb_tags = {
      TicketReference            = "CHG0050760"
      DNSEntry                   = "csdasd"
      DesignDocumentLink         = "acbv"
}


##Tags to be passed as variables. These would be appended to the pre defined tags in variables.tf
Environment="Dev"
ApplicationFunctionality = "Test"
ApplicationName="Test"
ApplicationOwner="abc@hotmail.com"
ApplicationTeam="Team1"
BusinessOwner="abc@gmail.com"
BusinessTower="abc@gmail.com"
ServiceCriticality="Medium"



ingress_rules =[
 
{
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_block  = "192.168.161.215/32"
      description = "ELB"
    },

    {
      from_port   = "8080"
      to_port     = "8080"
      protocol    = "tcp"
      cidr_block  = "192.168.161.215/32"
      description = "ELB Port 8080"
    },
{
      from_port   = "1234"
      to_port     = "1234"
      protocol    = "tcp"
      cidr_block  = "192.168.161.215/32"
      description = "ELB Port 1234"
    }
]



target_group = {
    healthy_threshold   =  3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = 3
    unhealthy_threshold = 2
    }



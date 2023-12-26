VPCID="vpc-0419802ed12eec58a"
account_id=215691912540
#EC2 instances to be added as target group
instance=["i-0ec4d4521d56ade9b","i-0859a07abf9002a20"]
SUBNET_ID=["subnet-0b86a94123ccf1094","subnet-04eff055558594bd7"]
# existing_security_group_ids=["sg-0fa3f7060ad66d3be"]
port = ["80","443"]
protocol=["TCP","TCP"]  
preserve_client_ip=true
cross_zone_load_balancing=true
s3_bucket_for_logs="egalbdemo2023"  
#True for Internal Load Balancer and False for External Load Balancer
internal_load_balancer=false
certificate_id="edd0bad0-21c4-410a-907d-32efac02f8b8"
stick_session=true


nlb_tags = {
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


target_group = {
    healthy_threshold   =  3
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = 3
    unhealthy_threshold = 2
    }



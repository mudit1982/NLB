locals {
  count_subnet_id = length(var.SUBNET_ID)
 
  }

# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = var.s3_bucket_for_logs

# policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowELBRootAccount",
#             "Effect": "Allow",
#             "Principal": "arn:aws:iam::${var.account_id}:root",
#             "Action": "s3:PutObject",
#             "Resource": "arn:aws:s3:::${var.s3_bucket_for_logs}/test-nlb/*"
#         },
#         {
#             "Sid": "AWSLogDeliveryWrite",
#             "Effect": "Allow",
#             "Principal": "arn:aws:iam::${var.account_id}:root",
#             "Action": "s3:PutObject",
#             "Resource": "arn:aws:s3:::${var.s3_bucket_for_logs}/test-nlb/*",
#             "Condition": {
#                 "StringEquals": {
#                     "s3:x-amz-acl": "bucket-owner-full-control"
#                 }
#             }
#         },
#         {
#             "Sid": "AWSLogDeliveryAclCheck",
#             "Effect": "Allow",
#             "Principal": "arn:aws:iam::${var.account_id}:root",
#             "Action": "s3:GetBucketAcl",
#             "Resource": "arn:aws:s3:::${var.s3_bucket_for_logs}/test-nlb/*"
#         },
#         {
#             "Sid": "AllowALBAccess",
#             "Effect": "Allow",
#             "Principal": "arn:aws:iam::${var.account_id}:root",
#             "Action": "s3:PutObject",
#             "Resource": "arn:aws:s3:::${var.s3_bucket_for_logs}/test-nlb/**"
#         }
#     ]
# }
# EOF
# }

resource "aws_lb_target_group" "network-lb-target-group" {
  name     = "network-front"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.VPCID
  preserve_client_ip = false

  health_check {
    enabled             = true
    healthy_threshold   = lookup ( var.target_group , "healthy_threshold")
    interval            = lookup ( var.target_group , "interval") 
    # matcher             = lookup ( var.target_group , "matcher")
    port                = lookup ( var.target_group , "port")
    protocol            = lookup ( var.target_group , "protocol")
    timeout             = lookup  ( var.target_group , "timeout")
    unhealthy_threshold = lookup ( var.target_group , "unhealthy_threshold")
    
  }

}

resource "aws_lb_target_group_attachment" "attach-app1" {
  count            = length(var.instance)
  target_group_arn = aws_lb_target_group.network-lb-target-group.arn
  target_id        = element(var.instance[*], count.index)
  port             = 80
}


resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.network-lb.arn
  count = length(var.port)
  port    = var.port[count.index]
  protocol  = var.protocol[count.index]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network-lb-target-group.arn
  }
}

# module "aws_security_group" {
#   source      = "./modules/security_group"
#   # sg_count = length(var.security_groups)
#   name = var.security_groups
#   description = var.secgroupdescription
#   vpc_id      = var.VPCID

# } 


# resource "aws_security_group_rule" "ingress_rules" {

#   count = length(var.ingress_rules)

#   type              = "ingress"
#   from_port         = var.ingress_rules[count.index].from_port
#   to_port           = var.ingress_rules[count.index].to_port
#   protocol          = var.ingress_rules[count.index].protocol
#   cidr_blocks       = [var.ingress_rules[count.index].cidr_block]
#   description       = var.ingress_rules[count.index].description
#   # security_group_id = module.aws_security_group.id[count.index]
#   security_group_id = module.aws_security_group.id
# }



resource "aws_lb" "network-lb" {
  name               = "EG-NLB-TEST"
  internal           = true
  load_balancer_type = "network"
  # security_groups    = [module.aws_security_group.id]
  # security_groups    =  concat([module.aws_security_group.id] , var.existing_security_group_ids[*])
  # security_groups     = [module.security_group.id]
  subnets            = [for subnet in var.SUBNET_ID : subnet]
  enable_deletion_protection = true

  access_logs { 
    bucket  = var.s3_bucket_for_logs
    prefix  = "test-nlb"
    enabled = true
  }


  tags = merge(tomap(var.alb_tags),{ApplicationFunctionality = var.ApplicationFunctionality, 
      ApplicationOwner = var.ApplicationOwner, 
      ApplicationTeam = var.ApplicationTeam, 
      BusinessOwner = var.BusinessOwner,
      BusinessTower = var.BusinessTower,
      ServiceCriticality = var.ServiceCriticality,
      VPC-id = var.VPCID})
  }

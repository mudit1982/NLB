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
  preserve_client_ip = var.preserve_client_ip

  health_check {
    enabled             = true
    healthy_threshold   = lookup ( var.target_group , "healthy_threshold")
    interval            = lookup ( var.target_group , "interval") 
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


resource "aws_alb_listener" "tls" {
  load_balancer_arn = aws_lb.network-lb.arn
  port              = 447
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn = "arn:aws:acm:${var.region}:${var.account_id}:certificate/${var.certificate_id}"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network-lb-target-group.arn
    
  }
}



resource "aws_lb" "network-lb" {
  name               = "EG-NLB-TEST"
  internal           = var.internal_load_balancer
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


  tags = merge(tomap(var.nlb_tags),{ApplicationFunctionality = var.ApplicationFunctionality, 
      ApplicationOwner = var.ApplicationOwner, 
      ApplicationTeam = var.ApplicationTeam, 
      BusinessOwner = var.BusinessOwner,
      BusinessTower = var.BusinessTower,
      ServiceCriticality = var.ServiceCriticality,
      VPC-id = var.VPCID})
  }




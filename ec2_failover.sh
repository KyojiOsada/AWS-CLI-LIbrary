#!/bin/bash
# ec2_failover.sh

# LAN VIP
VIP=xxx.xxx.xxx.xxx
# WAN VIP
ALLOCATION_ID=eipalloc-xxxxxxxxx
# Instance 1 eth0 IF
INTERFACE_ID_1=eni-xxxxxxxx
# Instance 2 eth0 IF
INTERFACE_ID_2=eni-xxxxxxxx
# Instance ID
INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
# Auth
export AWS_DEFAULT_REGION=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | rev | cut -c 2- | rev`

# LAN VIP Unassitnment
aws ec2 unassign-private-ip-addresses --private-ip-addresses $VIP --network-interface-id $INTERFACE_ID_1

# LAN VIP Assignment
aws ec2 assign-private-ip-addresses --private-ip-addresses $VIP --network-interface-id $INTERFACE_ID_2 --allow-reassignment

# WAN VIP Asoociation
aws ec2 associate-address --allocation-id $ALLOCATION_ID --network-interface-id $INTERFACE_ID_2 --private-ip-address $VIP

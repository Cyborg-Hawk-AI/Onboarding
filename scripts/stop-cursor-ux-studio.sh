#!/bin/bash
aws ec2 stop-instances --instance-ids i-0ae15809f5f346643
echo "Ensure Current State is listed as "stopping" above"

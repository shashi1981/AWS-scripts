#**************************************************************************************
# Author     purpose
#=======     ==========================
# sdepa      purpose of this script is to achieve the below
#            1. List all the EC2 instances in Breeding Sandbox account
#            2. Based on the Input, START/STOP instance
#            3. Provide the instance-id as input
#**************************************************************************************

#!/usr/bin/python3
#show instances
profile=$1
echo "Profile is : $profile"
echo -en "              ******** SCRIPT OWNERS: BREEDING ENGG TEAM********                 \n"
echo "                                                                                              "
# List of all instances in Table Format
echo -en "******** LIST OF RUNNING IMSTANCES IN BREEDING SANDBOX ACCOUNT IN TABLE FORMAT:******** \n"
echo "                                                                                              "
echo "$(aws ec2 describe-instances --profile $profile --query 'Reservations[].Instances[].[InstanceId,InstanceType,Placement.AvailabilityZone, State.Name, Platform,State.Code,PublicDnsName]' --region us-east-1 --output table)"


printf 'Please choose your Action in UPPERCASE(STOP/START/STATUS) :'
read stat

case $stat in
      STOP)
           echo -en "******** LIST OF RUNNING IMSTANCES IN BREEDING SANDBOX ACCOUNT IN TABLE FORMAT:******** \n"
	   echo "                                                                                              "
	   echo "$(aws ec2 describe-instances --profile $profile --query 'Reservations[].Instances[].[InstanceId,InstanceType,Placement.AvailabilityZone, State.Name, Platform,State.Code,PublicDnsName]' --output table)"
	   echo "                                                                                              "
	   printf 'Please choose your Instance to STOP :'
	   read stop_inst
	   echo "                                                                                              "
	   echo "STOPING THE INSTANCE($stop_inst) BASED ON INSTANCE-ID IN BREEDING SANDBOX ACCOUNT"
	   aws ec2 stop-instances --instance-ids $stop_inst --profile $profile
	   ;;

      START)
           echo -en "******** LIST OF RUNNING IMSTANCES IN BREEDING SANDBOX ACCOUNT IN TABLE FORMAT:******** \n"
	   echo "                                                                                              "
           echo "$(aws ec2 describe-instances --profile $profile --query 'Reservations[].Instances[].[InstanceId,InstanceType,Placement.AvailabilityZone, State.Name, Platform,State.Code,PublicDnsName]' --output table)"
	   printf 'Please choose your Instance to START :'
	   echo "                                                                                              "
	   read start_inst
	   echo "                                                                                              "
	   echo "STARTING THE INSTANCE($start_inst) BASED ON INSTANCE-ID IN BREEDING SANDBOX ACCOUNT"
	   aws ec2 start-instances --instance-ids $start_inst --profile $profile
           ;;

      STATUS)
           echo -en "******** LIST OF RUNNING IMSTANCES IN BREEDING SANDBOX ACCOUNT IN TABLE FORMAT:******** \n"
	   echo "                                                                                              "
	   echo "$(aws ec2 describe-instances --profile $profile --query 'Reservations[].Instances[].[InstanceId,InstanceType,Placement.AvailabilityZone, State.Name, Platform,State.Code,PublicDnsName]' --region us-east-1 --output table)"
	   printf 'Please choose your Instance :'
	   echo "                                                                                              "
	   read status_inst
	   echo "                                                                                              "
	   echo "STATUS OF THE INSTANCE($status_inst) BASED ON INSTANCE-ID IN BREEDING SANDBOX ACCOUNT"
	   aws ec2 describe-instances --profile $profile --instance-ids $status_inst --query 'Reservations[].Instances[].[InstanceId,InstanceType,Placement.AvailabilityZone, State.Name, Platform,State.Code,PublicDnsName]' --region us-east-1 --output table
	   ;;
esac

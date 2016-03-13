#!/bin/bash
#
# Simple script to run the deployment scripts within an AMI.
# This is designed EXPLICITLY for a single-node deployment
#
# NOTE: Optional $1 argument will support downloading a trial license
# for use during installation.   
#
# FUTURE DESIGN :
#	This is the right place to "patch" the AMI with updated scripts/etc.
#	The Azure Template process can be used to upload files into the 
#	same directory from which this script is executed ... so it
#	could be modified to check for the presense of "patches" and move
#	them into place within /home/mapr before starting the deployment.
#

if [ -n "$1" ] ; then
	LIC_TYPE=$1

	if [ ${LIC_TYPE} = "M5"  -o  ${LIC_TYPE} = "M7" ] ; then
		curl -o /tmp/lic.txt http://msazure:MyCl0ud.ms@stage.mapr.com/license/LatestDemoLicense-${LIC_TYPE}.txt
		if [ $? -eq 0  -a  -d /home/mapr/licenses ] ; then
			echo ${LIC_TYPE} > /tmp/maprlicensetype
			chmod a+rw /tmp/lic.txt
			mv /tmp/lic.txt  /home/mapr/licenses/MaprMarketplace${LIC_TYPE}License.txt
		fi
	fi
fi

# Initialize data used by deploy-mapr-ami.sh to allow for M5/M7 even on sandbox
THIS_HOST=`hostname`
echo "$THIS_HOST MAPRNODE0" > /tmp/maprhosts
echo ${THIS_HOST%node*} > /tmp/mkclustername

# And now do the work !
/home/mapr/sbin/deploy-mapr-ami.sh
[ $? -eq 0 ] && /home/mapr/sbin/deploy-mapr-data-services.sh hiveserver drill spark


# Last, but not least, install a Community Edition license on top of
# trial license so license expiration does not confuse things.
if [ -n "${LIC_TYPE:-}" ] ; then
	M3_LIC_FILE=/home/mapr/licenses/MaprMarketplaceM3License.txt
	if [ -f ${M3_LIC_FILE} ] ; then
		maprcli license add -license $M3_LIC_FILE -is_file true
	fi
fi

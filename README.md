# Advanced Linux Template : Deploy a MapR Sandbox in Azure

<a href="https://azuredeploy.net/" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


<h1>
BETA RELEASE
</h1>

This advanced template deploys a single copy of the MapR VM Image
for use in simple experimentation of the MapR Converged Data Platform.
Users can select which instance types to use; storage for each node is 
currently defined in the template itself (scaled to 2 1-TB volumes 
per vcore for each instance type).

The Control System interface to the cluster will be available at
    https://[sandbox-node]:8443

The system admin account will have login access, as well as the 
MapR Software Admin account (user "mapr").   The password for the 
mapr user is automatically set to "MapR-<hostname>" (though users 
can log on to the host and change that should they desire).

<h2>
Command Line Usage
</h2>

The template deployment is supported via the Azure Command Line 
utility (available from 
http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/#configure ).

After installing that utility and authenticating to the Azure
environment, you can take the following steps to deploy a cluster
from the command line :
<ol>
<li>
Clone the default parameters file (azuredeploy-parameters.json) 
</li>
<li>
Update the new parameter file, ap.json, with your desired settings
for clusterName and adminPassword
</li>
<li>
Launch a resource group and deploy the MapR software
<p>
azure group create <MyGroup> "West US" -f azuredeploy.json -e ap.json -d Test1
</p
</li>
</ol>

<h2>
Resource Naming Conventions
</h2>

The template creates several resources that require unique names within
the Azure infrastructure framework (a new storage account, public IP 
address, etc).   The resource names are seeded with the user-specified
cluster name for easy identification among other Azure resources.


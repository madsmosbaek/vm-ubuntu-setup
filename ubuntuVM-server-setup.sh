#!/bin/bash

numservers=2
countservers=1

while [ $countservers -le $numservers ]
do
    #Create and Register a Virtual Machine
    sh VBoxManage createvm --name ubuntu-server$countservers --ostype Ubuntu_64 --register

    #Setup the Virtual Machine Storage Medium
    sh VBoxManage createmedium --filename ./ubuntu-server$countservers/ubuntu-server$countservers.vdi --size 10240

    #Add and Attach SATA and IDE Storage Controllers
    sh VBoxManage storagectl ubuntu-server$countservers --name SATA --add SATA --controller IntelAhci
    sh VBoxManage storageattach ubuntu-server$countservers --storagectl SATA --port 0 --device 0 --type hdd --medium ./ubuntu-server$countservers/ubuntu-server$countservers.vdi
    sh VBoxManage storagectl ubuntu-server$countservers --name IDE --add ide
    sh VBoxManage storageattach ubuntu-server$countservers --storagectl IDE --port 0 --device 0 --type dvddrive --medium ./ubuntu-18.04.3-live-server-amd64.iso
    
    #Set the VM RAM and Virtual graphics card RAM size
    sh VBoxManage modifyvm ubuntu-server$countservers --memory 1024 --vram 16

    #Enable IO APIC
    sh VBoxManage modifyvm ubuntu-server$countservers --ioapic on

    #Define the boot order for the virtual machine
    sh VBoxManage modifyvm ubuntu-server$countservers --boot1 dvd --boot2 disk --boot3 none --boot4 none

    #Define the number of virtual CPUs for the VM
    sh VBoxManage modifyvm ubuntu-server$countservers --cpus 2

    #Disable Audio for the VM
    sh VBoxManage modifyvm ubuntu-server$countservers --audio none

    #Define the Networking settings for the VM
    sh VBoxManage modifyvm ubuntu-server$countservers --nic1 nat

    #Virtual Machine Unattended Installation
    sh VBoxManage unattended install ubuntu-server$countservers --user=<user> --password=<password> --country=DK --time-zone=CEST --hostname=server01.example.com --iso=./ubuntu-18.04.3-live-server-amd64.iso --start-vm=gui

    ((count++))
done

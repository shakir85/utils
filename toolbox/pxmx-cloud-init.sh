#!/bin/bash
# Reference - Debian cloud images: https://cloud.debian.org/images/cloud/
# 0. Download a distro
# Debian 11
# wget https://cloud.debian.org/images/cloud/bullseye/20220711-1073/debian-11-generic-amd64-20220711-1073.qcow2

# --------------------------------------------------
# Help
# --------------------------------------------------
usage() {
    cat <<EOF
Usage: [command] [args]

Arguments:

  Positional Arguments:
    1 VM_ID        - Unique integer.
    2 MEMORY       - Integer, memory in MB.
    3 VM_NAME      - String, initial VM name, and final template name.
    4 IMG_PATH     - Absolute path to a cloud image.
    5 STORAGE_POOL - String, storage on Proxmox node.

  --

Example:
# chmod +x pxmx-cloud-init.sh

# ./pxmx-cloud-init.sh \
     9000 \
     2048 \
     ubuntu-20.04-cloud \
     /root/focal-server-cloudimg-amd64-disk-kvm.img \
     local-lvm

  --
  Cloud image templates:
    Centos 7     - https://cloud.centos.org/centos/7/images/CentOS-7-ppc64le-GenericCloud-2211.qcow2
    Debian 11    - https://cloud.debian.org/images/cloud/bullseye/20220711-1073/debian-11-generic-amd64-20220711-1073.qcow2
    Ubuntu 20.04 - https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

EOF
}

# --------------------------------------------------
# Variables & helpers
# --------------------------------------------------
VM_ID=$1
MEMORY=$2
VM_NAME=$3
IMG_PATH=$4
STORAGE_POOL=$5
# Bash expansion to override from cmd line if needed. Otherwise, default values = 'false'
: VERT_GUEST_AGENT=false
: VERT_PASSWORD_AUTH=false

# -- Set terminal colors
tput() {
  command -v tput >/dev/null && command tput "$@"
}
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset_color=$(tput sgr0)

# -- Echoing colored status
error(){
    echo "${red}==> Error:${reset_color} $* "
}
info(){
    echo "${green}==> Info:${reset_color} $* " >>/dev/stdout
}
warning(){
    echo "${yellow}Warning:${reset_color} $* " >>/dev/stdout
}

# --------------------------------------------------
# Main
# --------------------------------------------------
main() {

    set -e

    if [ "$EUID" -ne 0 ] ; then
        error "Please run as root"
        exit
    fi

    if [[ $# -ne 5 ]] ; then
        echo ""
        error "This script requires 5 positional arguments, see 'Usage'."
        echo ""
        usage
        exit 0
    fi

    info "****************** Proxmox cloud-image builder ******************"
    cd "$HOME"

    info "Install dependencies..."
    apt-get -qq install libguestfs-tools

    info "Start building..."
    build

    if build ; then
        info "Build succeeded!"
    else
        error "Build failed!"
    fi

    custom

    if custom ; then
        info "Custom settings enabled."
    else
        error "Custom settings failed!"
    fi
}

# --------------------------------------------------
# Build template
# --------------------------------------------------
build() {
    # Create Proxmox VM image from Ubuntu Cloud Image.
    info "Creat initial virtual machine..."
    qm create "$VM_ID" --memory "$MEMORY" --name "$VM_NAME" --net0 virtio,bridge=vmbr0

    # info "Import cloud template to vm disk and upload to storage pool..."
    # qm importdisk "$VM_ID" "$IMG_PATH" "$STORAGE_POOL"

    # info "Add SCSI hardware and attach to vm disk..."
    # qm set "$VM_ID" --scsihw virtio-scsi-pci --scsi0 "$STORAGE_POOL":vm-"$VM_ID"-disk-0

    qm set 5555 --scsi0 $STORAGE_POOL:0,import-from="/root/$IMG_PATH"

    info "Enable QUME guest agent..."
    qm set "$VM_ID" --agent enabled=1,fstrim_cloned_disks=1

    info "Link vm ID=$VM_ID to vm Name=$VM_NAME"
    qm set "$VM_ID" --name "$VM_NAME"

    # This attaches a cloud-init tab in the UI to add user, dns, ssh keys, ...etc to the template.
    # fyi: cdrom is an alias for ide2
    info "Create virtual CD-ROM and attach cloud-init drive..."
    qm set "$VM_ID" --ide2 "$STORAGE_POOL":cloudinit

    info "Make cloud-image bootable..."
    qm set "$VM_ID" --boot c --bootdisk scsi0

    info "Enable serial console..."
    qm set "$VM_ID" --serial0 socket --vga serial0
}


# --------------------------------------------------
# Customizations [Optional]
# --------------------------------------------------
custom() {

    info "Enable cusom VM settings..."

    # Install qemu-guest-agent for the image
    if [ "$VERT_GUEST_AGENT" = true ] ; then

        virt-customize -a "$IMG_PATH" --install qemu-guest-agent
    fi

    # Enable password authentication in the template
    if [ "$VERT_PASSWORD_AUTH" = true ] ; then
        warning "Enalbing SSH simple auth in plain text"
        virt-customize -a "$IMG_PATH" --run-command "sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config"
    fi
}

main "$@"

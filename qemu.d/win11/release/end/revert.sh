# debugging
set -x

# load variables in kvm.conf
source "/etc/libvirt/hooks/kvm.conf"

# unload vfio-pci
modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

# bind GPU
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU_USB
virsh nodedev-reattach $VIRSH_GPU_SERIAL

# Scheduler-driven CPU frequency selection
cpupower frequency-set -g schedutil

# bind VTConsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# revert ignore_msrs
#echo N > /sys/module/kvm/parameters/ignore_msrs

# bind EFI-framebuffer
#echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# load AMD
modprobe amdgpu
#modprobe gpu_sched
#modprobe drm_kms_helper
#modprobe drm_ttm_helper
#modprobe ttm
#modprobe igb
#modprobe snd_hda_intel
#modprobe xhci_hcd
#modprobe i2c_algo_bit

# restart display manager
systemctl start ly.service

# stop sshd
systemctl stop sshd

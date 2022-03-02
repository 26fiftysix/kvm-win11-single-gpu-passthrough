# debugging
set -x

# load variables in kvm.conf
source "/etc/libvirt/hooks/kvm.conf"

# exit i3
#i3-msg exit

# stop display manager
systemctl stop ly.service

# start sshd
systemctl start sshd

# kill pulseaudio
pulse_pid=$(pgrep -u fifty pulseaudio)
kill $pulseaudio_pid

# kill pipewire
pipewire_pid=$(pgrep -u fifty pipewire)
kill $pipewire_pid

# Run the CPU at the maximum frequency
cpupower frequency-set -g performance

# unbind VTConsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# ignore msrs
#echo 1 > /sys/module/kvm/parameters/ignore_msrs

# unbind EFI-framebuffer
#echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# avoid race condition
sleep 5 

# unbind GPU
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_GPU_USB
virsh nodedev-detach $VIRSH_GPU_SERIAL

# unload AMD
modprobe -r amdgpu

# load vfio
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

#!/bin/bash

SRC=/mnt/<todo_mount_dir>
DEST=/mnt/<todo_mount_dir>

mv $DEST/<todo_vm_name>-clone.qcow2 $DEST/<todo_vm_name>-clone.qcow2.old

virsh undefine <todo_vm_name>-clone
virsh dumpxml <todo_vm_name> > $DEST/<todo_vm_name>.xml
virsh shutdown <todo_vm_name>
sleep 60
virt-clone --original <todo_vm_name> --name <todo_vm_name>-clone --file $SRC/<todo_vm_name>-clone.qcow2
virsh start <todo_vm_name>
if [ -f $DEST/<todo_vm_name>-clone.qcow2.old ]; then
  rm -f $DEST/<todo_vm_name>-clone.qcow2.old
else
  echo "The file $DEST/<todo_vm_name>-clone.qcow2.old does not exist!"
fi

echo "Compressing the disk file by creating a new one from it."
qemu-img convert -c -O qcow2 $SRC/<todo_vm_name>-clone.qcow2 $DEST/<todo_vm_name>-clone.qcow2.smaller
rm $SRC/<todo_vm_name>-clone.qcow2
mv $DEST/<todo_vm_name>-clone.qcow2.smaller $DEST/<todo_vm_name>-clone.qcow2

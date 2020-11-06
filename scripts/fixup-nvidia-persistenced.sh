#! /bin/bash
set -ex
sed -e "\$a\\\n[Install]\nWantedBy=multi-user.target" -i /lib/systemd/system/nvidia-persistenced.service
systemctl daemon-reload
systemctl enable nvidia-persistenced.service
mv /lib/udev/rules.d/71-nvidia.rules /lib/udev/rules.d/71-nvidia.rules.temp
grep -v "nvidia-persistenced" /lib/udev/rules.d/71-nvidia.rules.temp > /lib/udev/rules.d/71-nvidia.rules
rm /lib/udev/rules.d/71-nvidia.rules.temp
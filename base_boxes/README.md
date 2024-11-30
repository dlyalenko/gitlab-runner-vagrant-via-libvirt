Используется для хранения базовых образов Vagrant

vagrant box add alse-1.7.5-adv-qemu-mg13.1.1-amd64.box --name alse-1.7.5-adv-qemu-mg13.1.1-amd64

vagrant package --base alse-vanilla-adv/1.7.5 --output alse-vanilla-adv-1.7.5.box
vagrant package --base alse-vanilla-adv/1.7.5 --output /opt/vagrant-runner/base_boxes/alse-vanilla-adv-1.7.5.box
vagrant box add /opt/vagrant-runner/base_boxes/base_boxes/alse-vanilla-adv-1.7.5.box --name alse-vanilla-adv/1.7.5

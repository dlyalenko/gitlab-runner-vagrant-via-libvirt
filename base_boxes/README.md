Используется для хранения базовых образов Vagrant

vagrant package --base alse-vanilla-adv/1.7.5 --output alse-vanilla-adv-1.7.5.box
vagrant package --base alse-vanilla-adv/1.7.5 --output /opt/vagrant-runner/base_boxes/alse-vanilla-adv-1.7.5.box
vagrant box add /opt/vagrant-runner/base_boxes/base_boxes/alse-vanilla-adv-1.7.5.box --name alse-vanilla-adv/1.7.5

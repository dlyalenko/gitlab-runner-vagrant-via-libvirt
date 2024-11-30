Сюда Runner загружает задания проектов для выполнения: директории создаются для каждого задания и удаляются после отработки. Формат пути: /builds/${CUSTOM_ENV_CI_JOB_ID:-0}
Директория включает и "базовый" Vagrantfile, если не предопределён пользовательский

Пример файла Vagrant для образа ALSE 1.7
  Vagrant.configure('2') do |config|
    config.vm.define 'vm01' do |instance|
        # Образ системы Astra Linux Special Edition 1.7.5/adv (усиленный)
        # Посмотреть доступные vagrant-box можно командой 'vagrant box list'
        instance.vm.box = 'alse-vanilla-adv/1.7.5'
        # Не проверять репо на наличие обновлений
        instance.vm.box_check_update = false

        # Устанавливаем hostname инстанса
        instance.vm.hostname = 'vm01'

        # Присваиваем IP из подсети 10.77.145.0/24 и подключаем в бриджованный интерфейс
        # В случае, если мы не указываем ничего, то настройки сети берутся из Libvirt
        #config.vm.network 'public_network', ip: '10.77.145.1#{n}', bridge: 'virbr1'

        # Проброс директории хост-машины в "гостевой" инстанс
        # https://developer.hashicorp.com/vagrant/docs/synced-folders/basic_usage
        # instance.vm.synced_folder '.', '/vagrant', type: 'nfs'
        instance.vm.synced_folder '.', '/mnt/shared'
    end

    config.vm.provider :virtualbox do |virtualbox|
        # Количество vCPU (int)
        virtualbox.cpus = 2
        # Объем оперативной памяти (int)
        virtualbox.memory = 4096
    end

    config.vm.provider :libvirt do |libvirt, override|
        # http://libvirt.org/drivers.html
        libvirt.driver = 'kvm'
        # Количество vCPU (int)
        libvirt.cpus = 2
        # Объем оперативной памяти (int)
        libvirt.memory = 4096
        # SSH (str)
        override.ssh.username = 'astra'
        override.ssh.password = 'astra'
        # Вложенная виртуализация (bool)
        libvirt.nested = true
        # Механизм кеширования (str)
        libvirt.disk_driver :cache => 'writeback'
        # Размер диска в Гб (int)
        libvirt.machine_virtual_size = 5

        # https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html#synced-folders
        libvirt.memorybacking :access, :mode => 'shared'
        override.vm.synced_folder '.', '/mnt/shared', type: 'virtiofs'
    end
end
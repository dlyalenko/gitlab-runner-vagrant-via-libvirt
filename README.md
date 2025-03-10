# О проекте
Проект представлен в виде драйвера для GitLab Runner, который использует Vagrant для запуска виртуальных машин (ВМ) и выполнения задач CI/CD. Это решение позволяет запускать эти задачи без необходимости использования vagrant-файлов в самом проекте, так как настройки выполняются через кастомный исполнитель (custom executor).
# Инсталляция
## Боксы (box)
Боксы 
base_boxes – Директория для хранения Vagrant box.  
# Конфигурационные переменные

Этот файл содержит описание переменных, используемых для настройки среды и управления Vagrant в рамках CI/CD процессов. 

## Таблица переменных

| **Переменная**              | **Описание**                                                                                  | **Тип**  | **Пример значения**                     | **Значение по умолчанию**               |
|-----------------------------|----------------------------------------------------------------------------------------------|----------|------------------------------------------|----------------------------------------|
| `currentDir`               | Текущая директория, где находится данный скрипт.                                             | `str`    | `/path/to/script`                        | Определяется автоматически             |
| `VAGRANT_DRIVER_ROOT` | Корневая директория для драйвера Vagrant.                                                    | `str`    | `/path/to/gitlab-driver-root`            | Определяется автоматически             |
| `VAGRANT_HOME`       | Домашняя директория Vagrant. Если не задано, используется `.vagrant.d` в корне проекта.      | `str`    | `/path/to/gitlab-driver-root/.vagrant.d` | `<VAGRANT_DRIVER_ROOT>/.vagrant.d` |
| `VAGRANT_DRIVER`     | Флаг, указывающий, что используется драйвер Vagrant.                                         | `bool`   | `1`                                      | `1`                                    |
| `VAGRANT_UID`        | Уникальный идентификатор текущего запуска Vagrant, полезный для отладки.                     | `str`    | `runner-0-project-0-concurrent-0-0`     | Формируется динамически                |
| `VAGRANT_DEBUG`      | Флаг для включения отладочного режима.                                                       | `bool`   | `1`                                      | `0`                                    |
| `VAGRANT_RUN_PUPPET` | Флаг для выполнения Puppet при старте виртуальной машины.                                     | `bool`   | `1`                                      | `0`                                    |
| `VAGRANT_BASE_BOX`   | Базовый Vagrant box. Может быть переопределен через переменные окружения.                    | `str`    | `alse-vanilla-adv/1.7.5`                 | `alse-vanilla-adv/1.7.5`               |
| `VAGRANT_PROVIDER`   | Провайдер Vagrant (например, `virtualbox` или `libvirt`).                                    | `str`    | `libvirt`                                | `libvirt`                              |
| `VAGRANT_CPUS`       | Количество процессоров для Vagrant box.                                                      | `int`    | `4`                                      | Пусто                                 |
| `VAGRANT_MEMORY`     | Объем памяти (в МБ) для Vagrant.                                                             | `int`    | `2048`                                   | Пусто                                 |
| `VAGRANT_VBOX_NAME`  | Имя виртуальной машины для VirtualBox.                                                       | `str`    | `runner-0-project-0-concurrent-0-0`     | `<VAGRANT_UID>`                 |
| `VAGRANT_HOSTNAME`   | Хостнейм виртуальной машины.                                                                 | `str`    | `vagrant-host`                           | Пусто                                 |
| `VAGRANT_VAGRANTFILE`| Имя кастомного Vagrantfile.                                                                  | `str`    | `rhel-9.Vagrantfile`                     | `Vagrantfile`                          |
| `BUILDS_DIR`                | Директория для хранения артефактов сборки.                                                   | `str`    | `/path/to/builds/0`                      | `<VAGRANT_DRIVER_ROOT>/builds/0`|
| `CACHE_DIR`                 | Директория для хранения кеша.                                                                | `str`    | `/path/to/cache/0`                       | `<VAGRANT_DRIVER_ROOT>/cache/0` |
| `SCRIPT_PREFIX`             | Префикс для имен скриптов, чтобы избежать конфликтов.                                        | `str`    | `0-0`                                    | `<CUSTOM_ENV_CI_PROJECT_ID>-<CUSTOM_ENV_CI_JOB_ID>` |
| `USER`                      | Имя текущего пользователя.                                                                   | `str`    | `user`                                   | Определяется автоматически             |
| `LOGNAME`                   | Имя логина текущего пользователя.                                                            | `str`    | `user`                                   | Определяется автоматически             |
| `PATH`                      | Переменная окружения PATH с добавлением `/bin`.                                              | `str`    | `/bin:/usr/local/bin:/usr/bin:/bin`      | `/bin:$PATH`                           |

## Примечания

- Значения переменных могут быть переопределены через переменные окружения (например, в CI/CD настройках). 
- Использование этих переменных позволяет гибко конфигурировать Vagrant окружение для выполнения тестов, сборки и других задач. 

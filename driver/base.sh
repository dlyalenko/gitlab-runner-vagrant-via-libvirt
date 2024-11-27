#!/usr/bin/env bash
#
# Скрипт, содержащий переменные и функции, используемые в:
# config.sh, prepare.sh, run.sh и cleanup.sh
#

# Определяем текущую директорию скрипта
# (str)
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Определяем корневую директорию для драйвера Vagrant
# (str)
GITLAB_VAGRANT_DRIVER_ROOT="$( cd "$( dirname "${currentDir}" )" >/dev/null 2>&1 && pwd )"
export GITLAB_VAGRANT_DRIVER_ROOT

# Устанавливаем местоположение домашней директории Vagrant.
# Если не задано, используется директория .vagrant.d в корне проекта.
# (str)
export GITLAB_VAGRANT_HOME="${GITLAB_VAGRANT_DRIVER_ROOT}/.vagrant.d"

# Флаг, указывающий, что скрипт выполняется с использованием драйвера Vagrant.
# Этот флаг можно использовать в Vagrantfile для проверки среды.
# (bool)
GITLAB_VAGRANT_DRIVER=1
export GITLAB_VAGRANT_DRIVER

# Уникальный идентификатор для текущего запуска Vagrant, полезен для отладки.
# Этот параметр можно задать динамически, используя переменные окружения CI.
# (str)
GITLAB_VAGRANT_UID="runner-${CUSTOM_ENV_CI_RUNNER_ID:-0}-project-${CUSTOM_ENV_CI_PROJECT_ID:-0}-concurrent-${CUSTOM_ENV_CI_CONCURRENT_PROJECT_ID:-0}-${CUSTOM_ENV_CI_JOB_ID:-0}"
export GITLAB_VAGRANT_UID

# Включение подробного вывода для отладки (можно настроить в .gitlab-ci.yml)
# Для включения следует установить любое значение, кроме 0.
# (bool)
GITLAB_VAGRANT_DEBUG=0
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_DEBUG:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_DEBUG:-0}" != "0" ]]; then
    GITLAB_VAGRANT_DEBUG=1
fi
export GITLAB_VAGRANT_DEBUG

# Флаг для выполнения Puppet при старте машины.
# Если установлено любое значение, кроме 0, то будет выполнена команда `puppet agent --test`.
# (bool)
GITLAB_VAGRANT_RUN_PUPPET=0
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_RUN_PUPPET:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_RUN_PUPPET:-0}" == "0" ]]; then
    GITLAB_VAGRANT_RUN_PUPPET=0
fi
export GITLAB_VAGRANT_RUN_PUPPET

# Определяем базовый Vagrant box.
# Если переменная окружения CUSTOM_ENV_GITLAB_VAGRANT_BASE_BOX задана, она переопределяет значение по умолчанию.
# (str)
GITLAB_VAGRANT_BASE_BOX="alse-vanilla-adv/1.7.5"
if [[ "${CUSTOM_ENV_CI_JOB_IMAGE:+x}" && "${CUSTOM_ENV_CI_JOB_IMAGE:-x}" != "x" ]]; then
    GITLAB_VAGRANT_BASE_BOX="${CUSTOM_ENV_CI_JOB_IMAGE}"
elif [ "${CUSTOM_ENV_GITLAB_VAGRANT_BASE_BOX:+x}" ]; then
    GITLAB_VAGRANT_BASE_BOX="${CUSTOM_ENV_GITLAB_VAGRANT_BASE_BOX}"
fi
export GITLAB_VAGRANT_BASE_BOX

# Определение провайдера Vagrant (virtualbox или libvirt).
# Это позволяет пользователям динамически изменять провайдера в CI.
# Используется в run.sh как:
# vagrant up --provider=$GITLAB_VAGRANT_PROVIDER
# (str)
GITLAB_VAGRANT_PROVIDER="libvirt"
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_PROVIDER:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_PROVIDER:-x}" != "x" ]]; then
    GITLAB_VAGRANT_PROVIDER=$CUSTOM_ENV_GITLAB_VAGRANT_PROVIDER
fi
export GITLAB_VAGRANT_PROVIDER

# Определение числа процессоров для Vagrant box.
# Если не задано, то Vagrantfile не будет конфигурировать эту настройку.
# (int)
GITLAB_VAGRANT_CPUS=''
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_CPUS:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_CPUS:-x}" != "x" ]]; then
    GITLAB_VAGRANT_CPUS=$CUSTOM_ENV_GITLAB_VAGRANT_CPUS
fi
export GITLAB_VAGRANT_CPUS

# Установка объема памяти (в МБ) для Vagrant.
# Если не задано, Vagrantfile оставит настройки памяти без изменений.
# (int)
GITLAB_VAGRANT_MEMORY=''
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_MEMORY:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_MEMORY:-x}" != "x" ]]; then
    GITLAB_VAGRANT_MEMORY=$CUSTOM_ENV_GITLAB_VAGRANT_MEMORY
fi
export GITLAB_VAGRANT_MEMORY

# Установка имени виртуальной машины для VirtualBox.
# По умолчанию имя машины совпадает с GITLAB_VAGRANT_UID, но это можно переопределить.
# (str)
GITLAB_VAGRANT_VBOX_NAME=$GITLAB_VAGRANT_UID
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_VBOX_NAME:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_VBOX_NAME:-x}" != "x" ]]; then
    GITLAB_VAGRANT_VBOX_NAME=$CUSTOM_ENV_GITLAB_VAGRANT_VBOX_NAME
fi
export GITLAB_VAGRANT_VBOX_NAME

# Определение хоста для виртуальной машины.
# Полезно для тестирования или сервисов (nginx), которые зависят от конкретных имен хостов.
# (str)
GITLAB_VAGRANT_HOSTNAME=""
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_HOSTNAME:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_HOSTNAME:-x}" != "x" ]]; then
    GITLAB_VAGRANT_HOSTNAME="${CUSTOM_ENV_GITLAB_VAGRANT_HOSTNAME}"
fi
export GITLAB_VAGRANT_HOSTNAME

# Использование кастомного Vagrantfile.
# Это позволяет предопределять собственный Vagrantfile, например, `rhel-9.Vagrantfile`.
# (str)
GITLAB_VAGRANT_VAGRANTFILE="Vagrantfile"
if [[ "${CUSTOM_ENV_GITLAB_VAGRANT_VAGRANTFILE:+x}" && "${CUSTOM_ENV_GITLAB_VAGRANT_VAGRANTFILE:-x}" != "x" ]]; then
    GITLAB_VAGRANT_VAGRANTFILE="${CUSTOM_ENV_GITLAB_VAGRANT_VAGRANTFILE}"
fi
export VAGRANT_DEBUG

# Определение директорий для сборок и кеша.
# Эти директории используются для хранения артефактов сборки и кеша, и они привязаны к CI job и проекту.
# (str)
BUILDS_DIR="${GITLAB_VAGRANT_DRIVER_ROOT}/builds/${CUSTOM_ENV_CI_JOB_ID:-0}"
CACHE_DIR="${GITLAB_VAGRANT_DRIVER_ROOT}/cache/${CUSTOM_ENV_CI_PROJECT_ID:-0}"

# Префикс для имен скриптов, чтобы избежать конфликтов с уже существующими скриптами.
# Это полезно для того, чтобы скрипты, генерируемые GitLab Runner, не перезаписывали пользовательские скрипты.
SCRIPT_PREFIX="${CUSTOM_ENV_CI_PROJECT_ID:-0}-${CUSTOM_ENV_CI_JOB_ID:-0}"
export SCRIPT_PREFIX

# Установка пользователя и имени логина для корректной работы с VirtualBox.
export USER=$(whoami)
export LOGNAME=$(whoami)

# Исполняемые файлы.
PATH=/bin:$PATH

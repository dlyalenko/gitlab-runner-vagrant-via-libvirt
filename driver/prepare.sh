#!/usr/bin/env bash
#
# Скрипт подготовки виртуальной машины Vagrant к использованию.
#

# Определяем текущую директорию и импортируем переменные из base.sh
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [[ ! -f "${currentDir}/base.sh" ]]; then
    echo "Ошибка: Файл base.sh не найден. Убедитесь, что он существует в директории ${currentDir}."
    exit 1
fi
source "${currentDir}/base.sh"

# Включаем строгий режим обработки ошибок
# -e: завершить выполнение скрипта при ошибке
# -u: запрещает использование неинициализированных переменных
# -o pipefail: завершить выполнение скрипта, если одна из команд в пайпе завершится с ошибкой
# См. документацию: https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Обработка ошибок: при возникновении ошибки скрипт завершится с системным кодом ошибки.
trap 'echo "Ошибка: Скрипт завершился кодом $? на строке $LINENO"; exit $SYSTEM_FAILURE_EXIT_CODE' ERR

# Вывод диагностической информации для отладки.
echo "--------------------------------------------------------------"
echo "----------------------- ПОДГОТОВКА ---------------------------"
echo "----------------------- VAGRANT VM ---------------------------"
echo "--------------------------------------------------------------"

# Информация о текущем окружении.
echo "Текущая директория (PWD):       $(pwd)"
echo "Версия VirtualBox:              $(vboxmanage --version || echo 'не установлен')"
echo "Версия Libvirt:                 $(virsh --version || echo 'не установлен')"
echo "Плагин Libvirt для Vagrant:     $(vagrant plugin list | grep vagrant-libvirt || echo 'не установлен')"
echo "Версия Vagrant:                 $(vagrant --version || echo 'не установлен')"

# Переменные окружения.
echo "------------------ ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ ----------------------"
echo "Пользователь (USER):            ${USER}"
echo "Логин (LOGNAME):                ${LOGNAME}"
echo "PATH:                           ${PATH}"
echo "Директория сборки (BUILDS_DIR): ${BUILDS_DIR}"
echo "Директория сборок CI:           ${CUSTOM_ENV_CI_BUILDS_DIR:-Не задана}"
echo "Директория кеша (CACHE_DIR):    ${CACHE_DIR}"
echo "Директория проекта:             ${CUSTOM_ENV_CI_PROJECT_DIR:-Не задана}"

# Переменные, связанные с Vagrant.
echo "------------------------ VAGRANT -----------------------------"
echo "Уникальный идентификатор (UID): ${VAGRANT_UID}"
echo "Файл Vagrantfile:               ${VAGRANT_VAGRANTFILE}"
echo "Имя хоста (HOSTNAME):           ${VAGRANT_HOSTNAME}"
echo "Базовый образ (BASE BOX):       ${VAGRANT_BASE_BOX}"
echo "Провайдер:                      ${VAGRANT_PROVIDER}"
echo "Имя виртуальной машины:         ${VAGRANT_VBOX_NAME}"
echo "Количество CPU:                 ${VAGRANT_CPUS:-Не задано}"
echo "Объем памяти (MB):              ${VAGRANT_MEMORY:-Не задано}"
echo "--------------------------------------------------------------"

# Проверка установленных версий инструментов.
if ! command -v vagrant &>/dev/null; then
    echo "Ошибка: Vagrant не установлен или не доступен в PATH"
    exit 1
fi

if [[ "${VAGRANT_PROVIDER}" == "virtualbox" ]]; then
    if ! command -v vboxmanage &>/dev/null; then
        echo "Ошибка: VirtualBox не установлен или не доступен в PATH"
        exit 1
    fi
elif [[ "${VAGRANT_PROVIDER}" == "libvirt" ]]; then
    if ! command -v virsh &>/dev/null; then
        echo "Ошибка: libvirt не установлен или не доступен в PATH"
        exit 1
    fi

    if ! vagrant plugin list | grep vagrant-libvirt; then
        echo "Ошибка: Плагин vagrant-libvirt не установлен. Установите его с помощью 'vagrant plugin install vagrant-libvirt'"
        exit 1
    fi
else
    echo "Ошибка: Указанный провайдер ${VAGRANT_PROVIDER} не поддерживается"
    exit 1
fi

# Дополнительная диагностика (по необходимости).
echo "Все проверки пройдены. Vagrant VM готова к запуску."


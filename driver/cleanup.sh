#!/usr/bin/env bash
#
# Скрипт очистки после завершения работы Vagrant
#

# Определяем текущую директорию скрипта
# (str)
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh

# Включаем строгий режим обработки ошибок
# -e: завершить выполнение скрипта при ошибке
# -u: запрещает использование неинициализированных переменных
# -o pipefail: завершить выполнение скрипта, если одна из команд в пайпе завершится с ошибкой
# См. документацию: https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Перехватываем ошибки и завершаем работу с кодом SYSTEM_FAILURE_EXIT_CODE
trap "exit $SYSTEM_FAILURE_EXIT_CODE" ERR

echo "-------------------------------"
echo "---------- ОЧИСТКА"
echo "-------------------------------"
echo "Vagrant UID:    ${VAGRANT_UID}"
echo "PWD:            $(pwd)"
echo "CI_PROJECT_DIR: ${CUSTOM_ENV_CI_PROJECT_DIR}"
echo "-------------------------------"

# Удаляем виртуальную машину
echo "Удаление виртуальной машины..."
cd "$CUSTOM_ENV_CI_PROJECT_DIR" && vagrant destroy -f

# Убеждаемся, что не находимся в удаляемой директории и удаляем директорию с билдом
cd "$VAGRANT_DRIVER_ROOT" && rm -rf "$BUILDS_DIR"

# Если произошла ошибка при удалении, завершаем скрипт с кодом ошибки
if [[ $? -ne 0 ]]; then
    exit "$SYSTEM_FAILURE_EXIT_CODE"
fi
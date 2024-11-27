#!/usr/bin/env bash
#
# Скрипт для настройки runner'а для использования с Vagrant.
# См. документацию: https://docs.gitlab.com/runner/executors/custom.html#config

# Определяем текущую директорию и импортируем переменные из base.sh
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${currentDir}/base.sh"

# Включаем строгий режим обработки ошибок
# -e: завершить выполнение скрипта при ошибке
# -u: запрещает использование неинициализированных переменных
# -o pipefail: завершить выполнение скрипта, если одна из команд в пайпе завершится с ошибкой
# См. документацию: https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Обработка ошибок: при возникновении ошибки скрипт завершится с системным кодом ошибки.
trap "exit $SYSTEM_FAILURE_EXIT_CODE" ERR

# Генерируем конфигурацию для runner'а в формате JSON
cat << EOS
{
  "builds_dir": "${BUILDS_DIR}",                # Директория сборки
  "cache_dir": "${CACHE_DIR}",                  # Директория кеша
  "builds_dir_is_shared": true,                 # Указывает, что директория сборок общая
  "driver": {
    "name": "Vagrant Libvirt Driver",           # Название драйвера
    "version": "REPLACE_WITH_VERSION_TAG"       # Версия драйвера
  },
  "job_env" : {
    "VAGRANT_UID": "${GITLAB_VAGRANT_UID}"      # Уникальный идентификатор задания
  }
}
EOS

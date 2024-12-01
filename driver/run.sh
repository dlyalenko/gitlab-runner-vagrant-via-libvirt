#!/usr/bin/env bash

# Включаем строгий режим обработки ошибок
# -e: завершить выполнение скрипта при ошибке
# -u: запрещает использование неинициализированных переменных
# -o pipefail: завершить выполнение скрипта, если одна из команд в пайпе завершится с ошибкой
# См. документацию: https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
set -euo pipefail

# Определяем текущую директорию и импортируем переменные из base.sh
export currentDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${currentDir}/base.sh"

echo "---------------------------------------------------"
echo "------------------ ЗАПУСК ${2}"
echo "---------------------------------------------------"
echo "Vagrant UID:                  ${VAGRANT_UID}"
echo "whoami:                       $(whoami)"
echo "PWD:                          $(pwd)"
echo "PATH:                         ${PATH}"
echo "CI_PROJECT_DIR:               ${CUSTOM_ENV_CI_PROJECT_DIR}"
echo "VAGRANT_DEBUG:                ${VAGRANT_DEBUG}"
echo "Driver Root:                  ${VAGRANT_DRIVER_ROOT}"
echo "Vagrant Home:                 ${VAGRANT_HOME}"
echo "VAGRANT_VAGRANTFILE:          ${VAGRANT_VAGRANTFILE}"
echo "---------------------------------------------------"

case "${2}" in
    prepare_script)
        /bin/bash "$1" || exit $BUILD_FAILURE_EXIT_CODE
        ;;
        
    get_sources)
        echo "GIT CLONE"
        echo "---------------------------------------------------"
        /bin/bash "$1" || {
            echo "Не удалось выполнить скрипт для загрузки исходников"
            exit $BUILD_FAILURE_EXIT_CODE
        }
        cd "${CUSTOM_ENV_CI_PROJECT_DIR}" || {
            echo "Не удалось перейти в директорию проекта"
            exit $BUILD_FAILURE_EXIT_CODE
        }

        if [[ $VAGRANT_DEBUG -eq 1 ]]; then
            echo "---------------------------------------------------"
            echo "DEBUG: env ----------------------------------------"
            env
            echo "DEBUG: pwd ----------------------------------------"
            pwd
            echo "DEBUG: ls -la -------------------------------------"
            ls -la
            echo "---------------------------------------------------"
        fi

        vagrantfile_path="${CUSTOM_ENV_CI_PROJECT_DIR}/${VAGRANT_VAGRANTFILE}"
        if [[ ! -f "${vagrantfile_path}" ]]; then
            vagrantfile_path="${VAGRANT_DRIVER_ROOT}/builds/${VAGRANT_VAGRANTFILE}"
            if [[ -f "${vagrantfile_path}" ]]; then
                cp "${vagrantfile_path}" "${BUILDS_DIR}/${VAGRANT_VAGRANTFILE}" || {
                    echo "Не удалось скопировать Vagrantfile"
                    exit $BUILD_FAILURE_EXIT_CODE
                }
            else
                echo "Не найден Vagrantfile"
                exit $BUILD_FAILURE_EXIT_CODE
            fi
        fi

        echo "Валидация VAGRANTFILE"
        vagrant validate || exit $BUILD_FAILURE_EXIT_CODE

        echo "VAGRANT UP"
        vagrant up --provider="$VAGRANT_PROVIDER" || exit $BUILD_FAILURE_EXIT_CODE
        ;;
        
    restore_cache | archive_cache)
        cd "${CUSTOM_ENV_CI_PROJECT_DIR}" && /bin/bash "$1" || {
            echo "Ошибка выполнения ${2}"
            exit $BUILD_FAILURE_EXIT_CODE
        }
        ;;
        
    #step_script | build_script | after_script)
        # scriptPath="${CUSTOM_ENV_CI_PROJECT_DIR}/${SCRIPT_PREFIX}-${2}.sh"
        # cd "${CUSTOM_ENV_CI_PROJECT_DIR}"
        # cat "$1" | awk '{gsub(/\\n/,"\n")}1' > "$scriptPath"
        # sed -i "s#${CUSTOM_ENV_CI_PROJECT_DIR}.tmp#/vagrant/vagrant.tmp#g" "$scriptPath"
        # sed -i "s#${CUSTOM_ENV_CI_PROJECT_DIR}#/vagrant#g" "$scriptPath"
        # chmod 700 "$scriptPath" || exit $BUILD_FAILURE_EXIT_CODE

        # [[ $VAGRANT_DEBUG -eq 1 ]] && {
        #     echo "DEBUG: Содержимое скрипта ------"
        #     cat "$scriptPath"
        # }

        # vagrant ssh -c "cd /vagrant && /vagrant/${SCRIPT_PREFIX}-${2}.sh" || exit $BUILD_FAILURE_EXIT_CODE
    #    echo "Мы тут"
    #    ;;
        
    upload_artifacts_on_success)
        cd "${CUSTOM_ENV_CI_PROJECT_DIR}" && /bin/bash "$1" || {
            echo "Ошибка выполнения ${2}"
            exit $BUILD_FAILURE_EXIT_CODE
        }
        ;;
        
    cleanup_file_variables)
        echo "VAGRANT DESTROY"
        cd "${CUSTOM_ENV_CI_PROJECT_DIR}"
        vagrant destroy -f || exit $BUILD_FAILURE_EXIT_CODE
        ;;
        
    *)
        echo "Неизвестный этап: ${2}"
        exit 1
        ;;
esac

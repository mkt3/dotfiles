#!/bin/bash

######################################
# 各種パラメータ
######################################
# ユーザ名
hostname=`hostnamectl hostname`
username=`whoami`

# バックアップ日時
date=`/bin/date +"%Y%m%d_%H%M"`

# バックアップディレクトリ
backup_dir="earth-borg:/backup/${hostname}/${username}"

# 差分バックアップ世代数
file_keep_days=7
file_keep_weeks=4

# バックアップ対象
backup_list=$HOME

# バックアップ対象外リストファイル名
excluded_backup_list_file="${HOME}/.config/borg/excluded_backup_list"

# 後処理関数
cleanup () {
    rm -rf ${temp_excluded_backup_list_file}
    rm -rf ${backup_log_file}
}

######################################
# 処理
######################################
# バックアップディレクトリをバックアップ対象外リストに追加
temp_excluded_backup_list_file=`mktemp`
if [ -s ${excluded_backup_list_file} ]; then
    cat ${excluded_backup_list_file} > ${temp_excluded_backup_list_file}
fi
echo "${backup_dir}" >> ${temp_excluded_backup_list_file}

# バックアップ実行
backup_log_file=`mktemp`
logger -t `basename ${0}` "backup started."
BORG_RELOCATED_REPO_ACCESS_IS_OK=yes borg create --exclude-from ${temp_excluded_backup_list_file} ${backup_dir}::${hostname}-${username}-${date} ${backup_list} > ${backup_log_file} 2>&1

code=$?
if [ ${code} -ne 0 ]; then
    logger -t `basename ${0}` "backup aborted."
    logger -t `basename ${0}` "$(cat "${backup_log_file}")"
    cleanup
    exit 1
fi

logger -t `basename ${0}` "backup finished."

# 古いバックアップ削除
borg prune -v --list --keep-daily=${file_keep_days} --keep-weekly=${file_keep_weeks} ${backup_dir} >> ${backup_log_file} 2>&1

# 後処理
cleanup

exit 0

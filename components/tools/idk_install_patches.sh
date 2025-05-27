#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
SDK_DIR=$(realpath $SCRIPT_DIR/../..)
PATCH_DIR=$SDK_DIR/idk_patches
IDK_DIR=$SDK_DIR/bk_idk

function check_file_is_patch(){
    first_lines=$(head -n 4 "$1")
    if echo "$first_lines" | grep -qE 'From:' && echo "$first_lines" | grep -qE 'Subject:'; then
        echo 1
        return
    fi
    echo 0
}

cd $IDK_DIR

patch_files=$(find "$PATCH_DIR" -name "*.patch")
diff_files=$(find "$PATCH_DIR" -name "*.diff")
patch_group=()
diff_group=()

for file in $patch_files; do
    if [ $(check_file_is_patch $file) -eq 1 ];then
        patch_group+=("$file")
    else
        diff_group+=("$file")
    fi
done

for file in $diff_files; do
    if [ $(check_file_is_patch $file) -eq 1 ];then
        patch_group+=("$file")
    else
        diff_group+=("$file")
    fi
done

for file in ${patch_group[@]}; do
    git am $file
    if [ $? -ne 0 ];then
        git am --abort
        patch -p1 < $file
        if [ $? -ne 0 ];then
            echo "patch install $file fail, please check patch valid."
        fi
    fi
done

for file in ${diff_group[@]}; do
    patch -p1 < $file
    if [ $? -ne 0 ];then
        echo "patch install $file fail, please check patch valid."
    fi
done

#!/bin/bash

APP_NAME=`basename $0`
bin_dir=`dirname $0`

source ${bin_dir}/functions.sh

function extract_initramfs()
{
    local initramfs_source_file="${1:-'empty'}"
    exit_unless_strings_differ "empty" "${initramfs_source_file}"

    local initramfs_destination_directory="${2:-'empty'}"
    exit_unless_strings_differ "empty" "${initramfs_destination_directory}"
    exit_unless_initramfs_destination_directory_is_writable ${initramfs_destination_directory} "initramfs destination"

    mkdir ${initramfs_destination_directory};
    ( cd ${initramfs_destination_directory};  gunzip -c ${initramfs_source_file} | cpio -i );
}

function usage()
{
    printf "Usage : %s <%s> <%s>\n" $APP_NAME "initramfs_source_image" "initramfs_destination_directory"
}

function main()
{
    if [ -z "$2" ] ; then
        usage;
        exit `false`;
    fi
    printf "%s: Info: %s\n" $APP_NAME "extracting initramfs started at `date`"
    extract_initramfs $@;
    printf "%s: Info: %s\n" $APP_NAME "extracting initramfs completed at `date`"
}

main $@

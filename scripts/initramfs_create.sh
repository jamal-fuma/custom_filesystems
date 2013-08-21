#!/bin/bash

APP_NAME=`basename $0`
bin_dir=`dirname $0`

source ${bin_dir}/functions.sh

function find_initramfs_source_files()
{
    local directory="$1"

    # walk the filesystem collecting the names of suitable files
    # the more files we can exclude here the faster the overall job will run
    ( cd ${directory}; find . -print0 )
}

function cpio_initramfs_source_files()
{
    cpio -0 -H newc -o
}

function gzip_initramfs_source_files()
{
    gzip -9
}

function create_initramfs()
{
    local initramfs_source_directory="${1:-'empty'}"
    exit_unless_strings_differ "empty" "${initramfs_source_directory}"

    local initramfs_destination_path="${2:-'empty'}"
    exit_unless_strings_differ "empty" "${initramfs_destination_path}"
    exit_unless_initramfs_destination_directory_is_writable ${initramfs_destination_path} "initramfs destination"

    find_initramfs_source_files "${initramfs_source_directory}" | \
    cpio_initramfs_source_files | \
    gzip_initramfs_source_files > "${initramfs_destination_path}"

}

function usage()
{
    printf "Usage : %s <%s> <%s>\n" $APP_NAME "initramfs_source_directory" "initramfs_destination_path"
}

function main()
{
    if [ -z "$2" ] ; then
        usage;
        exit `false`;
    fi
    printf "%s: Info: %s\n" $APP_NAME "creating initramfs started at `date`"
    create_initramfs $@;
    printf "%s: Info: %s\n" $APP_NAME "creating initramfs completed at `date`"
}

main $@

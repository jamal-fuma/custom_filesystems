function exit_unless_directory_is_present()
{
    local directory="$1"
    local type_of_directory="$2"

    local tracemsg="directory=${directory}"
    local errormsg="The specified ${type_of_directory} directory was not found."

    printf "%s: Info: %s\n" $APP_NAME $tracemsg

    if [ ! -d ${directory} ] ; then
        printf "%s: Error: %s\n" $APP_NAME $errormsg;
        exit `false`
    fi
}

function exit_if_file_present()
{
    local data_file="$1"
    local type_of_data_file="$2"

    local tracemsg="data_file=${data_file}"
    local errormsg="The specified ${type_of_data_file} data_file was unexpectedly found, it should not yet exist."

    printf "%s: Info: %s\n" $APP_NAME $tracemsg

    if [ -f ${data_file} ] ; then
        printf "%s: Error: %s\n" $APP_NAME $errormsg;
        exit `false`
    fi
}

function exit_unless_file_present()
{
    local data_file="$1"
    local type_of_data_file="$2"

    local tracemsg="data_file=${data_file}"
    local errormsg="The specified ${type_of_data_file} data_file was not found."

    printf "%s: Info: %s\n" $APP_NAME $tracemsg

    if [ ! -f ${data_file} ] ; then
        printf "%s: Error: %s\n" $APP_NAME $errormsg;
        exit `false`
    fi
}

function exit_unless_directory_is_writable()
{
    local directory="$1"
    local type_of_directory="$2"
    local tracemsg="directory=${directory}"
    local errormsg="The specified directory was not writeable"
    local test_path="${directory}/-foo-bar_test_file123"

    printf "%s: Info: %s\n" $APP_NAME $tracemsg

    exit_if_file_present "${test_path}"

    if touch "${test_path}" ; then
        rm "${test_path}"
    else
        printf "%s: Error: %s\n" $APP_NAME $errormsg;
        exit `false`
    fi
}

function exit_unless_strings_differ
{
    local expected="$1"
    local actual="$2"

    local tracemsg=<<EOS
actual=${actual}
expected=${expected}
EOS

    local errormsg="These values are expected to be different, instead they are the same, this is a bad thing (tm)."

    printf "%s: Info: %s\n" $APP_NAME $tracemsg

    if [ ${actual} = ${expected} ] ; then
        printf "%s: Error: %s\n" $APP_NAME $errormsg;
        exit `false`
    fi
}


function exit_unless_initramfs_source_directory_is_present()
{
    local directory="${1:-'empty'}"
    exit_unless_strings_differ "empty" "${directory}"
    exit_unless_directory_is_present "${directory}" "initramfs source"
}

function exit_unless_initramfs_destination_directory_is_writable()
{
    local directory="${1:-'empty'}"
    exit_unless_initramfs_source_directory_is_present "$directory" "initramfs destination"
    exit_unless_directory_is_writable "${directory}" 
}

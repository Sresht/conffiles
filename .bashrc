# ~/.bashrc: executed by bash(1) for non-login shells.

# incremental history for control+r
export PROMPT_COMMAND='history -a'
# jack up the history size for control+r
export HISTSIZE=10000000
export EDITOR=subl
alias ta='tmux a'
alias na='subl ~/.bashrc'
alias sb='source ~/.bashrc'

# up [n] goes up n directories from the current directory
function up {
  for i in $(seq 1 $1);
    do cd ..;
  done
}

export testpath='~/test/'

function pcp {
    choice=$1
    backup=$choice"_backup"
    cp $choice $backup
}

function prm {
    choice=$(pickfile $1)
    backup=$choice"_backup"
    rm $backup
}

function mktest {
    if [[ $1 ]]
    then
        filename="$testpath$1"
        if ! [[ -e $filename ]]
        then
            vim $filename
            export test_file="$1"
        else
            echo "$filename already exists."
        fi
    else
        echo "You must provide a testname."
    fi
}

# enable tab complete on the ~/test when using the otest command
function _codeComplete {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls ~/test/)" -- $cur) )
}

complete -F _codeComplete otest

# opens a test in the test directory. Tab complete enabled
function otest {
    if [[ $1 ]]
    then
        filename="$testpath$1"
        if [[ -e $filename ]]
        then
            export test_file="$1"
            subl $filename
        else
            echo "$filename does not exist."
        fi
    elif [[ $test_file ]]
    then
        filename="$testpath$test_file"
        if [[ -e $filename ]]
        then
            subl $filename
        else
            echo "$filename does not exist."
        fi
    else
        echo "You must provide a testname or set \$test_file."
    fi
}

# runs the most recent test that was created/opened using the perl debugger
# function dtest {
#     if ! [[ $test_file ]]
#     then
#         echo "\$test_file hasn't been set."
#     else
#         perld "$testpath$test_file"
#     fi
# }

# Runs the most recent test that was created/opened
function rtest {
    if ! [[ $test_file ]]
    then
        echo "\$test_file hasn't been set."
    else
        perl "$testpath$test_file"
    fi
}

# lists all the created tests
function lstest {
    ls -c $testpath
}

function testhelp {
    echo "    Use mktest [testname] to make a new test.
    Use otest [testname] to open and edit [testname].
    Use rtest to run the most recent test that was created.
    Use dtest to run the most recent test that was created using the perl debugger.
    Use lstest to list all the tests in the directory."
}

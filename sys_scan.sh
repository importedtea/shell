#!/bin/bash

# TIP
# Check the github page https://github.com/jgmdev/watchsys for a good way of
# implementing bash functions and making code more elegant.
# This is also a good source of how to set up a file structure for this project.

# TO DO
# Create a helper function that detects the OS as os-release or centos-release, etc.
# - this helper function will be used in the the detectNetwork function to determine on using ifconfig or ip a
# General fix ups that make the script portable on other OS
# Maybe make a better _header helper function

# ISSUE
# Logger currently not used for anything
# use _log [what you want to log] to log to sys_scan.log
_log() { [[ -t 1 ]] && echo "$@" >> sys_scan.log; }

# Global Color Options
orange=$(tput setaf 3)
reset=$(tput sgr0)

# ISSUE
# Make a _header helper function that isn't lame
function _header () {
    printf "%0.s-" {1..70}; echo
}

# ISSUE
# Update this function with an appropriate usage clause.
function displayHelp () {
    _header
    printf "USAGE:\n"
    printf "\tThis function still needs to be updated with usage clause.\n"
    printf "\tSo far, you may use -h for help.\n"
    _header
}

# ISSUE
# Add a way to get formatted output
# i.e. have it print Finding...found as [formatting spaces] : info
# catch, the beginning text will have to be output before formatting happens
# DONE
# Formatted _verbose helper function located in print_helper.sh
# Needs to be added to this script
    # Maybe this secondary script can be sourced for use instead of copypasta

# ISSUE 2
# Add the new helper function with auto formatting.
function _verbose () {
    if [[ "$verbosity" -eq "0" ]]; then
		printf "\033[1;31m-> \033[0m$1\n"
	fi
}

# ISSUE
# Maybe have no message displayed when successfully ran as root

# ISSUE 2
# Maybe merge these two functions into one, or push into a different file and source
function _she_assert_root {
  if [[ ${EUID} -ne 0 ]]; then
    _she_die "Hey everyone, I just tried to do something very silly!"
  else
    printf "\nAccess granted\n\n"  
  fi
}

function _she_die {
  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  echo >&2 -e "${red}$@${reset}"
  exit 1
}

# ISSUE
# Remove the need for the distro variable, also apart of getopts implementation
function detectKernel () {
	printf "\n${orange}Finding Kernel Information${reset}\n"
    
    if [[ "$distro" == "OpenBSD" ]]; then
		kernel=$(sysctl kern.version|awk -F'[ =:]' 'NR==1{print $3" "$4" "$5}')
	else
        kernel=$(uname -sr)
        arch=$(uname -m)
		kernel=${kernel//$'\n'/ }

        if [ $arch = "x86_64" ]; then
            pretty_arch="(64-bit)"
        else
            pretty_arch="(32-bit)"
        fi

		_verbose "Finding version...found as        : '${arch} ${pretty_arch} ${kernel}'"
	fi
}

# ISSUE
# /proc might be your friend for all distros information
# bash built-ins for USER and HOSTNAME may only be bash specific; need to look into
    # hence the line using -z and redirecting to the whoami call

# ISSUE 2
    # Output is displaying root@, not the actual current user
        # Potentially because the script is ran as sudo?
        # However, if you do sudo echo $USER in a shell, it prints your user
    # myUser set to whoami for testing and gave same result as root
function detectHost () {
	printf "\n${orange}Finding Host Information${reset}\n"
    
    myUser=${USER}
    # whoami test for ISSUE 2
    #myUser=$(whoami)
	myHost=${HOSTNAME}
    
    # /proc might be a more portable solution for all systems?
    host_proc=$(cat /proc/sys/kernel/hostname)
    myDomain=$(cat /proc/sys/kernel/domainname)
	
    # If no value for $USER, then search for username using whoami
    if [[ -z "$USER" ]]; then myUser=$(whoami); fi

	_verbose "Finding host and user...found as  : '${myUser}@${myHost}'"
    _verbose "Finding FQDN...found as           : '${myDomain}''"
    _verbose "/proc hostname...found as         : '${host_proc}''"
}

# ISSUE
# Create OS detection helper function instead of using if/elif statement
function detectOS () {
    printf "\n${orange}Finding OS Information${reset}\n"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$PRETTY_NAME
        ALIAS=$( echo "${VERSION}" | cut -c 11- )
        VER=$(cat /proc/version_signature)

        _verbose "Finding OS...found as             : '${OS} ${ALIAS}'"
        _verbose "Finding version...found as        : '${VER}''"

    elif [ -f /etc/centos-release ]; then
        RELEASE_RPM=$(rpm -qf /etc/centos-release)
        RELEASE=$(rpm -q --qf '%{RELEASE}' ${RELEASE_RPM})
        _verbose "Finding CentOS/RHEL OS...found as '${RELEASE}'"

        VERSION=$(rpm -q --qf '%{VERSION}' ${RELEASE_RPM})
        case ${VERSION} in
            6*)
                echo "Enterprise Linux (EL): 6"
                ;;
            7*)
                echo "Enterprise Linux (EL): 7"
                ;;
        esac

        _verbose "Finding Enterprise Linux version...found as '${VERSION}'"

    fi  
}

function detectProcesses () {
    printf "\n${orange}Finding Process Information${reset}\n"

    # Find the total number of process currently on the system
    processnum="$(( $( ps aux | wc  -l ) - 1 ))"

    _verbose "Finding running processes...found '${processnum} processes'"
}

function detectMemory() {
    printf "\n${orange}Finding Memory Information${reset}\n"
    
    total_ram=$( grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc )
    free_ram=$(  grep MemFree /proc/meminfo  | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc )
    used_ram=$(  echo $total_ram $free_ram   | awk '{print $1-$2}' )
    mem_per=$(   free | grep Mem | awk '{print $3/$2 * 100.0}' )

    _verbose "Finding total memory on system    : '$total_ram GB'"
    _verbose "Finding free memory on system     : '$free_ram GB'"
    _verbose "Finding used memory on system     : '$used_ram GB'"
    _verbose "Finding memory percentage in use  : '$mem_per %%'"
}

# ISSUE
    # This will most likely only work on newer versions of Ubuntu.
    # Other versions of Ubuntu use the motd

# ISSUE 2
    # I don't think this actually displays packages that need to be updated
    # Upon login it said there were 3 packages and after running the script, none
    # Unless they automatically updated somehow (which I don't think is the case)

# RESOLVED 2
    # I may have just misread the login messages and the script messages
    # They come from the same source so it is unlikely that they are off
function detectUpdate () {
    printf "${orange}Finding Package Update Information${reset}\n"
    
    cat /var/lib/update-notifier/updates-available
}

function detectNetwork () {
    printf "${orange}Finding Network Information${reset}\n"

    # A more portable network address solution might be hostname -I
        # maybe check with if -z to see if ipc or ipa give any output, if not use hostname -I
        # or who really cares because ipc and ipa are probably both supported these days
    # Find the IP of the device regardless of interface pattern; exclude loopback
    local ipc=$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )
    local ipa=$( ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )

    # This is the path on CentOS that displays DNS servers.
    # DOES NOT work on Ubuntu
    #local dns=$(cat /etc/sysconfig/networking/profiles/default/resolv.conf)
    #_verbose "DNS found... $dns"

    #ISSUE: check to see if system uses ifconfig or ip a, then print using specific command
    # -q = quiet
    # -c = stop after count value
    # -W = time to wait for response in seconds
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        _verbose "$ipc is up\n"
    else
        _verbose "$ipc is down\n"
        # TO DO
        # Send email or system mail message if IP is down.
    fi


}

# ISSUE
    # Remove OS detection if/elif once OS helper function created

# ISSUE 2
    # As of 6/5/18 this function produces no output
        # This is most likely because the FILE variable is not found
        # I don't remember what it could have been, so it will take some time to remember.

# RESOLVED 2
    # Added FILE variable to temporarily get this function up and running.

function testing () {
    printf "\n${orange}Tested Operating Systems${reset}\n"

    # Temporary log file to get this function up and running
    FILE=sys_scan.log

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$PRETTY_NAME
        #VER might not cut correctly for all OS, maybe easier way to get same result
        VER=$( echo "${VERSION}" | cut -c 11- )

        # Check if the file contents size is > 0
        # If the file has a size > 0, look if the existing text matches
        # If it matches, skip, if it is different, add.
        # However, switching between systems will not store contents from previously ran
        # - This still prevents the same output from being printed multiple times.
        if [ -s $FILE ]; then
            tmp=$( cat $FILE | grep "$OS $VER" )
        else
            # Print a check mark next to the OS tested on.
            # Check might not show on all shells.
            printf "\xE2\x9C\x94 ${OS} ${VER}\n" >> $FILE

            # ISSUE
        fi

        cat $FILE

        # Option to remove the file if you don't want it on your system
        rm -rf $FILE

    elif [ -f /etc/centos-release ]; then
        RELEASE_RPM=$(rpm -qf /etc/centos-release)
        RELEASE=$(rpm -q --qf '%{RELEASE}' ${RELEASE_RPM})

        VERSION=$(rpm -q --qf '%{VERSION}' ${RELEASE_RPM})
        case ${VERSION} in
            6*)
                echo "Enterprise Linux (EL): 6"
                ;;
            7*)
                echo "Enterprise Linux (EL): 7"
                ;;
        esac

    fi  
}

# # add selinux check function
# function detectSEBools () {
#     # ISSUE
#     # This requires policycoreutils package on Ubuntu and policycoreutils-python on CentOS
#     # SELinux is disabled by default in Ubuntu Server 18.04

#     # This will show a list of all SEbools that are currently on
#     # sestatus -b | grep on$

#     # Since the list could potentially be long, some kind of formatting would have to be used

#     # OS detection would have to be used at the beginning of the function
#     # If SELinux disabled, exit the function; if available run the rest of the function
# }

# Allow for --help opt
case $1 in
	--help) displayHelp; exit 0;;
esac

#ISSUE: Add OPTS to grab specific portions of output, such as -n for network, -h for host, etc.
# Allow other options to be used; check if option is valid \?
while getopts ":v" flags; do
	case $flags in
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
	esac
done

# FLAGS (for later implementation, currently distro only controls once function)
# If you want os to be just linux, you can use $OSTYPE builtin, which will out put linux...etc
# If you want to detect Mac, the kernel is darwin
distro="Linux"
verbosity=

############# Function Calls
_she_assert_root

detectNetwork

detectUpdate

detectProcesses

detectMemory

detectKernel

detectOS

detectHost

testing
#!/bin/sh
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required
# The above line ensures that the script can be run on Cygwin/Linux even with Windows CRNL
#
# Run 'mkdocs serve' on port 8000 (default).

# Supporting functions, alphabetized.

# Make sure the MkDocs version is consistent with the documentation content:
# - require that at least version 1.0 is used because of use_directory_urls = True default
# - must use "file.md" in internal links whereas previously "file" would work
# - it is not totally clear whether version 1 is needed but try this out to see if it helps avoid broken links
checkMkdocsVersion() {
  # Required MkDocs version is at least 1.
  requiredMajorVersion="1"
  # On Cygwin, mkdocs --version gives:  mkdocs, version 1.0.4 from /usr/lib/python3.6/site-packages/mkdocs (Python 3.6)
  # On Debian Linux, similar to Cygwin:  mkdocs, version 0.17.3
  # On newer windows: MkDocs --version:  python -m mkdocs, version 1.3.1 from C:\Users\steve\AppData\Local\Programs\Python\Python310\lib\site-packages\mkdocs (Python 3.10)
  # The following should work for any version after a comma.
  mkdocsVersionFull=$(${mkdocsExe} --version | sed -e 's/.*, \(version .*\)/\1/g' | cut -d ' ' -f 2)
  echo "MkDocs --version:  ${mkdocsVersionFull}"
  mkdocsVersion=$(echo ${mkdocsVersionFull} | cut -d ' ' -f 3)
  if [ -z "${mkdocsVersion}" ]; then
    echo "Error getting MkDocs version.  Is it installed?"
    exit 1
  fi
  echo "MkDocs full version number:  ${mkdocsVersion}"
  mkdocsMajorVersion=$(echo ${mkdocsVersion} | cut -d '.' -f 1)
  echo "MkDocs major version number:  ${mkdocsMajorVersion}"
  if [ "${mkdocsMajorVersion}" -lt ${requiredMajorVersion} ]; then
    echo ""
    echo "MkDocs version for this documentation must be version ${requiredMajorVersion} or later."
    echo "MkDocs version that is found is ${mkdocsMajorVersion}, from full version ${mkdocsVersion}."
    exit 1
  else
    echo ""
    echo "MkDocs major version (${mkdocsMajorVersion}) is OK for this documentation."
  fi
}

# Determine the operating system that is running the script:
# - mainly care whether Cygwin or MINGW
checkOperatingSystem() {
  if [ ! -z "${operatingSystem}" ]; then
    # Have already checked operating system so return.
    return
  fi
  operatingSystem="unknown"
  os=`uname | tr [a-z] [A-Z]`
  case "${os}" in
    CYGWIN*)
      operatingSystem="cygwin"
      ;;
    LINUX*)
      operatingSystem="linux"
      ;;
    MINGW*)
      operatingSystem="mingw"
      ;;
  esac
}

# Check the source files for issues:
# - the main issue is internal links need to use [](file.md), not [](file)
checkSourceDocs() {
  # Currently don't do anything but could check the above.
  # Need one line to not cause an error.
  :
}

# Set the MkDocs executable to use, depending operating system and PATH:
# - sets the global ${mkdocsExe} variable
# - return 0 if the executable is found, exit with 1 if not
setMkDocsExe() {
  if [ "${operatingSystem}" = "cygwin" -o "${operatingSystem}" = "linux" ]; then
    # Is usually in the PATH.
    mkdocsExe="mkdocs"
    if hash py 2>/dev/null; then
      echo "mkdocs is not found (not in PATH)."
      exit 1
    fi
  elif [ "${operatingSystem}" = "mingw" ]; then
    # This is used by Git Bash:
    # - calling 'hash' is a way to determine if the executable is in the path
    if hash py 2>/dev/null; then
      mkdocsExe="py -m mkdocs"
    else
      # Try adding the Windows folder to the PATH and rerun:
      # - not sure why C:\Windows is not in the path in the first place
      PATH=/C/Windows:${PATH}
      if hash py 2>/dev/null; then
        mkdocsExe="py -m mkdocs"
      else
        echo 'mkdocs is not found in C:\Windows.'
        exit 1
      fi
    fi
  fi
  return 0
}

# Entry point into the script.

# Check the operating system.
checkOperatingSystem

# Set the MkDocs executable:
# - will exit if MkDocs is not found
setMkDocsExe

# Make sure the MkDocs version is OK.
checkMkdocsVersion

# Check the source files for issues.
checkSourceDocs

# Get the folder where this script is located since it may have been run from any folder.
scriptFolder=$(cd $(dirname "$0") && pwd)
# Change to the folder where the script is since other actions below are relative to that.
cd ${scriptFolder}

cd ../mkdocs-project

port=8000
echo "View the website using http://localhost:${port}"
echo "Stop the server with CTRL-C"
${mkdocsExe} serve -a 0.0.0.0:${port}

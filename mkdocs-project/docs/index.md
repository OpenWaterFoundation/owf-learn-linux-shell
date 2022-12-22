# Learn / Linux Shell #

This documentation provides information to learn how to use the Linux shell,
which provides an interactive command line environment and ability to automate tasks with shell scripts.
Linux shell scripts are useful for memorializing computational steps and automating repetitive tasks.
Information about some specific topics, such as configuring `cron` is provided to help with automation.
This documentation has been written based on experience using Linux shells at the Open Water Foundation.

Linux shell environments are available on Linux computers and are also available on Windows via
the following environments:

*   Cygwin (see the [Open Water Foundation / Learn Cygwin](https://learn.openwaterfoundation.org/owf-learn-cygwin/) documentation)
*   Git for Windows (Git Bash) and other MinGW environments
    (see the [Open Water Foundation / Learn Git](https://learn.openwaterfoundation.org/owf-learn-git/) and
    [MinGW environment for Fortran](https://opencdss.state.co.us/statemod/latest/doc-dev/dev-env/machine/) documentation)
*   Linux Subsystem for Windows (see [Install / Windows Subsystem for Linux]())
*   VirtualBox running a guest environment on Windows host machine
    (see the [Open Water Foundation / Learn VirtualBox](https://learn.openwaterfoundation.org/owf-learn-virtualbox) documentation)
    and shared folders
*   other software

An advantage of Linux environments that run within Windows is that Windows programs can also be run
and Windows files are available.

See the [Select and Install Shell Software](../install/install) section for more information.
Note that the term "Linux Shell" is used throughout rather than "Unix Shell" given the popularity of Linux,
and the information generally applies to the Mac computers.

Alternatives to Linux shell scripts on Windows are [batch files (`.bat`) or
command files (`.cmd`)](https://en.wikipedia.org/wiki/Batch_file) and
[PowerShell scripts](https://en.wikipedia.org/wiki/PowerShell),
which are not discussed in this documentation except when comparison is enlightening.
See also the [Open Water Foundation / Learn Windows Shell](https://learn.openwaterfoundation.org/owf-learn-windows-shell) documentation.

More advanced programming can be performed with other languages.
Python is recommended given its ease of use, popularity, and functionality.
However, even when a programming language could be used to write a software program,
the Linux shell is still useful for ad hoc tasks such as searching and reformatting files
and stringing together computation tasks using existing programs such as Linux commands.

## About the Open Water Foundation ##

The [Open Water Foundation](https://openwaterfoundation.org) is a 501(c)3 nonprofit social enterprise that focuses
on developing and supporting open source software and open data solutions for water resources
so that organizations can make better decisions about water.
OWF also works to advance open data tools and implementation.
OWF has created this documentation to educate its staff, collaborators, and clients that use Linux shells.

See also other [OWF learning resources](https://learn.openwaterfoundation.org).

## How to Use this Documentation ##

The documentation is organized in order of information and tasks necessary to setup a Linux shell environment,
learn about shell programming, learn about useful commands, and learn useful script examples.

This documentation is not intended to be a full reference for Linux shells but focuses on topics that
will help understand important technical concepts and be successful with Linux shells.
See the [Resources section](../resources/resources) for general information about Linux shells.

See appendices for specific topics.

Use the navigation menu provided on the left side of the page to navigate the documentation sections within the full document.
Use the navigation menu provided on the right side of the page to navigate the documentation sections with a page.
The navigation menus may not be displayed if the web browser window is narrow or if viewing on a mobile device,
in which case look for a menu icon to access the menus.
Use the search feature to find documentation matching search words.

## License ##

The OWF Learn Linux Shells website content and examples are licensed under the
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0).

## Source Repository on GitHub ##

The source files for this documentation are maintained in a GitHub repository:  [owf-learn-linux-shell](https://github.com/OpenWaterFoundation/owf-learn-linux-shell).

## Release Notes ##

See the [Release Notes in the GitHub project repository](https://github.com/OpenWaterFoundation/owf-learn-linux-shell#release-notes),
although the [GitHub issues](https://github.com/OpenWaterFoundation/owf-learn-linux-shell/issues) are more often used to track changes.

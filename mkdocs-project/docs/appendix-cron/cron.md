# Appendix / `cron` Service  #

The `cron` software is a useful service that schedules running programs on a regular frequency.

*  [Introduction](#introduction)
*  [`cron` on Linux](#cron-on-linux)
*  [Windows Scheduler](#windows-scheduler)
*  [`cron` on Windows Subsystem for Linux](#cron-on-windows-subsystem-for-linux)
*  [`cron` on Cygwin](#cron-on-cygwin)

------------

## Introduction ##

The `cron` service software runs continuously,
checks a list of configured commands, and runs those commands when a time condition is met.
The Linux environment must support services.

See the [`cron`](https://en.wikipedia.org/wiki/Cron) documentation on Wikipedia.

## `cron` on Linux ##

The `cron` service is typically enabled by default on full Linux systems
because `cron` is used to perform system tasks such as software updates.

Additional configuration may be required to enable `cron` or equivalent as described in the following sections.

## Windows Scheduler ##

The Windows Scheduler is a service that runs on the Microsoft Windows operating system.
See the [Task Scheduler](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-task-scheduler) documentation.

The Windows scheduler may be an appropriate solution in some cases and is also required for certain configurations,
such as with the [`cron` on Windows Subsystem for Linux](#cron-on-windows-subsystem-for-linux).

## `cron` on Windows Subsystem for Linux ##

The Windows Subsystem for Linux (WSL) can be used to run Linux programs within Microsoft Windows.

See the [WSL `cron` documentation](cron-wsl/cron-wsl.md).

## `cron` on Cygwin ##

This section will be completed in the future.

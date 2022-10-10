# owf-learn-linux-shell #

This repository contains the [Open Water Foundation (OWF)](https://openwaterfoundation.org/) Linux shell learning resources,
which provide guidance for creating and using Linux shell scripts.
The documentation is written for the layperson in order to encourage use of Linux shell scripts.

See the deployed [OWF / Learn Linux Shell](https://learn.openwaterfoundation.org/owf-learn-linux-shell/) documentation.

## Repository Contents ##

The repository contains the following:

```text
.github/              Files specific to GitHub such as issue template.
.gitattributes        Typical Git configuration file.
.gitignore            Typical Git configuration file.
README.md             This file.
build-util/           Useful scripts to view, build, and deploy documentation.
mkdocs-project/       Typical MkDocs project for this documentation.
  mkdocs.yml          MkDocs configuration file for website.
  docs/               Folder containing source Markdown and other files for website.
  site/               Folder created by MkDocs containing the static website - ignored using .gitignore.
z-local-notes/        Use for local developer notes not committed to the repository.

```

## Development Environment ##

The development environment for contributing to this project requires installation of Python, MkDocs, and Material MkDocs theme.
Python 2 has been used for development.  See the [`OWF Learn MkDocs`](https://learn.openwaterfoundation.org/owf-learn-mkdocs/)
documentation for information about installing these tools.

In order to run the Linux shell examples, one of the following must be available:

* Windows:
	+ Cygwin
	+ Git Bash - installed with Git for Windows
	+ MinGW (Minimalist GNU for Windows)
	+ Windows Subsystem for Linux
* Linux:
	+ Any version

## Editing and Viewing Content ##

If the development environment is properly configured, edit and view content as follows:

1. Edit content in the `mkdocs-project/docs` folder and update `mkdocs-project/mkdocs.yml` as appropriate.
2. Run the `build-util/run-mkdocs-serve-8000.sh` script (Linux) or equivalent.
3. View content in a web browser using URL `http://localhost:8000`.

## License ##

The OWF Learn Linux Shell website content and examples are licensed under the
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0).

## Contributing ##

Contribute to the documentation as follows:

1. Use GitHub repository issues to report minor issues.
2. Use GitHub pull requests.

## Style Guide ##

The following are general style guide recommendations for this documentation,
with the goal of keeping formatting simple in favor of focusing on useful content:

* Use the Material MkDocs theme - it looks nice, provides good navigation features, and enables search.
* Follow MkDocs Markdown standards - use extensions beyond basic Markdown when useful.
* Show files and program names as `code (tick-surrounded)` formatting.
* Where a source file can be linked to in GitHub, provide a link so that the most current file can be viewed.
* Use triple-tick formatting for code blocks, with language specifier.
* Use ***bold italics*** when referencing UI components such as menus.
* Use slashes to indicate ***Menu / SubMenu***.
* Place images in a folder with the same name as the content file and include `-images` at the end of the folder name.
* Minimize the use of inlined HTML, but use it where Markdown formatting is limited.
* Although the Material them provides site and page navigation sidebars,
provide in-line table of contents on pages, where appropriate, to facilitate review of page content.

## Maintainers ##

This repository is maintained by the [Open Water Foundation](https://openwaterfoundation.org/).

## Contributors ##

Steve Malers, Open Water Foundation (@smalers)

## Release Notes ##

The following release notes indicate the update history for documentation, with GitHub repository issue indicated,
if applicable (links to issues via README.md are not cleanly supported by GitHub so use the repository issues page to find).

* 2018-01-06 - Initial content.

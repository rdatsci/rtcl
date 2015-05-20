# rt: R tools for the command line

This package ships some command line utilities which simplify working with R packages from the command line.
Many commands *rt* provides are just wrappers around [devtools](https://github.com/hadley/devtools) but ensure a valid exit code which is required to use these commands for shell scripting.
Furthermore, *rt* allows you to maintain a collection of you favorite packages in a plain text file which you can add to your [dotfiles](https://dotfiles.github.io/) and share across systems.
This file may also contain git sources to keep you up to date with packages not yet released on CRAN.

## Available commands

* `rbuild` to bundle a local package.
* `rcheck` to check a local package.
* `rclean` to remove `.[o|so]` files from a local package.
* `rdoc` to document a local package using roxygen.
* `rinstall` to install a remote package, e.g. a package hosted on CRAN or GitHub.
* `rmake` to make a local package (document and install).
* `rtest` to test a local package.
* `rupdate` to update all CRAN packages on your system, install missing CRAN packages listed in your collection `~/.rt/packages` and update all packages with a git source.
* `rwinbuild` to upload a local package to the winbuilder service.


## Setup
First, you need to install *rt* itself.
Using a personal library (e.g., `echo 'R_LIBS_USER=~/.R/library' >> ~/.Renviron`) for all R packages is strongly advised.
```splus
library(devtools)
install("rdatsci/rt")
```
The command line scripts are now installed in the subdirectory `rt/bin` of your R library (call `.libPaths()` in R if unsure about its location).
You need to add this directory to your `PATH` in your `.bashrc` or `.zshrc`:
```sh
# bash
PATH=~/.R/library/rt/bin:$PATH

# zsh
path=(~/.R/library/rt/bin $path)
```
After sourcing this file (or after a re-login) you should be all set to use *rt*.

To keep *rt* updated, you can let it maintain itself via `rupdate` by adding it to your collection file `~/.rt/packages`.
To do this, first initialize an empty collection with
```sh
rt init
```
and then uncomment the respective line with your favorite text editor.
To add more packages to your collection, see `?rupdate` for a format description of this file.
Note that packages with a git source will be kept in `~/.rt/git` and only reinstalled if the remote repository has been updated.

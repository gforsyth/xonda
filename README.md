# xonda

This is a thin wrapper around `conda` for use with
[xonsh](http://xon.sh)

It provides tab completion for most features and also will tab-complete
activate/select calls for environments.

## Prerequisites

Xonda requires that `conda` is already installed and importable from
xonsh (i.e., `import conda` works). In practice, this probably means
that you need to have installed `xonsh` from `conda` (or at least within
your current `conda` environment).

You also should have the `conda` `bin/` directory prefixed to your
`$PATH`.

Recent versions of `conda` suggest to not add the base `conda` `bin/`
directory to your path -- for now, please ignore this suggestion and do
prefix it to your `$PATH` or `xonda` will not work as expected.

## Installation

Just do a 

```console 
pip install xonda
```

or 

```console 
conda install xonda -c conda-forge 
```

or you can clone the repo and do 

```console 
pip install .  
```

## Configuration 

To automatically load xonda at startup, put 

```console
xontrib load xonda 
```

in your `.xonshrc`

## Usage

Xonda will automatically alias itself as `conda`, so you should not see
any differences.

If `xonda` is installed and activated via
`xontrib load xonda` then `which conda` should
return the alias name "conda" only, instead of
the path to the actual `conda` executable

**Right**

```console
$ which conda
conda
```

**Wrong** (or at least, not activated)

```console
$ which conda
/home/user/miniconda3/bin/conda
```

### Basic commands

Everything should work the way `conda` always does. So just use it as
you usually do.  

```console 
conda install -c conda-forge xonsh 
```

```console 
conda remove python=2.7 
```

### Environment activation 
`xonda` provides TAB-completion for conda environments, so you don't have to
keep double-checking. Also, no more `source activate` nonsense. To see a list of
available environments, type

```console 
conda activate <TAB> 
```

To deactivate, simply type

```console 
conda deactivate 
```

Isn't that simpler?

If you are already within an environment and `activate` a separate environment,
`xonda` will do you the favor of first deactivating the currently active
environment.

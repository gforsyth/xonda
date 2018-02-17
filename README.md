# xonda

This is a thin wrapper around `conda` for use with [xonsh](http://xon.sh)

It provides tab completion for most features and also will tab-complete activate/select calls for environments.

## Prerequisites

Xonda requries that conda is already installed and importable from xonsh (i.e.,
`import conda` works). In practice, this probably means that you need to have
installed xonsh from conda.

You also should have the conda bin directory prefixed to your path, per the
conda installation instruction.

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

Xonda will automatically alias itself as `conda`, so you should not see any
differences.

(If you prefer it not to do that, remove the alias in your
`.xonshrc`. Then, use as you would use `conda`, but just write `xonda` instead.)

### Basic commands

Everything should work the way `conda` always does. So just use it as you usually do.
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

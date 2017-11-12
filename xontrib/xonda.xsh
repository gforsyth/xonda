import os
import subprocess
import conda.install as ci
from conda import config
from collections import namedtuple


def _list_dirs(path):
    """
    Generator that lists the directories in a given path.
    """
    for entry in os.scandir(path):
        if not entry.name.startswith('.') and entry.is_dir():
            yield entry.name

def _get_envs():
    """
    Grab a list of all conda env dirs from conda.
    """
    # create a named tuple for self-documenting code
    Env = namedtuple('Env', ['name', 'path', 'bin_dir', 'envs_dir'])

    # create the list of envrionments
    env_list = list()
    for envs_dir in config.envs_dirs:
        # skip non-existing environments directories
        if not os.path.exists(envs_dir):
            continue
        # for each environment in the environments directory
        for env_name in _list_dirs(envs_dir):
            # check for duplicates names
            if env_name in [env.name for env in env_list]:
                raise ValueError('Multiple environments with the same name '
                                 'in the system is not supported by xonda.')
            # add the environment to the list
            env_list.append(Env(
                name=env_name,
                path=os.path.join(envs_dir, env_name),
                bin_dir=os.path.join(envs_dir, env_name, 'bin'),
                envs_dir=envs_dir,
            ))

    return env_list


def _pick_env(env_name):
    """
    Select an environment from the detected environments or from another path.
    """
    if env_name in [env.name for env in _get_envs()]:
        # get the environment
        env = next(e for e in _get_envs() if e.name == env_name)
        return env
    elif os.path.exists(env_name) and "bin" in _list_dirs(env_name):
        # if the environment name is non-stamdard path, i.e. found in
        # the envs_dir, make sure it contains a bin directory
        envs_dir, env_name = os.path.split(env_name.rstrip(os.path.sep))

        # create a named tuple for self-documenting code
        Env = namedtuple('Env', ['name', 'path', 'bin_dir', 'envs_dir'])
        env = Env(
            name=env_name,
            path=os.path.join(envs_dir, env_name),
            bin_dir=os.path.join(envs_dir, env_name, 'bin'),
            envs_dir=envs_dir,
            )
        # add the custom path to the envs_dirs so that the environment can
        # be deactivated again.
        if envs_dir not in config.envs_dirs:
            # extend envs_dirs tuple in config
            config.envs_dirs += (envs_dir,)
        return env
    else:
        return False


def _activate(env_name):
    """
    Activate an existing conda directory.  If a non-root directory
    is already active, _deactivate it first.  Also install a conda
    symlink if not present.
    """
    env = _pick_env(env_name)
    if env:
        # disable any currently enabled env
        try:
            if $CONDA_DEFAULT_ENV:
                _deactivate()
        except KeyError:
            pass
        # make sure `conda` points at the right env
        $CONDA_DEFAULT_ENV = env.name
        # add the environment's bin dir in $PATH
        if env.bin_dir not in $PATH:
            $PATH.insert(0, env.bin_dir)
        # ensure conda symlink exists in directory
        ci.symlink_conda(env.path, config.default_prefix)
    else:
        print("No environment '{}' found".format(env_name))


def _deactivate():
    """
    Deactivate the current environment and return to the default
    """
    # get the environment for the conda environment variable
    env = next(e for e in _get_envs() if e.name == $CONDA_DEFAULT_ENV)
    # remove the environment's bin directory from $PATH
    if env.bin_dir in $PATH:
        $PATH.remove(env.bin_dir)
    # remove the conda environment variable
    del $CONDA_DEFAULT_ENV


def _xonda(args, stdin=None):
    """
    If command is neither _activate nor _deactivate, just shell out to conda"""
    if len(args) == 2 and args[0] in ['activate', 'select']:
        _activate(args[1])
    elif len(args) == 1 and args[0] is 'deactivate':
        _deactivate()
    elif len(args) > 0:
        @$(which -s conda) @(args)
    elif len(args) == 0:
        @$(which -s conda) -h
    else:
        return

def _xonda_completer(prefix, line, start, end, ctx):
    """
    Completion for `xonda`
    """
    args = line.split(' ')
    possible = set()
    if len(args) == 0 or args[0] not in ['xonda', 'conda']:
        return None
    curix = args.index(prefix)
    if curix == 1:
        possible = {'activate', 'deactivate', 'install', 'remove', 'info',
                    'help', 'list', 'search', 'update', 'upgrade', 'uninstall',
                    'config', 'init', 'clean', 'package', 'bundle', 'env',
                    'select', 'create'}

    elif curix == 2:
        if args[1] in ['activate', 'select']:
            possible = set([env.name for env in _get_envs()])
        elif args[1] == 'create':
            possible = {'-p', '-n'}
        elif args[1] == 'env':
            possible = {'attach', 'create', 'export', 'list', 'remove',
                        'upload', 'update'}

    elif curix == 3:
        if args[2] == 'export':
            possible = {'-n', '--name'}

    elif curix == 4:
        if args[2] == 'export' and args[3] in ['-n','--name']:
            possible = set([env.name for env in _get_envs()])

    return {i for i in possible if i.startswith(prefix)}

aliases['conda'] = _xonda

# add _xonda_completer to list of completers
__xonsh_completers__['xonda'] = _xonda_completer
# bump to top of list
__xonsh_completers__.move_to_end('xonda', last=False)

import os
import subprocess
import conda.install
from conda import config
import functools
import builtins


@functools.lru_cache(1)
def get_envs():
    """
    Grab a list of all conda env dirs from conda
    (for now only supports main directory)
    """
    envs = config.envs_dirs
    return [env for env in $(ls @(envs[0])).split('\n')[:-1]]

    return env_list


def activate(env):
    """
    Activate an existing conda directory.  If a non-root directory
    is already active, deactivate it first.  Also install a conda
    symlink if not present
    """
    if env in get_envs():
        # disable any currently enabled env
        try:
            if $CONDA_DEFAULT_ENV:
                deactivate()
        except KeyError:
            pass
        # make sure `conda` points at the right env
        $CONDA_DEFAULT_ENV = env
        base_dir = os.path.join(config.default_prefix, 'envs')
        bin_dir = os.path.join(base_dir, env, 'bin')
        try:
            index = $PATH.index(os.path.join(config.default_prefix, 'bin'))
            $PATH[index] = bin_dir
        except ValueError:
            pass
        # ensure conda symlink exists in directory
        conda.install.symlink_conda(os.path.join(base_dir, env),
                                    config.default_prefix,
                                    $SHELL)
    else:
        print("No environment '{}' found".format(env))


def deactivate():
    """
    Deactivate the current environment and return to the default
    """
    try:
        index = $PATH.index(os.path.join(config.default_prefix,
                                  'envs',
                                  $CONDA_DEFAULT_ENV,
                                  'bin'))
        $PATH[index] = os.path.join(config.default_prefix, 'bin')
        del $CONDA_DEFAULT_ENV
    except ValueError:
        pass


def _xonda(args, stdin=None):
    """
    If command is neither activate nor deactivate, just shell out to conda"""
    if len(args) == 2 and args[0] in ['activate', 'select']:
        activate(args[1])
    elif len(args) == 1 and args[0] is 'deactivate':
        deactivate()
    elif len(args) > 0:
        subprocess.call(['conda'] + args,
                                env=builtins.__xonsh_env__.detype())
    else:
        return

def xonda_completer(prefix, line, start, end, ctx):
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
                    'select'}

    elif curix == 2:
        if args[1] in ['activate', 'select']:
            possible = set(get_envs())
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
            possible = set(get_envs())

    return {i for i in possible if i.startswith(prefix)}

aliases['conda'] = _xonda

# add xonda_completer to list of completers
__xonsh_completers__['xonda'] = xonda_completer
# bump to top of list
__xonsh_completers__.move_to_end('xonda', last=False)

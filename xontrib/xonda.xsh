import os
import builtins
import subprocess
import conda.install
from conda import config
import functools

@functools.lru_cache(1)
def get_envs():
    envs = config.envs_dirs
    return [env for env in $(ls @(envs[0])).split('\n')[:-1]]

    return env_list

def activate(env):
    if env in get_envs():
        $CONDA_DEFAULT_ENV = env
        #symlink
        base_dir = os.path.join(config.default_prefix, 'envs')
        bin_dir = os.path.join(base_dir, env, 'bin')
        $PATH.insert(0, bin_dir)
        try:
            $PATH.remove(os.path.join(config.default_prefix, 'bin'))
        except ValueError:
            pass
    else:
        print("No environment '{}' found".format(env))

def deactivate():
    try:
        $PATH.remove(os.path.join(config.default_prefix,
                                  'envs',
                                  $CONDA_DEFAULT_ENV,
                                  'bin'))
        del $CONDA_DEFAULT_ENV
    except ValueError:
        pass

def _xonda(args, stdin=None):
    if len(args) == 2 and args[0] is 'activate':
        activate(args[1])
    elif len(args) == 1 and args[0] is 'deactivate':
        deactivate()
    elif len(args) > 0:
        subprocess.check_output(['conda'] + args,
                                env=builtins.__xonsh_env__.detype())
    else:
        return

aliases['xonda'] = _xonda

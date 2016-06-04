from prompt_toolkit.contrib.completers import WordCompleter
from prompt_toolkit.validation import Validator, ValidationError
from prompt_toolkit import prompt
import os


class EnvValidator(Validator):
    def __init__(self, conda_dir, env_dir):
        self.conda_dir = conda_dir
        self.env_dir = env_dir

    def validate(self, document):
        text = document.text

        choices = [self.conda_dir]
        for i in $(ls @(self.env_dir)).split(sep='\n')[:-1]:
            choices.append('{}'.format(i))

        if text not in choices:
            raise ValidationError(message='Invalid environment',
                                  cursor_position=len(text))


def adjust_path(python, pos=0, insert=False):
    """
    Replace a bin path in existing $PATH at given position.
    Defaults to 0 (beginning of $PATH)
    If `insert` is set to `True`, then insert (rather than replace)
    the new python PATH before `pos`
    """
    if insert:
        $PATH.insert(pos, python)
    else:
        $PATH[pos]='{}/bin'.format(python)

def display_env_in_prompt(pythonpath, base_name):
    """
    Grabs the env name from the path and displays is to the
    left of $PROMPT to cue that the env is active
    """
    env_name = pythonpath.rsplit('/',1)[1]
    if env_name == base_name:
        $PROMPT = ('{BOLD_GREEN}{user}@{hostname}{BOLD_BLUE} '
                           '{cwd}{branch_color}{curr_branch} '
                          '{BOLD_BLUE}{prompt_end}{NO_COLOR} ')
    else:
        $PROMPT = ('('+env_name+')'+
                        '{BOLD_GREEN}{user}@{hostname}{BOLD_BLUE}'
                        '{cwd}{branch_color}{curr_branch}'
                        '{BOLD_BLUE}{prompt_end}{NO_COLOR} ')

def update_conda_alias(pythonpath, base_name):
    """
    Updates the CONDA_DEFAULT_ENV ENVVAR so `conda install` knows
	which env to install to
    """
    env_name = pythonpath.rsplit('/',1)[1]
    if env_name == base_name:
        del $CONDA_DEFAULT_ENV
    else:
        $CONDA_DEFAULT_ENV=env_name

def main(args, stdin=None):
    #$WORKON_HOME points to ~/(anaconda|miniconda3)/env)
    if not 'WORKON_HOME' in ${...}:
        do_find = input(
            '`$WORKON_HOME` is not defined.  It should point at\n'
            'the `env` subdirectory within your conda folder.  \n'
            'Would you like me to to try to find it? (y/n): '
        )
        if do_find in ('Y', 'y'):
            find_env_dir()
        else:
            return

    env_dir = $WORKON_HOME
    conda_dir = $WORKON_HOME.rsplit('/',1)[0]
    base_name = $WORKON_HOME.rsplit('/',2)[1]

    choices = [conda_dir]
    for i in $(ls @(env_dir)).split(sep='\n')[:-1]:
        choices.append('{}'.format(i))

    choice_completer = WordCompleter(choices)

    choice = prompt('Choose a conda environment (TAB to view all): ',
                    completer=choice_completer,
                    complete_while_typing=True,
                    validator=EnvValidator(conda_dir, env_dir))

    if choice != conda_dir:
        choice = os.path.join(env_dir, choice)
    adjust_path(choice)
    display_env_in_prompt(choice, base_name)
    update_conda_alias(choice, base_name)

aliases['xonda'] = main

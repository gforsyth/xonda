from xonda import get_envs

def xonda_completer(prefix, line, start, end, ctx):
    """
    Completion for `xonda`
    """
    args = line.split(' ')
    if len(args) == 0 or args[0] != 'xonda':
        return None
    curix = args.index(prefix)
    if curix == 1:
        possible = {'activate', 'deactivate', 'install', 'remove', 'info',
                    'help', 'list', 'search', 'update', 'upgrade', 'uninstall',
                    'config', 'init', 'clean', 'package', 'bundle', 'env'}
    elif curix == 2:
        if args[1] == 'activate':
            possible = set(get_envs())
        elif args[1] == 'create':
            possible = {'-p', '-n'}
        elif args[1] == 'env':
            possible = {'attach', 'create', 'export', 'list', 'remove',
                        'upload', 'update'}

    return {i for i in comp_list if i.startswith(query)}

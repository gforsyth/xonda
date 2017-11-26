import sys

from xonsh.imphooks import XonshImportHook

sys.meta_path.append(XonshImportHook())
sys.path.append('./xontrib')
sys.path.append('../xontrib')

import xonda


def test_list_dirs(tmpdir):
    """Dont return hidden dirs when listing"""
    p = tmpdir.mkdir("sub")
    p = tmpdir.mkdir("another")
    p = tmpdir.mkdir(".dotname")

    env_dirs = xonda._list_dirs(tmpdir)

    assert len(tmpdir.listdir()) == 3

    assert len(list(env_dirs)) == 2

import sys

from xonsh.imphooks import XonshImportHook

sys.meta_path.append(XonshImportHook())
sys.path.append('./xontrib')
sys.path.append('../xontrib')


def test_import():
    import xonda
    assert True

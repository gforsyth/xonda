$PROJECT = 'xonda'
$ACTIVITIES = ['version_bump', 'changelog', 'tag', 'conda_forge', 'ghrelease']

$VERSION_BUMP_PATTERNS = [
    ('setup.py', 'version\s*=.*,', "version='$VERSION',")
    ]
$CHANGELOG_FILENAME = 'CHANGELOG.rst'
$CHANGELOG_IGNORE = ['TEMPLATE.rst']
$TAG_REMOTE = 'git@github.com:gforsyth/xonda.git'

$GITHUB_ORG = 'gforsyth'
$GITHUB_REPO = 'xonda'

# cron-git

A Docker image that clone and periodically pull a git repository.

## Usage

```sh
$ docker run --rm arslivinski/cron-git --help

usage:
    docker run [docker-options] arslivinski/cron-git [options] <repository>

description:
    A Docker image that clone and periodically pull a Git repository.

options:
    --crontab, -c:
        A crontab expression that defines the peridiocity of the repository
        pulling. Default "* * * * *".
    --directory, -d:
        The directory where the repository will be cloned. If not set, the last
        segment of the repository\'s URL will be used. WARNING: The contents of
        the destination directory will be removed.
    --clone-opts:
        Additional arguments to be used on git-clone.
    --pull-opts:
        Additional arguments to be used on git-pull.
    --help, -h:
        Print this text.
    <repository>
        The repository's GIT URL.
```

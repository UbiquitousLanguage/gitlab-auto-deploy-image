# auto-deploy-image

The [Auto-DevOps](https://docs.gitlab.com/ee/topics/autodevops/) [deploy stage](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml) image.


## Development

Scripts in this repository follow GitLab's
[shell scripting guide](https://docs.gitlab.com/ee/development/shell_scripting_guide/)
and enforces `shellcheck` and `shfmt`.

## Contributing and Code of Conduct

Please see [CONTRIBUTING.md](CONTRIBUTING.md)

## Upgrading

### v0.1.0

Starting from GitLab 12.2, the [`Jobs/Deploy.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml)
template will use the Docker image generated from this project. Changes from previous version of `Jobs/Deploy.gitlab-ci.yml` include:

* Switch from using `sh` to `bash`.
* `install_dependencies` is removed as it is now part of the Docker image.
*  All the other commands should be prepended with `auto-deploy`.
   For example, `check_kube_domain` now becomes `auto-deploy check_kube_domain`.

# Generating a new auto-deploy image

To generate a new image you must follow the git commit guidelines below, this
will trigger a semantic version bump which will then cause a new pipeline
that will build and tag the new image

## Git Commit Guidelines

This project uses [Semantic Versioning](https://semver.org). We use commit
messages to automatically determine the version bumps, so they should adhere to
the conventions of [Conventional Commits (v1.0.0-beta.2)](https://www.conventionalcommits.org/en/v1.0.0-beta.2/).

### TL;DR

- Commit messages starting with `fix: ` trigger a patch version bump
- Commit messages starting with `feat: ` trigger a minor version bump
- Commit messages starting with `BREAKING CHANGE: ` trigger a major version bump.

## Automatic versioning

Each push to `master` triggers a [`semantic-release`](https://semantic-release.gitbook.io/semantic-release/)
CI job that determines and pushes a new version tag (if any) based on the
last version tagged and the new commits pushed. Notice that this means that if a
Merge Request contains, for example, several `feat: ` commits, only one minor
version bump will occur on merge. If your Merge Request includes several commits
you may prefer to ignore the prefix on each individual commit and instead add
an empty commit summarizing your changes like so:

```
git commit --allow-empty -m '[BREAKING CHANGE|feat|fix]: <changelog summary message>'
```

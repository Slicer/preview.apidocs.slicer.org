# Slicer API documentation (preview)

This project hosts the Slicer API documentation served from http://preview.apidocs.slicer.org


## Automatic generation

Documentation is automatically generated and pushed to the `gh-pages` branch configured as a [GitHub Pages](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/) source.

The [slicer-apidocs-builder](https://github.com/Slicer/slicer-apidocs-builder) tool is used within a CircleCI
build to checkout Slicer source code, build doxygen documentation and publish generated html pages.

Each time a PR is submitted on https://github.com/Slicer/Slicer, the generated
documentation is added to a folder named after the pull request and pushed to
the `gh-pages` branch.

The simple GitHub post-receive web hook handler triggering a CircleCI build is
[github-circleci-trigger](https://github.com/Slicer/github-circleci-trigger). It is implemented as
a Flask application hosted on a free heroku instance.

## Reset of `gh-pages` branch using TravisCI Cron Job

After some time, the amount of data published on the `gh-pages` branch exceeds GitHub [recommended size of 1GB][max_size].
To cleanup the repository, a [TravisCI Cron Job][cronjob] associated with this project
will be triggered weekly and will execute [gh-pages-reset.sh](./gh-pages-reset.sh) script.

The script simply push force the branch `gh-pages-reset` onto `gh-pages`.

Last TravisCI Cron Job: [![Build Status][travis_img]][travis]

[max_size]: https://help.github.com/articles/what-is-my-disk-quota/
[cronjob]: https://docs.travis-ci.com/user/cron-jobs/
[travis]: https://travis-ci.org/Slicer/preview.apidocs.slicer.org
[travis_img]: https://travis-ci.org/Slicer/preview.apidocs.slicer.org.svg?branch=master


## Programmatically request updates of `gh-pages` branch using TravisCI API

### Prequisites

* Install Travis client

```
# Install travis client
curl https://raw.githubusercontent.com/jcfr/docker-travis-cli/master/travis-cli.sh \
  -o ~/bin/travis-cli && \
chmod +x ~/bin/travis-cli
```

* Generate GitHub token - See [here](https://github.com/settings/tokens)

### Reset *gh-pages*

*This is useful to debug the TravisCI Cron Jobs without having to wait.*

```
GITHUB_TOKEN=<YOUR_GITHUB_TOKEN> ./trigger-travis-reset.sh reset
```


### Update *gh-pages* index.html merging `gh-pages-reset`

*When cosmetic changes are done to the top-level page, this action allows to merge the
updates pushed to `gh-pages-reset` into `gh-pages`.*

```
GITHUB_TOKEN=<YOUR_GITHUB_TOKEN> ./trigger-travis-reset.sh merge
```



# license

It is covered by the Slicer License:

https://github.com/Slicer/preview.apidocs.slicer.org/blob/master/License.txt



# Slicer API documentation (preview)

This project hosts the Slicer API documentation served from http://preview.apidocs.slicer.org

## Automatic generation

Documentation is automatically generated and pushed to the `gh-pages` branch configured as a [GitHub Pages](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/) source.

For more details, see https://github.com/Slicer/slicer-apidocs-builder

## Reset gh-pages branch using TravisCI Cron Job

Each time a PR is submitted on https://github.com/Slicer/Slicer, the generated
documentation is added to a folder named after the pull request and pushed to
the `gh-pages`.

After some time, the amount of data exceeds GitHub [recommended size of 1GB][max_size].
To cleanup the repository, a [TravisCI Cron Job][cronjob] associated with this project
will be triggered weekly and will execute [gh-pages-reset.sh](./gh-pages-reset.sh) script.

The script simply push force the branch `gh-pages-reset` onto `gh-pages`.

[max_size]: https://help.github.com/articles/what-is-my-disk-quota/
[cronjob]: https://docs.travis-ci.com/user/cron-jobs/

## Programmatically request a *gh-pages reset* using TravisCI API

*This is useful to debug the TravisCI Cron Jobs witout having to wait.* 

* Install Travis client
```
# Install travis client
curl https://raw.githubusercontent.com/jcfr/docker-travis-cli/master/travis-cli.sh \
  -o ~/bin/travis-cli && \
chmod +x ~/bin/travis-cli
```

* Generate GitHub token - See [here](https://github.com/settings/tokens)

* Trigger reset

```
GITHUB_TOKEN=<YOUR_GITHUB_TOKEN> ./trigger-travis-cron.sh
```

# license

It is covered by the Slicer License:

https://github.com/Slicer/preview.apidocs.slicer.org/blob/master/License.txt



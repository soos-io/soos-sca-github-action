# SOOS Action

A [GitHub Action](https://github.com/features/actions) for using [SOOS](https://soos.io) to check for
vulnerabilities in your projects.

**NOTE** This read-me describes GitHub actions for private repos that intend to house the files themselves. This read-me does not describe how to use the GitHub action after it's published to the GitHub marketplace.

You can use the Action as follows:

**FILE:** YOUR_REPO/.github/workflow/main.yml

```yaml
name: Example workflow using SOOS
# Events required to engage workflow (add/edit this list as needed)
on: push
jobs:
  synchronous-analysis-with-blocking-result:
    name: SOOS Scan
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@master

    - name: Run SOOS - Scan for vulnerabilities
      uses: SOOS/actions/github-action@main
      with:
        project_name: "My Project Name"
      env:
        # Visit https://soos.io to get the required tokens to leverage SOOS scanning/analysis services
        SOOS_CLIENT_ID: ${{ secrets.SOOS_CLIENT_ID }}
        SOOS_API_KEY: ${{ secrets.SOOS_API_KEY }}
        
```

Other Files:

**LOCATION:** YOUR_REPO/github-action/

| Filename | Purpose |
| --- | --- |
| Dockerfile | The Dockerfile used to execute the action logic |
| entrypoint.sh | The business logic that is called by Dockerfile and preps the build with files and dependencies needed to execute the script |
| action.yml | Called by main.yml and initiates the setup of variables, passing them through a Docker instance that it creates. |

The SOOS Action has properties which are passed to the action using `with`.

| Property | Default | Description |
| --- | --- | --- |
| base_uri | "https://api.soos.io/api/"  | The API BASE URI provided to you when subscribing to SOOS services. |
| project_name | [none]  | REQUIRED. A custom project name that will present itself as a collection of test results within your soos.io dashboard. |
| directories_to_exclude | ""  | List (comma separated) of directories (relative to ./) to exclude from the search for manifest files. Example - Correct: bin/start/ ... Example - Incorrect: ./bin/start/ ... Example - Incorrect: /bin/start/'|
| files_to_exclude | "" | List (comma separated) of files (relative to ./) to exclude from the search for manifest files. Example - Correct: bin/start/manifest.txt ... Example - Incorrect: ./bin/start/manifest.txt ... Example - Incorrect: /bin/start/manifest.txt' |
| analysis_result_max_wait | 300 | Maximum seconds to wait for Analysis Result before exiting with error. |
| analysis_result_polling_interval | 10 | Polling interval (in seconds) for analysis result completion (success/failure.). Min 10. |
| debug_print_variables | false | Enables printing of input/environment variables within the docker container. |
| commit_hash | [none] | The commit hash value from the SCM System |
| branch_name | [none] | The name of the branch from the SCM System |
| branch_uri | [none] | The URI to the branch from the SCM System |
| build_version | [none] | Version of application build artifacts |
| build_uri | [none] | URI to CI build info |
| operating_environment | [none] | System info regarding operating system, etc. |

The SOOS Action has environment variables which are passed to the action using `env`. These environment variables are stored as repo `secrets` and are required for the action to operate.

| Property | Description |
| --- | --- |
| SOOS_CLIENT_ID | Provided to you when subscribing to SOOS services. |
| SOOS_API_KEY | Provided to you when subscribing to SOOS services. |


For example, you can choose to exclude specific directories from scanning:

*YOUR_REPO/.github/workflow/main.yml*
```yaml
name: Example workflow using SOOS
on: push
jobs:
  synchronous-analysis-with-blocking-result:
    name: SOOS Scan
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@master

    - name: Run SOOS - Scan for vulnerabilities
      uses: SOOS/actions/github-action@main
      with:
        project_name: "My Project Name"
        directories_to_exclude: "custom/bin/, custom/etc/bin/"
    env:
        # Visit https://soos.io to get the required tokens to leverage SOOS scanning/analysis services
        SOOS_CLIENT_ID: ${{ secrets.SOOS_CLIENT_ID }}
        SOOS_API_KEY: ${{ secrets.SOOS_API_KEY }}
```



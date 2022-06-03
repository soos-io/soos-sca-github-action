# SOOS Core SCA

Scan your software for **vulnerabilities** and **license issues**.  Generate **SBOMs**. 

Use **SOOS Core SCA** to:

1. Find, fix and monitor known **vulnerabilities**
2. Review open source **license usage** within your project
3. Track tickets in **Jira** or **GitHub** Issues
4. Generate an **SBOM** 

## Supported Languages and Package Managers

* [Cargo - Rust](https://doc.rust-lang.org/cargo/)
* [Composer - PHP](https://maven.apache.org/)
* [Dart PM (Pub Package Manager) - Dart](https://pub.dev/)
* [Gradle - Java & Kotlin](https://gradle.org/)
* [Homebrew - (various languages)](https://brew.sh/)
* [Maven - Java](https://maven.apache.org/)
* [Mix - Elixir](https://hexdocs.pm/mix/Mix.html)
* [NuGet - .NET](https://www.nuget.org/)
* [NPM (Node Package Manager) - Node](https://www.npmjs.com/)
* [PyPI - Python](https://pypi.org/)
* [Rebar3 - Erlang](https://rebar3.readme.io/docs/getting-started)
* [Ruby Gems - Ruby](https://rubygems.org/)

## How to use it:

You can use the Action as follows:

- Update the `.github/workflow/main.yml`file to include a step like this:
```yaml
 - name: Run SOOS SCA Scan for vulnerabilities
   uses: soos-io/soos-sca-github-action@vX.Y.Z # Get Latest Version from https://github.com/marketplace/actions/soos-core-sca
   with:
    project_name: "My Project Name"
    client_id: ${{ secrets.SOOS_CLIENT_ID }}
    api_key: ${{ secrets.SOOS_API_KEY }}
```
Example:
```yaml
name: Example workflow using SOOS
# Events required to engage workflow (add/edit this list as needed)
on: push
jobs:
  synchronous-analysis-with-blocking-result:
    name: SOOS SCA Scan
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@master

    - name: Run SOOS - Scan for vulnerabilities
      uses: soos-io/soos-sca-github-action@<latest_version>
      with:
        project_name: "My Project Name"
        client_id: ${{ secrets.SOOS_CLIENT_ID }}
        api_key: ${{ secrets.SOOS_API_KEY }}
        
```

The `soos-io/soos-sca-github-action` Action has properties which are passed to the action using `with`.

| Property                         | Default                    | Description                                                                                                                                                                                                                                   |
|----------------------------------|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| client_id                         | [none] | The Client Id provided to you when subscribing to SOOS services.                                                                                                                                                                           |
| api_key                         | [none] | The Api Key provided to you when subscribing to SOOS services.                                                                                                                                                                           |
| api_url                         | "https://api.soos.io/api/" | The API BASE URI provided to you when subscribing to SOOS services.                                                                                                                                                                           |
| project_name                     | [none]                     | REQUIRED. A custom project name that will present itself as a collection of test results within your soos.io dashboard. For SARIF Report, it should be `{repository_owner}/{repository_name}`                                                 |
| directories_to_exclude           | ""                         | List (comma separated) of directories (relative to ./) to exclude from the search for manifest files. Example - Correct: bin/start/ ... Example - Incorrect: ./bin/start/ ... Example - Incorrect: /bin/start/'                               |
| files_to_exclude                 | ""                         | List (comma separated) of files (relative to ./) to exclude from the search for manifest files. Example - Correct: bin/start/manifest.txt ... Example - Incorrect: ./bin/start/manifest.txt ... Example - Incorrect: /bin/start/manifest.txt' |
| analysis_result_max_wait         | 300                        | Maximum seconds to wait for Analysis Result before exiting with error.                                                                                                                                                                        |
| analysis_result_polling_interval | 10                         | Polling interval (in seconds) for analysis result completion (success/failure.). Min 10.                                                                                                                                                      |
| debug_print_variables            | false                      | Enables printing of input/environment variables within the docker container.                                                                                                                                                                  |
| branch_uri                       | [none]                     | The URI to the branch from the SCM System                                                                                                                                                                                                     |
| build_version                    | [none]                     | Version of application build artifacts                                                                                                                                                                                                        |
| build_uri                        | [none]                     | URI to CI build info                                                                                                                                                                                                                          |
| operating_environment            | [none]                     | System info regarding operating system, etc.                                                                                                                                                                                                  |
| sarif                            | false                      | Enable Uploading the SARIF Report to GitHub.                                                                                                                                                                                                  |
| gpat                             | [none]                     | GitHub Personal Access Token. Required to upload SARIF Report                                                                                                                                                                                 |

For example, you can choose to exclude specific directories from scanning:

`.github/workflow/main.yml`:
```yaml
name: Example workflow using SOOS
on: 
  push:
    branches: 
      - main 
    paths:
      - package.json
jobs:
  synchronous-analysis-with-blocking-result:
    name: SOOS SCA Scan
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@master

    - name: Run SOOS - Scan for vulnerabilities
      uses: soos-io/soos-sca-github-action@<latest_version>
      with:
        project_name: "My Project Name"
        directories_to_exclude: "custom/bin/, custom/etc/bin/"
        client_id: ${{ secrets.SOOS_CLIENT_ID }}
        api_key: ${{ secrets.SOOS_API_KEY }}
```

### SARIF Report Example

`.github/workflow/main.yml`:
``` yaml
# This is a basic workflow to help you get started with Actions
name: SOOS SCA SARIF Example CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v3

      # Runs a single command using the runners shell
      - name: SOOS SCA Analysis
        uses: soos-io/soos-sca-github-action@<latest_version>
        with:
          project_name: "<repository_owner>/<repository_name>" # Also you can use the var ${{ github.repository }}
          sarif: "true"
          gpat: ${{ secrets.GITHUB_PERSONAL_ACCESS_TOKEN }}
          client_id: ${{ secrets.SOOS_CLIENT_ID }}
          api_key: ${{ secrets.SOOS_API_KEY }}
```

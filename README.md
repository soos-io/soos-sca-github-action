# [SOOS Core SCA](https://soos.io/sca-product)

SOOS is an independent software security company, located in Winooski, VT USA, building security software for your team. [SOOS, Software security, simplified](https://soos.io).

Use SOOS to scan your software for [vulnerabilities](https://app.soos.io/research/vulnerabilities) and [open source license](https://app.soos.io/research/licenses) issues with [SOOS Core SCA](https://soos.io/sca-product). [Generate SBOMs](https://kb.soos.io/help/soos-reports-for-export). Govern your open source dependencies. Run the [SOOS DAST vulnerability scanner](https://soos.io/dast-product) against your web apps or APIs.

[Demo SOOS](https://app.soos.io/demo) or [Register for a Free Trial](https://app.soos.io/register).

If you maintain an Open Source project, sign up for the Free as in Beer [SOOS Community Edition](https://soos.io/products/community-edition).

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
* [Go Modules - Go (GoLang)](https://pkg.go.dev/)

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

| Property | Description | Default |
| --- | --- | --- |
| client_id | SOOS Client Id |
| api_key | SOOS API Key |
| api_url | SOOS API URL | https://api.soos.io/api/ |
| project_name | The project name that will be displayed on the dashboard. By Default is owner/repository_name | ${{ github.repository }} |
| mode | The scan mode for the analysis: run_and_wait, async_init, and async_result | run_and_wait |
| on_failure | Set the On Failure Scan Strategy: fail_the_build, and continue_on_failure | continue_on_failure |
| directories_to_exclude | Directories to Exclude: Listing of directories (relative to ./) to exclude from the search for manifest files. Example - Correct: bin/start/  Example - Incorrect: ./bin/start/ Example - Incorrect: /bin/start |  |
| files_to_exclude | Files to Exclude: Listing of files (relative to ./) to exclude from the search for manifest files. Example - Correct: bin/start/requirements.txt ... Example - Incorrect: ./bin/start/requirements.txt ... Example - Incorrect: /bin/start/requirements.txt |  |
| analysis_result_max_wait | Maximum seconds to wait for Analysis Result. | 300 |
| analysis_result_polling_interval | Polling interval (in seconds) for analysis result completion (success/failure). Min value 10 seconds. | 10 |
| debug_print_variables | Enables printing of input/environment variables within the docker container. | false |
| branch_uri | URI to branch from SCM system. |  |
| build_version | Version of application build artifacts. |  |
| build_uri | URI to CI build info. |  |
| operating_environment | System info regarding operating system, etc. | ${{ runner.os }} |
| sarif | Generate SARIF Report | false |
| gpat | Github Personal Access Token to upload SARIF Report. |  |
| package_managers | List (comma separated) of Package Managers to filter manifest search. (Dart, Erlang, Homebrew, PHP, Java, Nuget, NPM, Python, Ruby, Rust.) |  |
| verbosity | Set logging verbosity level value (INFO/DEBUG) | INFO |
| verbose | Enable verbose logging | false 

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

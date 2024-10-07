# [SOOS Core SCA](https://soos.io/sca-product)

SOOS is an independent software security company, located in Winooski, VT USA, building security software for your team. [SOOS, Software security, simplified](https://soos.io).

Use SOOS to scan your software for [vulnerabilities](https://app.soos.io/research/vulnerabilities) and [open source license](https://app.soos.io/research/licenses) issues with [SOOS Core SCA](https://soos.io/products/sca). [Generate and ingest SBOMs](https://soos.io/products/sbom-manager). [Export reports](https://kb.soos.io/help/soos-reports-for-export) to industry standards. Govern your open source dependencies. Run the [SOOS DAST vulnerability scanner](https://soos.io/products/dast) against your web apps or APIs. [Scan your Docker containers](https://soos.io/products/containers) for vulnerabilities. Check your source code for issues with [SAST Analysis](https://soos.io/products/sast).

[Demo SOOS](https://app.soos.io/demo) or [Register for a Free Trial](https://app.soos.io/register).

If you maintain an Open Source project, sign up for the Free as in Beer [SOOS Community Edition](https://soos.io/products/community-edition).

## Supported Languages and Package Managers
Our full list of supported manifest formats can be found [here](https://kb.soos.io/help/soos-languages-supported).

## How to use it:

You can use the Action as follows:

- Update the `.github/workflow/main.yml`file to include a step like this:
```yaml
 - name: Run SOOS SCA Scan for vulnerabilities
   uses: soos-io/soos-sca-github-action@v2 # Check the latest major version here: https://github.com/marketplace/actions/soos-core-sca
   with:
    project_name: "My Project Name"
    client_id: ${{ secrets.SOOS_CLIENT_ID }}
    api_key: ${{ secrets.SOOS_API_KEY }}
```

The `soos-io/soos-sca-github-action` Action has properties which are passed to the action using `with`.

| Property                | Description                                                     | Default |
|-------------------------|-----------------------------------------------------------------|---------|
| api_key                 | The Api Key provided to you when subscribing to SOOS services. |  |
| build_version           | Version of application build artifacts. |  |
| client_id               | The Client Id provided to you when subscribing to SOOS services. |  |
| directories_to_exclude  | Listing of directories or patterns to exclude from the search for manifest files. eg: **bin/start/**, **/start/** |  |
| files_to_exclude        | Listing of files or patterns patterns to exclude from the search for manifest files. eg: **/req**.txt/, **/requirements.txt |  |
| log_level               | Minimum level to show logs: PASS, IGNORE, INFO, WARN or FAIL. | INFO |
| on_failure              | Set the On Failure Scan Strategy: fail_the_build, and continue_on_failure | continue_on_failure |
| output_format           | Output format for vulnerabilities: only the value SARIF is available at the moment |  |
| package_managers        | A list of package managers, delimited by comma, to include when searching for manifest files. |  |
| project_name            | The project name that will be displayed on the dashboard. By Default is owner/repository_name | ${{ github.repository }} |

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
      uses: soos-io/soos-sca-github-action@v2
      with:
        project_name: "My Project Name"
        directories_to_exclude: "**bin/start/**, **/start/**"
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
        uses: soos-io/soos-sca-github-action@v2
        with:
          project_name: "<repository_owner>/<repository_name>" # Also you can use the var ${{ github.repository }}
          output_format: "sarif"
          client_id: ${{ secrets.SOOS_CLIENT_ID }}
          api_key: ${{ secrets.SOOS_API_KEY }}
```

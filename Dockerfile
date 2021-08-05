# Container image that runs your code
FROM python:3

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Install Python utilities
RUN pip install pip pipenv virtualenv -U && \
    apt-get update && \
    apt-get install -y build-essential curl git && \
    apt-get autoremove -y && \
    apt-get clean

RUN chmod 777 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Environment variable	Description
  #CI	Always set to true.
  #GITHUB_WORKFLOW	The name of the workflow.
  #GITHUB_RUN_ID	A unique number for each run within a repository. This number does not change if you re-run the workflow run.
  #GITHUB_RUN_NUMBER	A unique number for each run of a particular workflow in a repository. This number begins at 1 for the workflow's first run, and increments with each new run. This number does not change if you re-run the workflow run.
  #GITHUB_ACTION	The unique identifier (id) of the action.
  #GITHUB_ACTIONS	Always set to true when GitHub Actions is running the workflow. You can use this variable to differentiate when tests are being run locally or by GitHub Actions.
  #GITHUB_ACTOR	The name of the person or app that initiated the workflow. For example, octocat.
  #GITHUB_REPOSITORY	The owner and repository name. For example, octocat/Hello-World.
  #GITHUB_EVENT_NAME	The name of the webhook event that triggered the workflow.
  #GITHUB_EVENT_PATH	The path of the file with the complete webhook event payload. For example, /github/workflow/event.json.
  #GITHUB_WORKSPACE	The GitHub workspace directory path. The workspace directory is a copy of your repository if your workflow uses the actions/checkout action. If you don't use the actions/checkout action, the directory will be empty. For example, /home/runner/work/my-repo-name/my-repo-name.
  #GITHUB_SHA	The commit SHA that triggered the workflow. For example, ffac537e6cbbf934b08745a378932722df287a53.
  #GITHUB_REF	The branch or tag ref that triggered the workflow. For example, refs/heads/feature-branch-1. If neither a branch or tag is available for the event type, the variable will not exist.
  #GITHUB_HEAD_REF	Only set for forked repositories. The branch of the head repository.
  #GITHUB_BASE_REF	Only set for forked repositories. The branch of the base repository.
  #GITHUB_SERVER_URL	Returns the URL of the GitHub server. For example: https://github.com.
  #GITHUB_API_URL	Returns the API URL. For example: https://api.github.com.
  #GITHUB_GRAPHQL_URL	Returns the GraphQL API URL. For example: https://api.github.com/graphql.

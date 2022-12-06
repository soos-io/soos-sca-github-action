import requests
import os


try:
    print('-' * 106)
    print("Checking if your current version is up to date.")
    r = requests.get('https://api.github.com/repos/soos-io/soos-sca-github-action/releases/latest')
    latest_tag = r.json()['tag_name']
    current_tag = os.environ['GITHUB_ACTION_REF'].split('/')[-1]
    print(f"Your current version is: {current_tag}, The latest version is: {latest_tag}")
    if current_tag == latest_tag:
        print('This action is up to date.')
    else:
        print('This action is outdated. Please update to the latest version: ' + latest_tag)
except Exception as error:
    print('Failed to check for updates. Please check manually.')

print('-' * 106)
print(current_tag)

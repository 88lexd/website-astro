import requests
import os

GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')

# Repo expects string as <OWNER>/<REPO-NAME>
REPO = os.getenv('REPO')

HEAD_BRANCH = os.getenv('HEAD_BRANCH')
BASE_BRANCH = os.getenv('BASE_BRANCH')
PR_TITLE = os.getenv('PR_TITLE')
PR_BODY = os.getenv('PR_BODY')

# GitHub API URL
API_URL = f"https://api.github.com/repos/{REPO}/pulls"

# Headers
headers = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json",
}

payload = {
    "title": PR_TITLE,
    "head": HEAD_BRANCH,
    "base": BASE_BRANCH,
    "body": PR_BODY,
}

# Make the API call
response = requests.post(API_URL, json=payload, headers=headers)

if response.status_code == 201:
    print("Pull request created successfully!")
    print(f"Pull request URL: {response.json().get('html_url')}")
else:
    print("Failed to create pull request")
    print(f"Response: {response.json()}")

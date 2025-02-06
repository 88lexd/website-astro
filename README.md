# Website Powered by Astro
This is my [personal blog](https://lexdsolutions.com) that is powered on Astro and uses the [Blog Template](https://github.com/danielcgilibert/blog-template) by danielcgilibert.

## Dev Setup
The following are notes for myself on how I do development work on my machine.

### Git-Hooks
(one-time task) Setup `git-hooks` for conventional commit messages.
This will enforce me to follow proper commit messages which is then used to create release notes by the pipeline.
```bash
# Change dir into this repo
cd ~/code/git/website-astro

# Create the git-hook
tee .git/hooks/commit-msg <<EOF
#!/usr/bin/env python3
import re, sys, os

def main():
	# example:
	# feat(apikey): added the ability to add api key to configuration
	pattern = r'(build|ci|docs|feat|fix|perf|refactor|style|test|chore|revert)(\([\w\-]+\))?:\s.*'
	filename = sys.argv[1]
	ss = open(filename, 'r').read()
	m = re.match(pattern, ss)
	if m == None: raise Exception("conventional commit validation failed")

if __name__ == "__main__":
	main()
EOF

chmod u+x .git/hooks/commit-msg

# Debug - At one point, I had `core.hooksPath` pointing to `.husky`
# This should be resolved, but the following command fixed it
git config --local core.hooksPath .git/hooks
```

### Local Development
Use the following to start development

Start Container
```shell
# If required (in WSL)
sudo service docker start

cd ~/code/git/website-astro

# This will create start a container as an interactive shell. If I close it, it will stop the app
make dev

# To debug the container, use:
make dev-shell
```

Access web server
```shell
# Using WSL IP
$ ip a | grep eth0: -A3 | grep inet
    inet 172.30.49.60/20 brd 172.30.63.255 scope global eth0

# Using Windows portproxy
# On Admin PowerShell
PS> netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=80 connectaddress=172.30.49.60 connectport=80

# Check
netsh interface portproxy show all
```

### Test Production Build
I may want to test the production build locally before releasing.
```shell
cd ~/code/git/website-astro

docker build -t astro .

docker run --rm -it -p 80:80 astro
```
Then access the web server the same way as above.

## Deployment Workflow
When changes related to Astro are made and is merged into the main branch, the following happens:
- GitHub Actions triggers the release workflow.
	- Determines next semantic version
	- Build and push new container image to DockerHub using the version tag
	- Creates a release+tag on GitHub using the same version tag.
- ArgoCD Image Updater:
	- Detects that there is a new image
	- Creates a branch called `argo-cd-image-updater`, drops in the [updated Argo config](https://github.com/88lexd/website-astro/blob/main/infra/website-chart/.argocd-source-website-astro.yaml) and pushes it back to GitHub
	- GitHub Actions will pick up a push from this branch and creates a new Pull Request ([example PR](https://github.com/88lexd/website-astro/pull/26/files))
- Upon Merge Argo CD Image Updater PR on GitHub
	- Argo CD Application sync will pick up the change and will update the deployment/image to use the new version.


## Additional Changes
These changes were made on top of the base template:
- Upgraded Astro v3 -> v4
- Fixed sorting on landing page (prev was oldest to newest.. wrong way around)
- Added About page
- Added pagination
- Custom Categories
- Symlinks for blog and image page to root of repo
- Run as container with Dockerfile

## Other - Tech notes on changes
These are just some random notes for now..

I've updated Astro by running:
```
rm -rf node_modules/
pnpm up astro@4

# This updated the package.json, so next time it should always install v4 which has the symlink fix
```
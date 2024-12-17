# Website Powered by Astro
Blog is powered on Astro and uses the [Blog Template](https://github.com/danielcgilibert/blog-template) by danielcgilibert.

## Temp notes
Below are some draft notes taken while I test drive.

Start Container
```
sudo service docker start

# IMPORTANT: Change into the ROOT of this repo!
cd ~/code/git/website-astro

docker run --rm -v $(pwd):/app -p 80:4321 -it --entrypoint=bash node:18
```

Inside the container
```
cd /app/astro

npm install -g pnpm@latest-7
pnpm install && pnpm dev
```

Once its running, I can make changes and it will refresh the page automatically.

- Check WSL IP
    ```
    ip a | grep eth0: -A3 | grep inet
    inet 172.30.49.60/20 brd 172.30.63.255 scope global eth0
    ```

Access from mobile over wifi
```
# On Admin PowerShell
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=80 connectaddress=172.30.49.60 connectport=80

# Check
netsh interface portproxy show all
```

- Test from PC first (http://localhost)
- Test from phone (http://pc-ip)


## Running live
The follwing needs to be done at a high level

- Make changes to posts
- Build docker image (build and host app via Nginx)
- CI to push to repo
- CI to update deployment (private runner on GitHub?)

### Build notes.. random
Build production and host via Nginx


```
# Use the Dockerfile
docker build -t astro .

docker run --rm -it -p 80:80 astro
```

# Additional Changes
These changes were made on top of the base template:
- Upgraded Astro v3 -> v4
- Fixed sorting on landing page (prev was oldest to newest.. wrong way around)
- Added About page
- Added pagination
- Custom Categories
- Symlinks for blog and image page to root of repo
- Run as container with Dockerfile

## Tech notes on changes
I've updated Astro by running:
```
rm -rf node_modules/
pnpm up astro@4

# This updated the package.json, so next time it should always install v4 which has the symlink fix
```
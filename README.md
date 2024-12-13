# Website Powered by Astro
Blog is powered on Astro and uses the [Blog Template](https://github.com/danielcgilibert/blog-template) by danielcgilibert.

## Temp notes
Below are some draft notes taken while I test drive.

I've updated Astro by running:
```
rm -rf node_modules/
pnpm up astro@4

# This updated the package.json, so next time it should always install v4 which has the symlink fix
```

Start Container
```
sudo service docker start

# IMPORTANT: Change into the ROOT of this repo!
cd ~/code/git/website-astro

docker run --rm -v $(pwd):/app -p 8080:4321 -it --entrypoint=bash node:18
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

# Note: There seem to be a bug where the `about` and `tags` page is not working...
docker run -it -p 80:80 astro
```

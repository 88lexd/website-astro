# Symlinked Directory
These directories are symlinked from the following:

The actual symlink is like the following:
```shell
$ ls -l astro/src/content/blog
lrwxrwxrwx 1 alex alex 22 Dec 13 22:40 astro/src/content/blog -> ../../../contents/blog

$ ls -l astro/src/assets/images
lrwxrwxrwx 1 alex alex 24 Dec 13 22:42 astro/src/assets/images -> ../../../contents/images

```

This allows me to make changes to the blog content from the root dir instead of always going into the sub folders.

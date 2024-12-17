# Symlinked Directory
These directories are symlinked from the following:

The actual symlink is like the following:
```shell
# Add blog pages here
$ ls -l astro/src/content/blog
lrwxrwxrwx 1 alex alex 22 Dec 13 22:40 astro/src/content/blog -> ../../../contents/blog

# Images references by the blog post, cannot be accessed using public link
$ ls -l astro/src/assets/images
lrwxrwxrwx 1 alex alex 24 Dec 13 22:42 astro/src/assets/images -> ../../../contents/images

# Images here are accessible via http://domain/images/name.jpg
$ ls -l astro/public/images
lrwxrwxrwx 1 alex alex 28 Dec 13 22:56 astro/public/images -> ../../contents/images-public
```

This allows me to make changes to the blog content from the root dir instead of always going into the sub folders.

# Categories
Categories in blog posts are defined in the follwing file:
- `../astro/src/data/categories.ts`

For example:
```
export const CATEGORIES = [
	'Automation',
	'Tips and Tricks',
	'How To',
	'Building this Blog',
	'Others'
] as const
```

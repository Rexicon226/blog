#!/bin/bash

# Gather user information

# Title
echo "Enter the title of the blog post: "
read title

# For Date we use the current time in this format (YYYY-MM-DDTHH:MM:SS)
date=$(date +"%Y-%m-%dT%H:%M:%S")
echo "Date: $date"

# Author
echo "Enter the author of the blog post: "
read author

# Now we want to get the next number of blog. There are folders in "content/blogs"
# numbered 1 - n, we need to get n + 1. However there is an index.md file, so we can 
# just use the number.

next_blog_number=$(ls content/blogs | wc -l)

mkdir content/blogs/$next_blog_number

echo "---
{
    \"title\": \"$title\",
    \"date\": \"$date\",
    \"author\": \"$author\",
    \"draft\": true,
    \"layout\": \"blog/page.html\",
    \"tags\": []
}
---
Hello World! This is a new blog post.
" > content/blogs/$next_blog_number/index.md

echo "Created new blog post at content/blogs/$next_blog_number/index.md"

# Add the blog to content/blogs/index.md.
# We simply need to append the new blog to the end of the file.

echo "## [$title](/$next_blog_number/)\n" >> content/blogs/index.md
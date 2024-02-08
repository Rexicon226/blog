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


# Now copy the 
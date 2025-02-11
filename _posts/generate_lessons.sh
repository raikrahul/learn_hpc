#!/bin/bash

# Directory for Jekyll posts
POSTS_DIR="_posts"

# Ensure _posts directory exists
mkdir -p "$POSTS_DIR"

# Start date for lessons (Modify as needed)
START_DATE="2024-03-04"

# Number of lessons
NUM_LESSONS=15

# Loop to create lesson files
for i in $(seq 1 $NUM_LESSONS); do
    # Format lesson number with leading zero (e.g., Lesson 01, Lesson 02)
    LESSON_NUM=$(printf "%02d" $i)

    # Generate filename with correct Jekyll format
    FILE_DATE=$(date -d "$START_DATE +$((i-1)) days" +%Y-%m-%d)
    FILENAME="$POSTS_DIR/${FILE_DATE}-lesson${LESSON_NUM}.md"

    # Create file with basic front matter
    cat <<EOF > "$FILENAME"
---
layout: default
title: "Lesson $i"
date: $FILE_DATE
---

## Lesson $i

Lesson $i content goes here.
EOF

    echo "Created: $FILENAME"
done

echo "✅ All $NUM_LESSONS lesson files created!"

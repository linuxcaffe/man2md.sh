# man2md.sh
a simple script to convert nroff manpages to markdown

# Convert a gzipped man page to markdown
./man2md.sh /usr/share/man/man1/task.1.gz man-task.md

# Or for uncompressed man pages
./man2md.sh /usr/share/man/man5/task-color.5 task-color.md
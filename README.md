# md2web_docker

Markdown to html, and present by nginx

This docker image lets you run Markdown file To html, and present by nginx in a docker container.

## Building the image

```sh
docker build .
```

## Using the image to run

```sh
docker run -v <host_dir>:/docs cheyang/md2web 
```
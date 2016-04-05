# md2web_docker

Markdown to html, and present by nginx

This docker image lets you run Markdown file To html, and present by nginx in a docker container.

## Building the image

```sh
docker build .
```

## Using the image to run

```sh
cd sample_docs
docker run -d -p 80:80 -v `pwd`/parts:/node_modules/markdown2bootstrap/parts -v `pwd`:/docs cheyang/md2web 
```
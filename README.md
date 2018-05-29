# github-alpine-docker
sign your commits with this github alpine docker container <br>
made from alpine image, 64MB total footprint"<br>
<br>
this repo aims to create a container, where you can launch anywhere when need to commit to github <br>
I believe you already have the following files: <br>
- GPG private and public keys named as privkey.asc pubkey.asc <br>
- SSH private and public keys named as id_edXXXXX and id_edXXXXX.pub EG <br> 
- github email address <br>

After replace with your own info, just run: <br>
 ```docker build -t image_name . && 
 docker run -ti -d \ 
 --name github \ 
 -h github \ 
 --restart always \ 
 -v /home/user-name/your-repo-dir/:/repo image_name```
FROM alpine
LABEL maintainer="Marco Matos contato@marcomatos.com"

    RUN apk add --update make git openssh gnupg vim shadow
    
    ENV user-name <CHANGE WITH DESIRED USERNAME HERE>

    RUN adduser -D -u 1000 ${user-name}
    WORKDIR /home/${user-name}
    
    ENV pass password_value
    RUN echo "${user-name}:${pass}" | chpasswd
    
    ADD .gitconfig     .
    ADD id_edXXXXX.pub .ssh/
    ADD id_edXXXXX     .ssh/
    ADD pubkey.asc    .ssh/
    ADD privkey.asc  .ssh/
    RUN chown ${user-name}:${user-name} .ssh/privkey.asc

    USER ${user-name}
    RUN gpg --import /home/${user-name}/.ssh/pubkey.asc
    RUN gpg --batch --import  /home/${user-name}/.ssh/privkey.asc

    RUN git config --global user.name "${user-name}"
    RUN git config --global user.email "seu@email.com"
    RUN git config --global core.editor vim  
    RUN git config --global gpg.program gpg2
    RUN ssh-keyscan -H github.com
    ENV GPG_TTY /dev/pts/0 

# fixing alpine root vulnerability
    USER root 
    RUN pass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1` \ 
        && echo 'root:${pass}' | chpasswd 
#        && usermod -s /bin/false root

    RUN sed -i '/root/s/sh/false/g' /etc/passwd

    USER ${user-name}
    CMD [ "/bin/sh" ]
FROM alpine
LABEL maintainer="Marco Matos marco@marco.ae"

    RUN apk add --update make git openssh gnupg vim
    
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
    ENV GPG_TTY /dev/pts/0 

    CMD [ "/bin/sh" ]
FROM ubuntu

ADD mybin .
ENTRYPOINT ["mybin"]

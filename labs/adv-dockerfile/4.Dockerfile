FROM centos:7

# This downloads and runs the docker installer script
# For the purposes of this exercise assume the script runs successfully even if it does not
RUN curl -s -o docker.sh https://get.docker.com
RUN chmod +x docker.sh
RUN ./docker.sh
RUN rm docker.sh

# Note: it may be a security concern to run arbitrary code from the internet but for this exercise let's assume it's okay.

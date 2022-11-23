# Container image that runs your code
FROM python:3

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY check_version.py /check_version.py

# Install Python utilities
RUN pip install pip pipenv virtualenv -U && \
    apt-get update && \
    apt-get install -y build-essential curl git && \
    apt-get autoremove -y && \
    apt-get clean

RUN chmod 777 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
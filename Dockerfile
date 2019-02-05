FROM cloudkernels/python3-base:latest

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y python3.5-venv

COPY build_python_package.sh /
ENTRYPOINT ["/build_python_package.sh"]
CMD []

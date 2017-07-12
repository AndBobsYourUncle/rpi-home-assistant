# Notice:
# When updating this file, please also update virtualization/Docker/Dockerfile.dev
# This way, the development image and the production image are kept in sync.

FROM andbobsyouruncle/rpi-python

MAINTAINER Paulus Schoutsen <Paulus@PaulusSchoutsen.nl>

# Uncomment any of the following lines to disable the installation.
#ENV INSTALL_TELLSTICK no
#ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
#ENV INSTALL_LIBCEC no
#ENV INSTALL_PHANTOMJS no
#ENV INSTALL_COAP_CLIENT no
#ENV INSTALL_SSOCR no

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy build scripts
# COPY virtualization/Docker/ virtualization/Docker/
# RUN virtualization/Docker/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt

# Uninstall enum34 because some depenndecies install it but breaks Python 3.4+.
# See PR #8103 for more info.
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop cchardet && \
    pip3 uninstall -y enum34

# Copy source
COPY . .

EXPOSE 8123

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]

# ISLE 8 - isle-fcrepo image

Designed to used with:

* Docker-compose service
* ISLE 8 Mariadb container
* The Drupal 8 site

Based on:

* [isle-fcrepo-base](https://github.com/Islandora-Devops/isle-fcrepo-base)

Contains:

* [Fedora](https://github.com/fcrepo4/fcrepo4/releases/tag/fcrepo-5.1.0) `5.1.0`
* [Tomcat](https://tomcat.apache.org/download-80.cgi)`8.5.x`
* [Islandora SYN](https://github.com/Islandora/Syn/releases) `1.1.0`
* [OpenJDK](https://openjdk.java.net/) `8`
  * Versions 11 & 13 on with Tomcat 9 fail using Fedora 5.
  * TBD fixes and testing from Fedora community, using Tomcat 8 & OpenJDK 8 to match [Islandora Playbook](https://github.com/Islandora-Devops/islandora-playbook) versions

---

## MVP 3 sprint

### Building

In order to build locally, run this command

* `docker build -t isle-fcrepo:mvp3-alpha .`

### Docker-Hub

Born-Digital is currently supplying pre-built images from their Docker Hub registry. This image and others are currently used in the `isle-dc` docker-compose.yml until the official Islandora Dockerhub account becomes available.

You can pull this image e.g. `docker pull borndigital/isle-fcrepo:mvp3-alpha` or performing `docker-compose pull` from within a local `isle-dc` project directory.

### Running

To run the container, you'll need to do the following:

* Run the install script for creating the fedora database on the ISLE8 Maria Db container. This is included as a seperate script called `install-fedora.sh` in the scripts directory.
  * Within a terminal, `bash isle-dc/scripts/install-fedora.sh`

### Testing

To test Fedora,

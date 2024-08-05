# azure-libreoffice-headless
Azure-Friendly LibreOffice Headless build (for install without root access!)

## Introduction

This repo allows for building a docker image that will construct a distribution of LibreOffice meant to run in Microsoft's CBL-Mariner 2.0, which is the distro of Linux used in Azure, without the need of root access. This allows for doing document conversions (say, from Microsoft Office formats to PDF files) with minimal binaries.

We will use Microsoft's CBL-Mariner 2.0 base docker image to install the necessary dependencies and then build a minimal version of LibreOffice for headless use, particularly avoiding any X-Windows dependencies as those will break in CBL-Mariner 2.0. The distribution directory will be compressed into libreoffice.tar.gz, which generally is around ~150MB.

## Running

1. Build the image. This will take a few hours depending on your hardware: 
```
$ docker build -t supermem613/azure-libreoffice-headless .
```
2. After the image is built, create a container from the image:
```
$ docker run -it supermem613/azure-libreoffice-headless
```
3. Copy the /root/libreoffice.tar.gz file out of the container (say, using "docker cp") and then run it anywhere you'd like.
4. Unzip libreoffice.tar.gz, go into instdir/program and run soffice.bin to convert files or whatever else you'd like to do:
```
$ ./soffice.bin --headless --convert-to pdf <OFFICEFILE>
```

Enjoy!

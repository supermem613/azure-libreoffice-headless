# syntax docker/dockerfile:1
FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN cd /root && \
    # Set up extended mariner repos, needed for some dependencies
    tdnf install -y mariner-repos-extended && \
    # Install common dependencies
    tdnf install -y git awk zip unzip tar ca-certificates && \
    # Install GCC 12
    tdnf install -y mpfr-devel gmp-devel flex bison kernel-headers binutils glibc-devel file diffutils && \
    git clone https://gcc.gnu.org/git/gcc.git gcc-source && \
    cd gcc-source && \
    git checkout remotes/origin/releases/gcc-12 && \
    ./contrib/download_prerequisites && \
    mkdir ../gcc-12-build && \
    cd ../gcc-12-build/ && \
    ./../gcc-source/configure --prefix=$HOME/install/gcc-12 --enable-languages=c,c++ --disable-multilib && \
    make -j16 || echo "GCC 12 build FAILED" && \
    make install || echo "GCC 12 install FAILED"  && \
    cd /usr/bin && \
    rm gcc && \
    ln -s ~/install/gcc-12/bin/gcc gcc && \
    # Build LibreOffice
    cd /root && \
    git clone https://git.libreoffice.org/core libreoffice && \
    cd libreoffice && \
    tdnf install -y fontconfig-devel gperf libxslt-devel nss-devel nspr-devel libcurl-devel libx11-devel libxext-devel libice-devel libsm-devel libXrender-devel openssl-devel mesa-libGL-devel mesa-libGLU-devel libxinerama-devel icu-devel automake autoconf redland-devel patch && \
    ./autogen.sh --disable-avahi --disable-cairo-canvas --disable-coinmp --disable-cups --disable-cve-tests --disable-dbus --disable-dconf --disable-dependency-tracking --disable-evolution2 --disable-dbgutil --disable-extension-integration --disable-extension-update --disable-firebird-sdbc --disable-gio --disable-gstreamer-1-0 --disable-gtk3 --disable-gtk4 --disable-gui --disable-introspection --disable-largefile --disable-lotuswordpro --disable-lpsolve --disable-odk --disable-ooenv --disable-pch --disable-postgresql-sdbc --disable-mariadb-sdbc --disable-postgresql-sdbc --disable-firebird-sdbc --disable-python --disable-randr --disable-report-builder --disable-scripting-beanshell --disable-scripting-javascript --disable-sdremote --disable-sdremote-bluetooth --enable-mergelibs --with-galleries="no" --with-system-icu --with-system-curl --with-system-expat --with-system-libxml --with-system-nss --with-system-openssl --with-system-redland --with-theme="no" --without-export-validation --without-fonts --without-helppack-integration --without-java --without-junit --without-krb5 --without-myspell-dicts --without-system-dicts && \
    make && \
    # Package all implicit dependencies with LibreOffice. This is very heavy handed and will include a lot of unnecessary dependencies, bloating the package size.
    cp /usr/lib/* /root/instdir/program/ && \
    # Package LibreOffice
    tar -czvf /root/libreoffice.tar.gz instdir

CMD tail -f /dev/null
# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.

FROM phusion/passenger-ruby21:0.9.8

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Mecab
RUN curl -O https://mecab.googlecode.com/files/mecab-0.996.tar.gz
RUN tar -xzf mecab-0.996.tar.gz
RUN cd mecab-0.996; ./configure --enable-utf8-only; make; make install; ldconfig

# Ipadic
# RUN curl -O https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
# RUN tar -xzf mecab-ipadic-2.7.0-20070801.tar.gz
# RUN cd mecab-ipadic-2.7.0-20070801; ./configure --with-charset=utf8; make; make install
# RUN echo "dicdir = /usr/local/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc

# Naist-jdic
RUN curl -L http://jaist.dl.sourceforge.jp/naist-jdic/53500/mecab-naist-jdic-0.6.3b-20111013.tar.gz -o mecab-naist-jdic-0.6.3b-20111013.tar.gz
RUN tar -xzf  mecab-naist-jdic-0.6.3b-20111013.tar.gz
RUN cd mecab-naist-jdic-0.6.3b-20111013; ./configure --with-charset=utf8; make; make install
RUN echo "dicdir = /usr/local/lib/mecab/dic/naist-jdic" > /usr/local/etc/mecabrc

# FreeLing
# RUN apt-get update
# RUN apt-get -y install libboost-regex1.48-dev libicu-dev zlib1g-dev libboost-system1.48-dev libboost-program-options1.48-dev
# ldconfig /usr/local/lib
# #RUN curl -o freeling-3.1.deb http://devel.cpl.upc.edu/freeling/downloads/27
# ADD freeling-3.1.deb freeling-3.1.deb
# RUN dpkg -i freeling-3.1.deb
# ldconfig /usr/local/lib
# ENV FREELINGSHARE /usr/share/freeling

# FreeLing from source
# WORKDIR /
# RUN apt-get update
# RUN apt-get -y install build-essential automake autoconf
# RUN apt-get -y install libboost-regex-dev libicu-dev zlib1g-dev
# RUN apt-get -y install libboost-system-dev libboost-program-options-dev libboost-thread-dev
# #RUN curl -o freeling-3.1.tar.gz http://devel.cpl.upc.edu/freeling/downloads/32
# ADD freeling-3.1.tar.gz freeling-3.1.tar.gz
# RUN cd freeling-3.1.tar.gz/freeling-3.1; ./configure; make; make install
# ENV FREELINGSHARE /usr/local/share/freeling

# Ve
RUN git clone https://github.com/Kimtaro/ve.git
RUN cd /ve; git pull; git checkout c6ac46a1; gem install bundler; bundle install; gem build ve.gemspec; gem install ve-0.0.3.gem

# Start the server
EXPOSE 4567
RUN mkdir /etc/service/ve
ADD ve.sh /etc/service/ve/run

# Clean up
RUN apt-get remove -y build-essential
RUN rm -rf mecab-0.996.tar.gz*
RUN rm -rf mecab-ipadic-2.7.0-20070801*
RUN rm -rf freeling-*

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM debian:stable
VOLUME /output

RUN apt-get update -y
RUN apt-get install -y wget git bzip2 build-essential libzip-dev lib32ncurses5-dev ed libncurses5-dev bison cmake libpython-all-dev libncbi-vdb-dev

# Get the code
RUN git clone https://github.com/mysql/mysql-server.git
RUN wget 'https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.59.0%2F&ts=1504877405&use_mirror=netix' -O boost.tar.bz2

# Build boost
RUN tar xvf boost.tar.bz2
RUN cd /boost_1_59_0/ && ./bootstrap.sh
RUN cd /boost_1_59_0 && ./b2 link=static

# Build mysql-server
ADD edcmd /edcmd
RUN bash ./edcmd
RUN cd mysql-server && cmake . -DWITH_BOOST=/boost_1_59_0 -DCURSES_LIBRARY=/usr/lib/x86_64-linux-gnu/libncurses.a -DCURSES_INCLUDE_PATH=/usr/local/ncurses/5.9/include
RUN cd mysql-server && make -j$(expr `grep -c ^processor /proc/cpuinfo` \* 2)

# specify default command to copy the mysqldump binary to the output volume.
CMD cp /mysql-server/client/mysqldump /output

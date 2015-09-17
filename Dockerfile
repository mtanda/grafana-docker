FROM debian:wheezy

RUN apt-get update && apt-get -y install libfontconfig wget adduser openssl ca-certificates && apt-get clean

RUN wget http://grafanarel.s3.amazonaws.com/builds/grafana_latest_amd64.deb

RUN dpkg -i grafana_latest_amd64.deb
ENV DPKG_FRONTEND=noninteractive
RUN apt-get install -y unzip rsync
RUN wget -O /tmp/grafana-plugins.zip https://github.com/grafana/grafana-plugins/archive/master.zip
RUN cd /tmp && unzip grafana-plugins.zip
RUN rsync -avz /tmp/grafana-plugins-master/datasources/ /usr/share/grafana/public/app/plugins/datasource/

EXPOSE 3000

VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]
VOLUME ["/etc/grafana"]

WORKDIR /usr/share/grafana

ENTRYPOINT ["/usr/sbin/grafana-server", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.logs=/var/log/grafana"]

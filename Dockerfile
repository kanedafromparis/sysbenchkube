FROM registry.access.redhat.com/ubi8/ubi:8.1

# based on https://github.com/akopytov/sysbench

RUN yum install -y  https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
  && yum install -y sysbench

ADD help-sys-commande.sh /tmp/help-sys-commande.sh

RUN mv /tmp/help-sys-commande.sh /usr/bin/help-sys-commande.sh \
  && chmod a+x /usr/bin/help-sys-commande.sh \
  && mkdir -p /bench/data \
  && chown -R 1001:0 /bench \
  && chmod -R ug+s /bench

USER 1001
# todo CMD sysbench



FROM perl:latest

WORKDIR /temp

# pull in the ora2pg tool and alien to convert the rpms
RUN \
    apt-get update && apt-get install -y ora2pg && apt-get install -y alien && apt-get install -y libaio1

# pull down the oracle stuffs from a permlink
RUN \
    wget https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-basic-linuxx64.rpm && \
    wget https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-sqlplus-linuxx64.rpm && \
    wget https://download.oracle.com/otn_software/linux/instantclient/oracle-instantclient-devel-linuxx64.rpm

# install those alien packages
RUN \
    alien -i oracle-instantclient-basic-linuxx64.rpm && \
    alien -i oracle-instantclient-devel-linuxx64.rpm && \
    alien -i oracle-instantclient-sqlplus-linuxx64.rpm

# once we got the oracle junk in place we can build the oracle perl module that ora2pg needs
RUN \
    export ORACLE_HOME=`echo /usr/lib/oracle/*/client64` && \
    export LD_LIBRARY_PATH=`echo /usr/lib/oracle/*/client64/lib` && \
    perl -MCPAN -e 'install DBD::Oracle'

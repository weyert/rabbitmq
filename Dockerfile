FROM rabbitmq:3.7

RUN rabbitmq-plugins enable --offline rabbitmq_management

# Download the plugin file so it can be installed in the next step, first it will download th enecessary ssl certificates for
# operating system and wget so the file can be loaded. Next it will cleanup the tools as it's not needed anymore
RUN set -x \
        && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget unzip && rm -rf /var/lib/apt/lists/* \
        && wget -O /plugins/rabbitmq_delayed_message_exchange-${RABBITMQ_VERSION}.zip https://dl.bintray.com/rabbitmq/community-plugins/3.7.0/rabbitmq_delayed_message_exchange-3.7.0.zip \
        && wget -O /plugins/rabbitmq_message_timestamp-${RABBITMQ_VERSION}.zip https://dl.bintray.com/rabbitmq/community-plugins/3.7.0/rabbitmq_message_timestamp-3.7.0.zip \
        && unzip /plugins/rabbitmq_delayed_message_exchange-${RABBITMQ_VERSION}.zip -d /plugins; rm /plugins/rabbitmq_delayed_message_exchange-${RABBITMQ_VERSION}.zip \
        && unzip /plugins/rabbitmq_message_timestamp-${RABBITMQ_VERSION}.zip -d /plugins; rm /plugins/rabbitmq_message_timestamp-${RABBITMQ_VERSION}.zip \
        && apt-get purge -y --auto-remove ca-certificates wget unzip
		

# List the available plugins and then our RabbitMQ plugins afterwards it outputs the available plugins for RabbitMQ
RUN set -x \ 
        && ls /plugins \
        && rabbitmq-plugins enable rabbitmq_delayed_message_exchange  \
        && rabbitmq-plugins enable rabbitmq_message_timestamp \
        && rabbitmq-plugins list

EXPOSE 15671 15672

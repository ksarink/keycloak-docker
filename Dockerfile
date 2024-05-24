FROM quay.io/keycloak/keycloak:24.0 as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange,impersonation,recovery-codes
# ENV KC_DB=mariadb

# install plugin which prevents users logging into client without specified group
RUN curl -sL https://github.com/sventorben/keycloak-restrict-client-auth/releases/download/v20.0.0/keycloak-restrict-client-auth.jar -o /opt/keycloak/providers/keycloak-restrict-client-auth-v19.0.0.jar

RUN /opt/keycloak/bin/kc.sh build

######################################################################################################

FROM quay.io/keycloak/keycloak:24.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]

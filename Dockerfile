FROM python:3.4-onbuild

RUN mkdir /code
WORKDIR /code

ADD requirements.txt /code/

RUN pip install -r requirements.txt
ADD . /code/

# Add extra information in docker container
ARG VCS_REF
ARG BUILD_DATE
ARG BUILD_VERSION
LABEL authors="Vincent MERCIER" \
    org.label-schema.schema-version="1.0.0-rc.1" \
    org.label-schema.name="Prometheus dashboard" \
    org.label-schema.description="Simple dashboard for Prometheus" \
    org.label-schema.url="https://github.com/vmercierfr/prometeus-dashboard" \
    org.label-schema.usage="See https://github.com/vmercierfr/prometeus-dashboard/blob/master/README.md" \
    org.label-schema.vendor="Vincent MERCIER" \
    org.label-schema.vcs-type="git" \
    org.label-schema.vcs-url="https://github.com/vmercierfr/prometeus-dashboard" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.version=$BUILD_VERSION

EXPOSE 8000

CMD [ "python", "app.py" ]
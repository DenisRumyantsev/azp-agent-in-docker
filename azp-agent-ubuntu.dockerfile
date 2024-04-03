# docker build --tag "azp-agent:ubuntu" --file "./azp-agent-ubuntu.dockerfile" .
# docker run --interactive --tty -e AZP_URL="https://dev.azure.com/${organization}" -e AZP_POOL="Docker Agent Pool" -e AZP_AGENT_NAME="Docker Agent - Ubuntu" -e AZP_TOKEN="${token}" --name "azp-agent-ubuntu" azp-agent:ubuntu

FROM ubuntu:22.04

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu70

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN useradd agent
RUN chown agent ./
USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh

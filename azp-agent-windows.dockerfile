# docker build --tag "azp-agent:windows" --file "./azp-agent-windows.dockerfile" .
# docker run --interactive --tty --network "Default Switch" -e AZP_URL="https://dev.azure.com/${organization}" -e AZP_POOL="Docker Agent Pool" -e AZP_AGENT_NAME="Docker Agent - Windows" -e AZP_TOKEN="${token}" --name "azp-agent-windows" azp-agent:windows

FROM mcr.microsoft.com/windows/servercore:ltsc2022

WORKDIR /azp/

COPY ./start.ps1 ./

CMD powershell ./start.ps1

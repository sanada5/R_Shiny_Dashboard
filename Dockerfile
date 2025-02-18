FROM rocker/shiny:latest

RUN R -e "install.packages(c('shiny', 'shinydashboard', 'ggplot2', 'dplyr', 'here'))"

COPY . /srv/shiny-server/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host = '0.0.0.0', port = 3838)"]
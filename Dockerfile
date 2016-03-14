FROM rails:onbuild
MAINTAINER Ian Blenke <ian@blenke.com>

RUN apt-get update && apt-get install -y jq

CMD ./run.sh

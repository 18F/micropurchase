FROM rails:onbuild
MAINTAINER Ian Blenke <ian@blenke.com>

RUN apt-get update && apt-get install -y jq

env PORT 3000
EXPOSE 3000

CMD ./run.sh

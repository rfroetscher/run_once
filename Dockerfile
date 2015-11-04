FROM yikaus/alpine-bash

COPY run_once.sh run_once.sh

CMD ['bash', 'run_once.sh']

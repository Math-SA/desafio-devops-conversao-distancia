#! /bin/bash
hash=$(git rev-parse --short HEAD 2> /dev/null)

if [[ -n $hash ]] ; 
then
    tag="$hash"
else
    tag='v1'
fi

docker build -t "conversao-distancia:dev_$tag" .

porta_5000=$(docker container ls | cut -s --delimiter " " --fields 1,22-30 | grep "0.0.0.0:5000->")
if [[ -n $porta_5000 ]] ; 
then
    container=$(echo "$porta_5000" | cut -s --delimiter " " --fields 1)
    echo "Container $container utilizando a porta 5000. Terminando execução em 5 segundos. Ctrl+C para cancelar."
    sleep 5
    docker container stop $container
fi

docker container run -d -p 5000:5000 conversao-distancia:dev_"$tag"

if curl -fs --retry 15 --retry-max-time 120 --retry-all-errors http://localhost:5000 > /dev/null; then
   echo "Container iniciado com sucesso: http://localhost:5000"
fi;
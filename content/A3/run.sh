#!/bin/bash

current_project="$(oc project | grep -oP 'Using project "\K[a-z\-_0-9]*')"
project='example'
project_yaml='project-example.yaml'
project_yaml_name="$(yq '.metadata.name' $project_yaml)"

echo "Creating project \"${project}\" via command line"
oc new-project "$project"

echo "Creating project \"${project_yaml_name}\" via yaml file"
oc apply -f "$project_yaml"

# O cluster pode demorar um pouco para criar os projetos, entao..
sleep 3s
# Ao criar o projeto com "new-project" seu contexto é alterado automaticamente
# para o novo projeto criado. Quando deletamos ficaremos em um limbo, para evitar
# isso, vamos (tentar) voltar ao seu projeto de origem (pois pode ser que você
# não estivesse em um).
oc project "$current_project"

echo "Deleting project \"${project}\""
oc delete project "$project"

echo "Deleting project \"$project_yaml_name\" via yaml file"
oc delete project "$project_yaml_name"

# Nota: Não é possível utilizar oc delete -f "$project_yaml" aqui, pois o 'kind'
# do recurso no yaml é 'ProjectRequest'. Se fosse 'Project' ou 'Namespace' seria
# possível e recomendado.

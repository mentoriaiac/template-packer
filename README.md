# Packer Template

Este repositório contém a estrutura básica para criação de uma image com Packer na Google Cloud Plataform, um pipeline para validação dos arquivos e demais arquivos necessários.

O Packer template será utilizado em conjunto com playbooks Ansible para que a imagem resultante seja utilizada pelo Terraform no provisionamento dos ambientes.

Motivo do uso de HCL2 ao invés de json:

> As of version 1.7.0, HCL2 support is no longer in beta and is the **preferred way to write Packer configuration(s)** - [Hashicorp Docs](https://www.packer.io/guides/hcl/from-json-v1)

## Pré-Requisitos

Para execução deste template são necessários os seguintes items:

- Packer >= 1.7

- Projeto Google Cloud com billing account e Compute Engine API ativa

- Service Account JSON com Compute Instance Admin role

- Secret com o nome ``GCP_SA_KEY`` para Github Actions pipeline cujo valor é o conteúdo do JSON da Service Account 

## Estrutura Básica do Projeto

~~~~
/
    packer/
        build.pkr.hcl
        source.pkr.hcl
        variables.pkr.hcl
~~~~

- packer/source.pkr.hcl: onde é indicado o builder e suas configurações para construção da imagem

- packer/build.pkr.hcl: onde é invocado os sources e definido o(s) provisioner(s) para alterações na imagem antes da criação

- packer/variables.pkc.hcl: onde são centralizadas as variáveis do template

## Variáveis

Todas as variáveis que são necessárias no arquivo variables.pkr.hcl para rodar executar o template: 

| Variable     	| Default 	| Required 	| Description                                                                            	|
|--------------	|---------	|----------	|----------------------------------------------------------------------------------------	|
| project_id   	|         	| true     	| ID do projeto onde será provisionada a máquina para geração e armazenamento da imagem. 	|
| source_image 	|         	| true     	| Imagem base para a imagem.                                                             	|
| ssh_username 	|         	| true     	| Usuário que conectará via SSH. Necessário se SSH for usado.                            	|
| zone         	|         	| true     	| Zona onde será provisionada a máquina para criação da imagem.                          	|
|               |           |           |                                                                                           |

## Como Testar Localmente

1- Editar o arquivo ``packer/variables.pkr.hcl`` de acordo com as variáveis necessárias.

2- Executar comando ``make validate`` para o validate e formating da imagem.

3- (Opcional) ``make build`` faz o build da imagem na plataforma configurada pelo arquivo ``packer/source.pkr.hcl``. Requer variável de ambiente ``GOOGLE_APPLICATION_CREDENTIALS`` com o caminho do arquivo JSON da Service Account criada.

## Observações

- CentOS e versão recentes do Debian possuem acesso ssh desabilitado por padrão. Set ssh_username para qualquer usuário para que um usuário com sudo seja criado para o Packer.

- Não usar machine types f1-micro ou g1-small por limitações de disco.
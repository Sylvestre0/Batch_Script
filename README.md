#Projeto de Criação Automática de Estrutura Node.js com Integração ao GitHub
Este script Batch foi desenvolvido para automatizar a criação de um projeto Node.js, configurando a estrutura de diretórios e arquivos, instalando dependências essenciais, e oferecendo a opção de configurar um repositório Git no GitHub, além de fazer o push inicial dos arquivos.

Funcionalidades
Criação de Estrutura de Pastas e Arquivos: Gera automaticamente a estrutura de pastas (src, controllers, models, routes, views) e cria arquivos base para um projeto Node.js usando TypeScript e Express.
Instalação de Dependências: Instala pacotes essenciais como express, typescript, sequelize, entre outros.
Configuração do Git e Integração com GitHub: Permite ao usuário configurar o repositório local com Git, criar um repositório no GitHub, e fazer o primeiro commit e push dos arquivos.
Requisitos
Node.js: Certifique-se de ter o Node.js instalado na sua máquina.
Git: Necessário para a integração com o GitHub.
cURL: Usado para interagir com a API do GitHub.
Conta no GitHub: Para criar o repositório e fazer o push.
Como Usar
Execute o Script:

Execute o script projeto.bat (ou qualquer que seja o nome do arquivo) via terminal ou clicando duas vezes no arquivo.
Digite o Nome do Projeto:

O script solicitará o nome do novo projeto. Este será o nome da pasta principal do projeto.
Opção de Envio para o GitHub:

Ao final do processo de criação da estrutura, o script perguntará se você deseja enviar o projeto para o GitHub. Responda s para sim ou n para não.
Configuração do GitHub:

Caso opte por enviar para o GitHub, você deverá fornecer seu nome de usuário, e-mail e um token de acesso do GitHub.
Verificação e Commit:

O script tentará criar o repositório no GitHub e, se bem-sucedido, fará o commit e push dos arquivos criados.
Notas
Tokens do GitHub: Certifique-se de que o token fornecido tenha as permissões necessárias para criar repositórios.
Estrutura do Projeto: O script cria uma estrutura padrão de pastas e arquivos. Se você deseja personalizar os templates de arquivos, pode editar os arquivos em model_templates.


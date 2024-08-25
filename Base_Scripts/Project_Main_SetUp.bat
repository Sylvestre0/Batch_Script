@echo off
setlocal enabledelayedexpansion

:: Função principal
call :criar_estrutura

set /p SN="Gostaria de mandar para o Github? (s | n) "
if /I "%SN%"=="s" (
    call :gitconfig
)
:: Finaliza o script
echo "Script concluído com sucesso!"
pause
goto:eof


:: Função para criar a estrutura de pastas e arquivos
:criar_estrutura
    echo "Criando estruturas de pastas..."
    set /p nome_projeto="Qual será o nome do Novo Projeto? "

    :: Verifica se o nome do projeto foi inserido
    if "%nome_projeto%"=="" (
        echo "Nenhum nome de projeto inserido. Encerrando o script."
        pause
        exit /b
    )

    :: Verifica se o diretório já existe
    if exist "%nome_projeto%" (
        echo "O diretório %nome_projeto% já existe. Escolha um nome diferente."
        pause
        exit /b
    )

    mkdir "%nome_projeto%"
    cd "%nome_projeto%"

    echo "Inicializando o projeto Node.js..."
    call npm init -y

    echo "Instalando dependências..."
    call npm install express typescript ts-node @types/node @types/express sequelize @types/sequelize mysql2

    echo "Criando estrutura de pastas dentro de src..."
    mkdir src
    cd src
    mkdir controllers models routes views 

    :: Criando arquivos em controllers
    cd controllers
    copy "..\..\..\model_templates\controllersTemplate.txt" "userControllers.ts"
    cd ..

    :: Criando arquivos em models
    cd models 
    copy "..\..\..\model_templates\modelTemplate.txt" "userModel.ts"
    cd ..

    :: Criando arquivos em routes
    cd routes
    copy "..\..\..\model_templates\routesTemplate.txt" "userRoutes.ts"
    cd ..

    :: Criando estrutura de pastas e arquivos em views
    cd views
    mkdir js css templates

    :: Criando arquivos em js
    cd js 
    copy "..\..\..\..\model_templates\jsTemplate.txt" "index.js"
    cd ..

    :: Criando arquivos em css
    cd css
    copy "..\..\..\..\model_templates\cssTemplate.txt" "styles.css"
    cd ..

    :: Criando arquivos em templates
    cd templates
    copy "..\..\..\..\model_templates\htmlTemplate.txt" "index.html"
    powershell -Command "(Get-Content index.html) -replace 'NOME_DO_PROJETO', '%nome_projeto%' | Set-Content index.html"
    cd ..\..\..
    goto:eof
:: Função para configurar o Git
:gitconfig
    setlocal enabledelayedexpansion
    set /p user="Digite seu Usuario do GitHub:  "
    set /p email="Digite o email cadastrado do Github:  "

    :repository_name_input
    set /p nome_projeto="Digite o nome do repositório:  "

    :token_input
    set /p token="Cole o token gerado aqui:  "

    set contador=0

:verificar_token
    if not "!token:~%contador%,1!"=="" (
        set /a contador+=1
        goto verificar_token
    )

    if %contador% neq 40 (
        echo Token inválido. Por favor, tente novamente.
        goto token_input
    )

    :: Tentativa de criação do repositório no GitHub
    curl -H "Authorization: token %token%" -d "{\"name\":\"%nome_projeto%\"}" https://api.github.com/user/repos > response.json

    :: Verificar se o repositório foi criado com sucesso
    findstr /C:"\"errors\":" response.json >nul
    if %errorlevel%==0 (
        echo "Erro: Não foi possível criar o repositório. Verifique se o nome já existe e tente novamente."
        del response.json
        goto repository_name_input
    )

    set url="https://github.com/%user%/%nome_projeto%.git"
    set pushUrl="https://%token%@github.com/%user%/%nome_projeto%.git"
    start "" "%url%"
    echo "Repositório criado em %url%"
    del response.json

:: Verificar se o repositório está acessível antes de prosseguir com o push
set "repo_created=false"
set "retry_count=0"
:check_repo
if %retry_count% geq 10 (
    echo "Erro: O repositório não está disponível após várias tentativas. Tente novamente mais tarde."
    goto :eof
)
curl -H "Authorization: token %token%" https://api.github.com/user/repos?per_page=100 > repos.json
findstr /C:"\"full_name\": \"!user!/%nome_projeto%\"" repos.json >nul
if %errorlevel% == 0 (
    set "repo_created=true"
    echo "Repositório verificado e disponível."
) else (
    echo "Aguardando o repositório estar disponível..."
    timeout /t 5 >nul
    set /a retry_count+=1
    goto check_repo
)

del repos.json
:: Continuar com o script para configurar Git e fazer o push
if "%repo_created%"=="true" (
    echo node_modules/ > .gitignore
    echo "olá projeto %nome_projeto%" > README.md
    git init
    git config user.name "%user%"
    git config user.email "%email%"
    git remote add origin %pushUrl%
    git add .
    git status -s
    git commit -m "primeiro commit"
    git push -u origin master
    echo "Script concluído com sucesso"
    code .
) else (
    echo "Erro: Não foi possível verificar a criação do repositório."
)
pause
goto:eof
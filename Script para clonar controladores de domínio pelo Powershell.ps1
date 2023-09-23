# Script para clonar controladores de domínio pelo Powershell - Créditos Gabriel Luiz - www.gabrielluiz.com #



# Verfica qual é o controlador de domínio que possui o mestre de operações de emulador PDC e o seu sistema operacional.


get-adcomputer(Get-ADDomainController -Discover -Service "PrimaryDC").name -property * | format-list dnshostname,operatingsystem,operatingsystemversion



# Adicionar um controlador de domínio ao grupo Controladores de Domínio Clonáveis (Cloneable Domain Controllers).


Get-adcomputer ADDS2 | %{add-adgroupmember "cloneable domain controllers" $_.samaccountname}




# Esse comando exibe a lista de aplicativos excluídos no console.



Get-ADDCCloningExcludedApplicationList


<#

Observação: 


Se já houver um arquivo CustomDCCloneAllowList.xml, esse cmdlet exibirá o delta dessa lista em comparação com o sistema operacional, o que pode não ser nada se as listas corresponderem.


#>




# Esse comando gera a lista de aplicativos excluídos como um arquivo chamado CustomDCCloneAllowList.xml no caminho da pasta especificada, C:\Windows\NTDS, e força a substituição se um arquivo com esse nome já existir nesse local do caminho.



Get-ADDCCloningExcludedApplicationList -GenerateXml -Path C:\Windows\NTDS -Force



<#


Explicação do comando: Get-ADDCCloningExcludedApplicationList -GenerateXml -Path C:\Windows\NTDS -Force


Get-ADDCCloningExcludedApplicationList - O comando Get-ADDCCloningExcludedApplicationList procura no controlador de domínio local programas e serviços no banco de dados de programas instalados, o gerenciador de controle de serviços que não são especificados na lista de inclusão padrão e definida pelo usuário. Os aplicativos na lista resultante podem ser adicionados à lista de exclusão definida pelo usuário se forem determinados a oferecer suporte à clonagem. Se os aplicativos não forem clonáveis, eles deverão ser removidos do controlador de domínio de origem antes que a mídia de clonagem seja criada. Qualquer aplicativo que apareça na saída do cmdlet e não esteja incluído na lista de inclusão definida pelo usuário forçará a falha na clonagem.


-GenerateXml - Indica se o arquivo CustomDCCloneAllowList.xml deve ser criado e o grava no local especificado usando o parâmetro Path.


-Path - Especifica o caminho da pasta a ser usado ao criar o arquivo CustomDCCloneAllowList.xml usando o parâmetro GenerateXml.


-Force - Força a execução do comando sem solicitar a confirmação do usuário.


#>



# Este comando cria um controlador de domínio clone.



New-ADDCCloneConfigFile -Static -IPv4Address "10.101.0.158" -IPv4DNSResolver "10.101.0.100" -IPv4SubnetMask "255.255.255.0" -CloneComputerName "ADDS2T" -IPv4DefaultGateway "10.101.0.200" -PreferredWINSServer "10.101.0.100" -SiteName "BH"



<#

Explicação do comando: New-ADDCCloneConfigFile -Static -IPv4Address "10.101.0.158" -IPv4DNSResolver "10.101.0.100" -IPv4SubnetMask "255.255.255.0" -CloneComputerName "ADDS2T" -IPv4DefaultGateway "10.101.0.200" -PreferredWINSServer "10.101.0.100" -SiteName "BH"


New-ADDCCloneConfigFile - O cmdlet New-ADDCCloneConfigFile executa verificações de pré-requisitos para clonar um controlador de domínio quando executado localmente no controlador de domínio que está sendo preparado para clonagem. Esse cmdlet gera um arquivo de configuração de clone, DCCloneConfig.xml, em um local apropriado, se todas as verificações de pré-requisitos forem bem-sucedidas.


-Static - Indica se a configuração de TCP/IP especificada para o controlador de domínio clonado é configuração de IP estático ou dinâmico.


-IPv4Address "10.101.0.158" - Especifica o endereço do Protocolo de Internet versão 4 (IPv4) a ser atribuído ao controlador de domínio clonado.


-IPv4DNSResolver "10.101.0.100" - Especifica o endereço do Protocolo de Internet versão 4 (IPv4) do servidor DNS a ser usado pelo controlador de domínio clonado para resolver nomes. Um máximo de quatro valores de string podem ser fornecidos.


-CloneComputerName "ADDS2T" - Especifica o nome do computador para o controlador de domínio clonado.



-IPv4DefaultGateway "10.101.0.200" - Especifica o endereço do Protocolo de Internet versão 4 (IPv4) para o gateway padrão a ser usado pelo controlador de domínio clonado.



-PreferredWINSServer "10.101.0.100" - Especifica o nome do servidor WINS (Windows Internet Naming Service) principal a ser usado como o servidor WINS preferencial para o controlador de domínio clonado.


-SiteName "BH" - Especifica o nome do site do Active Directory no qual colocar o controlador de domínio clonado.


#>





<#

Referências:

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adcomputer?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-addomaincontroller?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/add-adgroupmember?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-addccloningexcludedapplicationlist?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-addccloneconfigfile?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/virtualized-domain-controller-deployment-and-configuration?WT.mc_id=5003815

https://docs.microsoft.com/pt-br/windows-server/identity/ad-ds/reference/virtual-dc/virtualized-domain-controller-cloning-test-guidance-for-application-vendors?WT.mc_id=WDIT-MVP-5003815


#>

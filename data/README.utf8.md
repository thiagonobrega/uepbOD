Sistema de captura de dados relativos ao gasto com Pessoal (crawler)
==============

*O projeto OpenData@UEPB precisa de dados para poder existir! *

Para capturar estes dados foi desenvolvido um sistema chamado de crwaler, que captura, agrupa e converte os dados relativos a folha de pagamento disponiveis no portal da transparencia.

Um crawler é o processo de capturar os dados disponiveis em paginas Web. Muitos sites, em particular os motores de busca (Google,Facebook,etc), utilizam crawlers para manter uma base de dados atualizada. Os Web crawlers são principalmente utilizados para criar uma cópia de todas as páginas visitadas para um pós-processamento por um motor de busca que irá indexar as páginas baixadas para prover buscas mais rápidas (ou promover a transparencia). Crawlers também podem ser usados para tarefas de manutenção automatizadas em um Web site, como checar os links, validar código, obter tipos específicos de informações das páginas da Web, como minerar endereços de email (ou dados publicos). Fonte: [WikiPedia](https://en.wikipedia.org/wiki/Web_crawler)


## Com funcional esse crawller?

Esse crawler é bem simples (para mim), ele simula a navegação e captura os dados dos servidores (matricula,nome,salário,gratificações,tempo de serviço,...) [1] e complementa com algumas outras informações (lotação,Vínculo,Regime e Função) nas paginas da cppd [2] e cppta [3]. No final ele salva todos os dados de um mês em um arquivo **Comma-separated values**, conhecido como .[csv](https://pt.wikipedia.org/wiki/Comma-separated_values) (arquivo de formato aberto que pode ser importado em todo e qualquer editor de tabela).

O gráfico abaixo ilustra como funciona o processo:

[![Processo](https://raw.github.com/thiagonobrega/uepbOD/master/imagens/crawler.png)]

[1] - <http://transparencia.uepb.edu.br/consulta/>
[2] - <http://comissoes.uepb.edu.br/cppd/servidores-docentes/>
[3] - <http://comissoes.uepb.edu.br/cppta/servidores-tecnicos/>

desc
## Qual o formato dos dados?

## Esse crawler e bom mesmo? Tem algum problema?

## O que eu preciso para poder capturar os dados?


Crawler
==============

*O projeto OpenData@UEPB precisa de dados para poder existir! *

Para capturar estes dados foi desenvolvido um sistema chamado de crwaler, que captura, agrupa e converte os dados relativos a folha de pagamento disponíveis no portal da transparência.

Um crawler é o processo de capturar os dados disponíveis em paginas Web. Muitos sites, em particular os motores de busca (Google,Facebook,etc), utilizam crawlers para manter uma base de dados atualizada. Os Web crawlers são principalmente utilizados para criar uma cópia de todas as páginas visitadas para um pós-processamento por um motor de busca que irá indexar as páginas baixadas para prover buscas mais rápidas (ou promover a transparência). Crawlers também podem ser usados para tarefas de manutenção automatizadas em um Web site, como checar os links, validar código, obter tipos específicos de informações das páginas da Web, como minerar endereços de email (ou dados públicos). Fonte: [WikiPedia](https://en.wikipedia.org/wiki/Web_crawler)


## Com funcional esse crawler?

O funcionamento desse crawler é bem simples. No primeiro momento os dados dos servidores (matricula,nome,salário,...) disponibilizados no portal da transparência [1]. Em seguida os dados capturados são consolidados com os dados disponibilizados nas paginas da CPPD [2] e CPPTA [3] para que informações complementares (lotação,Vínculo,Regime e Função) sejam adicionadas. 

Ao final, com as informações consolidadas, os dados são salvos em um arquivo **Comma-separated values** ([csv](https://pt.wikipedia.org/wiki/Comma-separated_values)), arquivo de formato aberto que pode ser importado em todo e qualquer editor de tabela. Para cad mês/ano é gerado um arquivo com os dados dos servidores.

O gráfico abaixo ilustra como funciona do crawler.

![Processo](https://raw.githubusercontent.com/thiagonobrega/uepbOD/master/imagens/crwaler.png)


[1] - <http://transparencia.uepb.edu.br/consulta/>

[2] - <http://comissoes.uepb.edu.br/cppd/servidores-docentes/>

[3] - <http://comissoes.uepb.edu.br/cppta/servidores-tecnicos/>


## Qual o formato dos dados?

Para cada mês é gerado um arquivo *csv* 

   - "X" : identificador único (gerado pelo crawler)
   - "Matrícula" : Matrícula do servidor
   - "Cargo" : PROFESSOR, TÉCNICO ADMINISTRATIVO
   - "Função" : 305 Valóres distindos (e.g. Professor Adjunto I,AUXILIAR DE LABORATÓRIO DE ANÁLISES FÍSICO-QUÍMICAS, entre outros)
   - "Vínculo":  CEDIDO, COMISSIONADO, ESTATUTÁRIO, NAO SEI ,PRESTADOR DE SERVIÇO e TEMPORÁRIO
   - "Escolaridade" :  DOUTOR, ENSINO ,FUNDAMENTAL, ENSINO FUNDAMENTAL INCOMPLETO, ENSINO MÉDIO, ESPECIALISTA, entre outros.
   - "Tempo.de.Serviço"
   - "Cargo.Comissionado" : O cargo da função gratificada
   - "Gratificação.Cargo.Comissionado.Função" :Valor da Função de gratificada
   - "Mês.de.referência" : 
   - "Remuneração" :
   - "Vantagens.Pessoais" : 
   - "Total.Vantagens.Pessoais" : Removi a descrição e somei as Vantagens Pessoais
   - "Vantagens.Transitórias" :
   - "Total.Vantagens.Transitorias" : Removi a descrição e somei as Vantagens Transitorias
   - "Terço.de.Férias" : 
   - "Abono.de.Permanência" :
   - "Total.Bruto" : 
   - "Descontos.Obrigatórios" :
   - "Total.Líquido": 
   - "Lotação":
   - "mes" :  mês
   - "ano" : ano

## Mas so existem esses dados nesse formato para os servidores da UEPB?

Não a união disponibiliza os dados de todos os pagamentos (contratos,convenios,licitações), salários e diárias dos servidores federais (civis e militares) e todos os pagamentos aos beneficiários de programas sociais (i.e. bolsa familia, seguro defeso, entre outros) pelo no <http://www.portaldatransparencia.gov.br/downloads/> em formato CSV.

A UFRN foi a primeira universidade federal a disponibilizar dados (academico, folha,concursos,contratos e despesas e orçamento) em formato aberto (csv e json) no endereço <http://dados.ufrn.br/>.

Será que a UEPB vai ser a primeira estadual a disponibilizar dados em formato aberto?

## Esse crawler e bom mesmo? Tem algum problema?

Ele é bom, mas tem alguns probleminhas: 
1. Como estou capturando dados muito antigos as informações complementares (lotação,vinculo e regime) não estavam disponíveis.
  * Em virtude a ausencia desses dados o vinculo e lotação foram definidas como 'NAO SEI';
   * A ausência desses dados pode gerar viés nas analises;
   * Em um futuro seria interessante disponibilizar os dados antigos da cppd e cppta para corrigir este problema;
2. Ele pode não capturar as informações de servidores que tenham dois vínculos com a instituição (e.g. técnico administrativo e professor substituto) corretamente.
  * A solução é simples, modificar uma pequena parte do crawler (algum voluntario?)

## Demora muito para capturar todos os dados?

Sim! No mínimo  uma semana para capturar todos os dados do zero!

**Por isso vou atualizar mensalmente os dados para evitar que vocês tenham que capturar do zero ;)**

## O que eu preciso para poder capturar os dados?

Para capturar os dados é necessário ter instalado o **python 3** com as bibliotecas :

  - pandas
  - numpy
  - requests
  - BeautifulSoup


Para executar basta digitar:

python3 crawler.py


PS : No windows recomendo instalar o anaconda/python 3<https://www.continuum.io/downloads>, pois já vem com todos as bibliotecas necessariás
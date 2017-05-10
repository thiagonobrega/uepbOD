# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
xlwt
pandas
numpy
request
BeautifulSoup
"""
import pandas as pd
import numpy as np
import requests
from bs4 import BeautifulSoup
import time

def ajustaValor(valor):
    try:
        return valor.split('R$')[1].strip().replace(',','.')
    except IndexError:
        return valor.strip().replace(',','.')



def limpaVantagensPessoais(data):
    import re
    r = []
    for v in re.split('[0-9][0-9][0-9] ',data):
        if v != '':
            r.append(ajustaValor(v))
    return r

def somaVantagens(vantagens):
    j = 0
    for v in vantagens:
        j+= float(v)
    return j

def configuraCabecalho(headers):
    r = []
    for h in headers:
        r.append(h.replace(':',''))
        #era 10
    r.insert(12,'Total Vantagens Pessoais')
    r.insert(14,'Total Vantagens Transitorias')
    return r


def check(dirToScreens):
    import os
    from os import path
    files = [f.replace('-','/').split('.')[0] for f in os.listdir(dirToScreens) if path.isfile(f) and f.endswith(".csv")]
    return files

def gen_list(ldir,olist):
    alredy = set(check(ldir))
    flist = set(olist)
    r = flist.difference(alredy)
    return list(r)


def getSelect(url,filtro='mes_referencia'):
    source_code = requests.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, 'html.parser')
    links = []
    
    for val in soup.find(id=filtro).find_all('option'):
        
        #url = link['href']
        links.append(val.text)
#        if filtro in url:
#            links.append(url)
        
    return links


def spider_list(url,mes,filtro='funcao=mostrar'):
    session = requests.Session()
    url1 = 'http://transparencia.uepb.edu.br/wp-content/themes/uepb2016-transparencia-final/controller/consulta.php'
    source_code = session.post(url1, data = {'parametros[]': [mes,'','','']} )
#    source_code = session.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, 'html.parser')
    links = []
    
    for link in soup.findAll('a', href=True):
        
        url = link['href']
        if filtro in url:
            links.append(url)
        
        #href = link.get('href')
        #spider_data(href)
    return links

def getData(url,filtro='detalhamentoServidor'):
    session = requests.Session()
    source_code = session.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, 'html.parser')
    
    h = []
    v = []
    j = 1
    
    div = soup.find('div', id=filtro)
    table = div.find('table', attrs={'class':'table table-striped'})
        #headers = table.find('th')
        #headers = table.find_all('th')
    rows = table.find_all('tr')
        
    i = 1
        
    for row in rows:
        cols = row.find_all('td')
        headers , val = [ele.text.strip() for ele in cols]
        h.append(headers)
        v.append(val)
        i += 1
    j += 1
    return [h,v]

def getLotacao(url,filtro='table table-striped table-hover'):
    
    session = requests.Session()
    source_code = session.get(url)
    plain_text = source_code.text
    soup = BeautifulSoup(plain_text, 'html.parser')
    
    dic = {}
    j = 1
    
    table = soup.find('table', attrs={'class':filtro})
    headers = table.find_all('th')
    headers = [ele.text.strip() for ele in headers]
    
    rows = table.find_all('tr')
        
    i = 1
        
    for row in rows:
        cols = row.find_all('td')
        val = [ele.text.strip() for ele in cols]
        
        try:
            print("duplicado :" + str(dic[val[0]]) )
        except KeyError:
            dic[val[0]] = val[1:]
        i += 1
    
    j += 1
    return headers[1:],dic

urlldoc = 'http://comissoes.uepb.edu.br/cppd/servidores-docentes/'
urlltadm = 'http://comissoes.uepb.edu.br/cppta/servidores-tecnicos/'

hl,ldoc = getLotacao(urlldoc)
hl,ltae = getLotacao(urlltadm)

meses = getSelect('http://transparencia.uepb.edu.br/consulta/')
meses_td = gen_list('.',meses)
print(meses_td)
print(len(meses_td))

z = [ meses[0] , meses[len(meses)-20] ]
z = meses[31:40]

#xlsOut = pd.ExcelWriter('dadosAbertos.xls')
for mes in meses_td:
#for mes in z:
    print("==== " + mes +" ====")
    servidores = spider_list('http://transparencia.uepb.edu.br/consulta/',mes)
    d = []
    data = []
    count = 1
    total = len(servidores)
    for s in servidores:
        
        try:
            d = getData(s)
        except:
          print("Connection refused by the server..")
          print("Let me sleep for 10 seconds")
          print("ZZzzzz...")
          time.sleep(10)
          print("Was a nice sleep, now let me continue...")
          d = getData(s)
          continue
        
        val = d[1]
        val[6] = ajustaValor(val[6])
        val[8] = ajustaValor(val[8])
        # necessario?
        #val[10] = ajustaValor(val[10])
        val[11] = ajustaValor(val[11])
        val[12] = ajustaValor(val[12])
        val[13] = ajustaValor(val[13])
        val[14] = ajustaValor(val[14])
        val[15] = ajustaValor(val[15])
        val.insert(10,somaVantagens(limpaVantagensPessoais(d[1][9])))
        val.insert(12,somaVantagens(limpaVantagensPessoais(d[1][11])))
        if (count % 100) == 0:
            t = time.ctime()
            print("Done " + str(count) + "/" + str(total) + " [ "+str((count/total)*100)+"% ] at :" + str(t) )
        count += 1
        
        ldata = []
        try:
            if ('PROF' in val[1]):
                ldata=ldoc[val[0]]
            else:
                ldata=ltae[val[0]]
        except KeyError:
            hl = ['Função', 'Vínculo', 'Regime', 'Lotação', 'Matrícula']
            ldata = ['','NAO SEI','','NAO SEI',val[0]]
            
        #lotacao
        d[0].append(hl[3])
        val.append(ldata[3])
        #vinculo
        d[0].insert(3,hl[1])
        val.insert(3,ldata[1])
        #matricula
        d[0].insert(0,hl[4])
        val.insert(0,ldata[4])
        
        data.append(val)
        time.sleep(0.10)


    fdata = pd.DataFrame(data)
    fdata.columns= configuraCabecalho(d[0])
    del fdata['Nome']
    
    prefix =  str(mes).replace('/','-')
    fileout = prefix + ".csv"
    
    print(fileout)
    fdata.to_csv(fileout)
    #fdata.to_excel(xlsOut,prefix)
    #xlsOut.save()


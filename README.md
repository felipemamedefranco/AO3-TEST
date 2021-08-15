# AO3-TEST
Teste Profissional de Engenharia de Dados

#!/usr/bin/env python
# coding: utf-8

#Bibliotecas
import pandas as pd
from sqlalchemy import create_engine
from getpass import getpass
import pymongo as pym

#----------------------------------------------
#(1) Importa e Trata Dados:
#----------------------------------------------
#Importa Planilha
df = pd.read_excel(r'teste-ao3-dataset-vacinacao-covid19.xlsx')

#Trata Ids Duplicados
df=df.drop_duplicates(['document_id','paciente_id'])

#Trata valores faltantes na coluna 'vacina_fabricante_referencia' de acordo com a 'coluna vacina_fabricante_nome'
for x in df['vacina_fabricante_referencia'].drop_duplicates().dropna().index:
    for y in df.index:
        if df.loc[y]['vacina_fabricante_nome'] == df.loc[x]['vacina_fabricante_nome']:
            df.loc[y,['vacina_fabricante_referencia']] = df.loc[x]['vacina_fabricante_referencia']

#Trata outros valores faltantes na coluna 'vacina_fabricante_referencia'
df['vacina_fabricante_referencia'].fillna('Sem Referência', inplace=True)

#Trata valores faltantes de 'paciente_endereco_copais', igualando aos demais
df['paciente_endereco_copais'].fillna(10, inplace=True)

#Transforma os valores de'vacina_lote' em string (Necessário para inserir dados no arquivo parquet)
df['vacina_lote']=df['vacina_lote'].astype(str)




#----------------------------------------------
#(2) Funçao Inserir Dados no MYSQL:
#----------------------------------------------
def PutMYSQL(df):
#Solicita dados de conexão com banco de dados MYSQL
    DB = input('Digite o nome do banco MYSQL:')
    SERVER = input('Digite o nome do servidor do banco MYSQL:')
    USER = input('Digite o nome do usuário do banco MYSQL:')
    PASS = getpass('Digite a senha do usuário do banco MYSQL:')
    
#Conecta no banco MYSQL utilizando os dados de conexão digitados
    conn = create_engine("mysql+pymysql://"+USER+":"+PASS+"@"+SERVER+"/"+DB)
    
#Sobe a tabela com dados tratados para o banco MYSQL
    df.to_sql(con=conn, name='teste_ao3_tabela_vacinacao_covid19', if_exists='append',index=False)
    print('\nDados inseridos em '+SERVER+"/"+DB+'\n\n\n')

    
    
#----------------------------------------------
#(3) Funçao Inserir Dados no MongoDB:
#----------------------------------------------
def PutMongo(df):
#Solicita dados de conexão com o MongoDB
    DB = input('Digite o nome do banco MongoDB:')
    SERVER = input('Digite o nome do servidor MongoDB:')
    PORT = input('Digite a porta do serviço MongoDB:')
    COLLECTION = input('Digite o nome da coleção do MongoDB:')
    
#Gera um dicionário a partir dos dados tratados
    df_dict = df.to_dict('records')

#Insere o dicionário com dados tratados para o MongoDB
    pym.MongoClient('mongodb://'+SERVER+':'+PORT+'/')[DB][COLLECTION].insert_many(df_dict)
    print('\nDados inseridos em mongodb://'+SERVER+':27017/\n\n\n')


    
    
#----------------------------------------------
#(4) Funçao Inserir Dados no Arquivo Parquet:
#----------------------------------------------
def PutParquet(df):
#Insere tabela em um arquivo parquet
    df.to_parquet('teste_ao3_dataset_vacinacao_covid19.parquet', engine='fastparquet')
    print('\nArquivo parquet criado\n\n\n')

    
    

#----------------------------------------------
#(5) Main Loop:
#----------------------------------------------
while x != 'exit':
#De acordo com o valor fornecido, o código faz input dos dados em um banco MySQL, MongoDB ou em um Parquet File
    print('Dataset teste-ao3-dataset-vacinacao-covid19.xlsx carregado!\n\nDigite 1 para transporta-lo para um banco MySQL\nDigite 2 para transporta-lo para um banco MongoDB\nDigite 3 para gerar um Parquet File')
    x=input('Ou digite "exit" para encerrar o programa:')
    if x=='1':
        PutMYSQL(df)
    elif x=='2':
        PutMongo(df)
    elif x=='3':
        PutParquet(df)

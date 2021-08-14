# AO3-TEST
Teste Profissional de Engenharia de Dados

import pandas as pd
from sqlalchemy import create_engine
from getpass import getpass
import pymongo as pym

#----------------------------------------------
#(0) Importando Dados:
#----------------------------------------------
df = pd.read_excel(r'teste-ao3-dataset-vacinacao-covid19.xlsx')

#----------------------------------------------
#(1) Tratando Dados:
#----------------------------------------------

#Trata Ids Duplicados
df=df.drop_duplicates(['document_id','paciente_id'])

#Trata valores faltantes na coluna 'vacina_fabricante_referencia' de acordo com a 'coluna vacina_fabricante_nome'
for x in df['vacina_fabricante_referencia'].drop_duplicates().dropna().index:
    for y in df.index:
        if df.loc[y]['vacina_fabricante_nome'] == df.loc[x]['vacina_fabricante_nome']:
            df.loc[y,['vacina_fabricante_referencia']] = df.loc[x]['vacina_fabricante_referencia']

#Trata outros valores faltantes na coluna 'vacina_fabricante_referencia'
df['vacina_fabricante_referencia'].fillna('Sem Referência', inplace=True)

#Trata demais valores faltantes na tabela
df.fillna('Sem Registro', inplace=True)

#----------------------------------------------
#(2) Inserindo Dados no MYSQL:
#----------------------------------------------

#Solicita dados de conexão com banco de dados MYSQL
DB = input('Digite o nome do banco MYSQL:')
SERVER = input('Digite o nome do servidor do banco MYSQL:')
USER = input('Digite o nome do usuário do banco MYSQL:')
PASS = getpass('Digite a senha do usuário do banco MYSQL:')

#Conecta no banco MYSQL utilizando os dados de conexão digitados
conn = create_engine("mysql+pymysql://"+USER+":"+PASS+"@"+SERVER+"/"+DB)

#Sobe a tabela com dados tratados para o banco MYSQL
df.to_sql(con=conn, name='teste_ao3_tabela_vacinacao_covid19', if_exists='append',index=False)

#----------------------------------------------
#(3) Inserindo Dados no MongoDB:
#----------------------------------------------

#Solicita dados de conexão com o MongoDB
DB = input('Digite o nome do banco MongoDB:')
SERVER = input('Digite o nome do servidor MongoDB:')
COLLECTION = input('Digite o nome da coleção do MongoDB:')

#Gera um dicionário a partir dos dados tratados
df_dict = df.to_dict('records')

#Insere o dicionário com dados tratados para o MongoDB
pym.MongoClient('mongodb://'+SERVER+':27017/')[DB][COLLECTION].insert_many(df_dict)

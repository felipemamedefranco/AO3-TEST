# AO3-TEST
Teste Profissional de Engenharia de Dados

import pandas as pd

#Pega a planilha
df = pd.read_excel(r'teste-ao3-dataset-vacinacao-covid19.xlsx')

#Trata Ids Duplicados
df=df.drop_duplicates(['document_id','paciente_id'])

#Trata valores faltantes na coluna 'vacina_fabricante_referencia' de acordo com a coluna vacina_fabricante_nome
for x in df['vacina_fabricante_referencia'].drop_duplicates().dropna().index:
    for y in df.index:
        if df.loc[y]['vacina_fabricante_nome'] == df.loc[x]['vacina_fabricante_nome']:
            df.loc[y,['vacina_fabricante_referencia']] = df.loc[x]['vacina_fabricante_referencia']

#Trata resto de valores faltantes na coluna 'vacina_fabricante_referencia'
df['vacina_fabricante_referencia'].fillna('Sem Referência', inplace=True)

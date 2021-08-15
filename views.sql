create or replace view pacientes_por_idade as select count(document_id) QTD_Pacientes, paciente_idade Idade from teste_ao3_tabela_vacinacao_covid19 group by paciente_idade order by 1 desc;
create or replace view pacientes_por_vacina as select count(document_id) QTD_Pacientes, vacina_fabricante_nome Vacina from teste_ao3_tabela_vacinacao_covid19 group by vacina_fabricante_nome order by 1 desc;
create or replace view media_idade_por_vacina as select avg(paciente_idade) MediaIdade, vacina_fabricante_nome Vacina from teste_ao3_tabela_vacinacao_covid19 group by vacina_fabricante_nome order by 1 desc;


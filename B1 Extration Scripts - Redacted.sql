#CSV Prescrição
select hospID.prescricao.fkhospital, hospID.prescricao.fkpessoa, hospID.prescricao.nratendimento, fkprescricao, nome, dtprescricao, dtvigencia, status, hospID.prescricao.update_at, indicadores
FROM hospID.prescricao inner join hospID.setor on hospID.prescricao.fksetor = hospID.setor.fksetor
inner join hospID.pessoa on hospID.prescricao.fkpessoa = hospID.pessoa.fkpessoa and hospID.prescricao.nratendimento = hospID.pessoa.nratendimento 
WHERE dtprescricao between '20YY/MM/DD' and '20YY/MM/DD'
and dtinternacao between '20YY/MM/DD' and '20YY/MM/DD'
and idsegmento = 1
and agregada is null
and concilia is null;

#CSV Pessoa
select distinct hospID.pessoa.fkhospital, hospID.pessoa.fkpessoa, hospID.pessoa.nratendimento, dtnascimento, dtinternacao, cor, sexo, hospID.pessoa.peso, dtpeso, altura, dtalta, motivoalta
FROM hospID.prescricao inner join hospID.pessoa on hospID.prescricao.fkpessoa = hospID.pessoa.fkpessoa and hospID.prescricao.nratendimento = hospID.pessoa.nratendimento 
WHERE dtprescricao between '20YY/MM/DD' and '20YY/MM/DD'
and dtinternacao between '20YY/MM/DD' and '20YY/MM/DD'
and idsegmento = 1
and agregada is null
and concilia is null;

#CSV Exame
select distinct e.fkhospital, e.fkpessoa, e.nratendimento, se.nome, e.dtexame, e.resultado, e.unidade
from (select distinct hospID.prescricao.fkpessoa, hospID.prescricao.nratendimento  from hospID.prescricao
WHERE dtprescricao between '20YY/MM/DD' and '20YY/MM/DD'
and hospID.prescricao.idsegmento = 1
and agregada is null
and concilia is null) t1
inner join 
(select distinct hospID.pessoa.fkpessoa, hospID.pessoa.nratendimento from hospID.pessoa
where dtinternacao between '20YY/MM/DD' and '20YY/MM/DD') t2
on (t1.fkpessoa = t2.fkpessoa and t1.nratendimento = t2.nratendimento)
inner join 
hospID.exame e
on e.fkpessoa = t1.fkpessoa and e.nratendimento = t1.nratendimento
inner join
hospID.segmentoexame se on lower(e.tpexame) = lower(se.tpexame);

#CSV Evolução
select distinct t1.fkhospital, t1.fkpessoa, t1.nratendimento, ev.dtevolucao, ev.texto, ev.cargo
from (select distinct hospID.prescricao.fkhospital, hospID.prescricao.fkpessoa, hospID.prescricao.nratendimento  from hospID.prescricao
WHERE dtprescricao between '20YY/MM/DD' and '20YY/MM/DD'
and hospID.prescricao.idsegmento = 1
and agregada is null
and concilia is null) t1
inner join 
(select distinct hospID.pessoa.fkpessoa, hospID.pessoa.nratendimento from hospID.pessoa
where dtinternacao between '20YY/MM/DD' and '20YY/MM/DD') t2
on (t1.fkpessoa = t2.fkpessoa and t1.nratendimento = t2.nratendimento)
inner join 
hospID.evolucao ev
on ev.nratendimento = t1.nratendimento;

#CSV Itens da Prescrição
select distinct t1.fkhospital, t1.fkpessoa, t1.nratendimento, t1.fkprescricao,
pm.fkmedicamento, md.nome, pm.dose, pm.frequenciadia, pm.via,
pm.complemento, pm.doseconv, pm.horario, pm.origem, pm.dtsuspensao,
pm.slagrupamento, pm.slacm, pm.sletapas, pm.slhorafase, pm.sltempoaplicacao,
pm.sldosagem, pm.sltipodosagem,pm.periodo, pm.alergia, pm.sonda, it.dtintervencao,
it.observacao, it.status, it.update_at, it.idmotivointervencao, it.erro, it.custo
from (select distinct hospID.prescricao.fkhospital, hospID.prescricao.fkpessoa, hospID.prescricao.nratendimento, hospID.prescricao.fkprescricao from hospID.prescricao
WHERE dtprescricao between '20YY/MM/DD' and '20YY/MM/DD'
and hospID.prescricao.idsegmento = 1
and agregada is null
and concilia is null) t1
inner join 
(select distinct hospID.pessoa.fkpessoa, hospID.pessoa.nratendimento from hospID.pessoa
where dtinternacao between '20YY/MM/DD' and '20YY/MM/DD') t2
on (t1.fkpessoa = t2.fkpessoa and t1.nratendimento = t2.nratendimento)
inner join 
hospID.presmed pm on t1.fkprescricao = pm.fkprescricao
inner join hospID.medicamento md on pm.fkmedicamento = md.fkmedicamento
left join hospID.intervencao it on pm.fkpresmed = it.fkpresmed;
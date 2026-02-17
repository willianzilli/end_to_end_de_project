select n."data", p.nome, n.qtd, n.unit_pric, p.marca, e.estoque 
from mongo.erp.notas n
left join mysql.erp.produtos as p on p.id = n.produto
left join postgres.public.estoque as e on e.produto = p.id 
where n."data" between date '2025-12-01' and date '2025-12-31'
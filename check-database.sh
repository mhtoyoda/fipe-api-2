#!/bin/bash

echo "🔍 Verificando Dados no Banco"
echo "=============================="
echo ""

# Verificar marcas
echo "📋 Marcas no banco:"
docker exec -it fipe-api-2-postgres psql -U fipe_user -d fipe_api2 -c "SELECT id, codigo, nome, created_at FROM brands ORDER BY created_at DESC;"

echo ""
echo "📊 Total de marcas:"
docker exec -it fipe-api-2-postgres psql -U fipe_user -d fipe_api2 -c "SELECT COUNT(*) as total_brands FROM brands;"

echo ""
echo "📋 Modelos no banco:"
docker exec -it fipe-api-2-postgres psql -U fipe_user -d fipe_api2 -c "SELECT COUNT(*) as total_models FROM vehicle_models;"

echo ""
echo "📊 Modelos por marca:"
docker exec -it fipe-api-2-postgres psql -U fipe_user -d fipe_api2 -c "
SELECT 
    b.codigo,
    b.nome as marca,
    COUNT(vm.id) as total_modelos
FROM brands b
LEFT JOIN vehicle_models vm ON b.id = vm.brand_id
GROUP BY b.id, b.codigo, b.nome
ORDER BY b.created_at DESC;
"

echo ""
echo "📝 Últimos 10 modelos salvos:"
docker exec -it fipe-api-2-postgres psql -U fipe_user -d fipe_api2 -c "
SELECT 
    vm.id,
    vm.codigo,
    vm.nome as modelo,
    b.nome as marca,
    vm.created_at
FROM vehicle_models vm
JOIN brands b ON vm.brand_id = b.id
ORDER BY vm.created_at DESC
LIMIT 10;
"

echo ""
echo "=============================="




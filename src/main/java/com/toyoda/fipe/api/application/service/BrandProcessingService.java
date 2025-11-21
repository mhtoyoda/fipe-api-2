package com.toyoda.fipe.api.application.service;

import com.toyoda.fipe.api.infrastructure.http.dto.ModelsResponse;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BrandProcessingService {

    private static final Logger log = LoggerFactory.getLogger(BrandProcessingService.class);

//    private final BrandRepository brandRepository;
//    private final VehicleModelRepository vehicleModelRepository;
//    private final FipeClient fipeClient;
//
//    public BrandProcessingService(
//            BrandRepository brandRepository,
//            VehicleModelRepository vehicleModelRepository,
//            FipeClient fipeClient) {
//        this.brandRepository = brandRepository;
//        this.vehicleModelRepository = vehicleModelRepository;
//        this.fipeClient = fipeClient;
//    }

    @Transactional
    public void processBrandFromMessage(Map<String, Object> brandData) {
//        String codigo = extractCodigo(brandData);
//        String nome = extractNome(brandData);
//
//        if (codigo == null || codigo.isBlank()) {
//            log.warn("⚠️ Código da marca está vazio, ignorando: {}", brandData);
//            return;
//        }
//
//        log.info("🔄 Processando marca - Código: {}, Nome: {}", codigo, nome);
//
//        try {
//            Brand brand = saveBrand(codigo, nome);
//            ModelsResponse modelsResponse = buscarModelosEmQualquerTipo(codigo, nome);
//
//            if (modelsResponse != null && modelsResponse.modelos() != null && !modelsResponse.modelos().isEmpty()) {
//                log.info("📋 Encontrados {} modelos para a marca {}",
//                        modelsResponse.modelos().size(), nome);
//
//                saveModels(brand, modelsResponse.modelos());
//
//                log.info("✅ Marca {} processada com sucesso! Total de modelos: {}",
//                        nome, modelsResponse.modelos().size());
//            } else {
//                log.warn("⚠️ Nenhum modelo encontrado para a marca {} em nenhum tipo de veículo", nome);
//            }
//
//        } catch (Exception e) {
//            log.error("❌ Erro ao processar marca {} ({}): {}", nome, codigo, e.getMessage());
//        }
    }

//    private ModelsResponse buscarModelosEmQualquerTipo(String codigo, String nome) {
//        try {
//            log.info("🚗 Tentando buscar modelos em CARROS para marca {}...", nome);
//            ModelsResponse response = fipeClient.getVehicicleModelByMarcaId(codigo);
//            if (response != null && response.modelos() != null && !response.modelos().isEmpty()) {
//                log.info("✅ Encontrado em CARROS");
//                return response;
//            }
//        } catch (Exception e) {
//            log.debug("Marca {} não encontrada em carros: {}", nome, e.getMessage());
//        }
//
//        log.warn("⚠️ Marca {} (código: {}) não encontrada em nenhum tipo de veículo (carros, motos, caminhões)", nome, codigo);
//        return null;
//    }

//    private Brand saveBrand(String codigo, String nome) {
//        return brandRepository.findByCodigo(codigo)
//                .map(existingBrand -> {
//                    log.info("📝 Marca {} já existe, atualizando...", nome);
//                    existingBrand.setNome(nome);
//                    return brandRepository.save(existingBrand);
//                })
//                .orElseGet(() -> {
//                    log.info("✨ Criando nova marca: {}", nome);
//                    Brand newBrand = new Brand(codigo, nome);
//                    return brandRepository.save(newBrand);
//                });
//    }

//    private void saveModels(Brand brand, List<ModelResponse> models) {
//        if (models == null || models.isEmpty()) {
//            log.warn("⚠️ Lista de modelos vazia ou nula");
//            return;
//        }
//
//        int newModels = 0;
//        int updatedModels = 0;
//
//        log.info("💾 Salvando {} modelos da marca {}...", models.size(), brand.getNome());
//
//        for (ModelResponse modelResponse : models) {
//            try {
//                String modelCodigo = String.valueOf(modelResponse.codigo());
//                String modelNome = modelResponse.nome();
//
//                log.debug("  🔍 Verificando modelo: {} ({})", modelNome, modelCodigo);
//
//                boolean exists = vehicleModelRepository.existsByBrandAndCodigo(brand, modelCodigo);
//
//                if (exists) {
//                    updatedModels++;
//                    log.debug("  ↻ Modelo já existe: {} ({})", modelNome, modelCodigo);
//                } else {
//                    VehicleModel model = new VehicleModel(modelCodigo, modelNome);
//                    model.setBrand(brand);
//
//                    VehicleModel savedModel = vehicleModelRepository.save(model);
//                    newModels++;
//
//                    log.debug("  ✨ Novo modelo salvo: {} ({}) - ID: {}",
//                            modelNome, modelCodigo, savedModel.getId());
//                }
//            } catch (Exception e) {
//                log.error("  ❌ Erro ao salvar modelo: {}", e.getMessage());
//            }
//        }
//
//        vehicleModelRepository.flush();
//
//        log.info("📊 Resumo - Novos: {}, Já existentes: {}", newModels, updatedModels);
//
//        long totalModels = vehicleModelRepository.countByBrand(brand);
//        log.info("✅ Total de modelos da marca {} no banco: {}", brand.getNome(), totalModels);
//    }
//
//    private String extractCodigo(Map<String, Object> data) {
//        Object codigo = data.get("codigo");
//        if (codigo != null) {
//            return String.valueOf(codigo);
//        }
//        Object code = data.get("code");
//        if (code != null) {
//            return String.valueOf(code);
//        }
//        Object id = data.get("id");
//        if (id != null) {
//            return String.valueOf(id);
//        }
//        return null;
//    }
//
//    private String extractNome(Map<String, Object> data) {
//        Object nome = data.get("nome");
//        if (nome != null) {
//            return String.valueOf(nome);
//        }
//        Object name = data.get("name");
//        if (name != null) {
//            return String.valueOf(name);
//        }
//        return "Nome não informado";
//    }
}


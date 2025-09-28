package com.example.emag.repo;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.example.emag.model.ClientProduct;

public interface ClientProductRepository extends MongoRepository<ClientProduct, String> {
    boolean existsByContractNo(String contractNo);
}

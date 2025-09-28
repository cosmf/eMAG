package com.example.emag.repo;

import com.example.emag.model.Client;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface ClientRepository extends MongoRepository<Client, String> {
  Optional<Client> findByCnp(String cnp);
  List<Client> findByProductIdsContains(String productId);
}
    
package com.example.emag.repo;

import com.example.emag.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ProductRepository extends MongoRepository<Product, String> {

  // search by name OR code (case-insensitive), paged
  Page<Product> findByNameContainingIgnoreCaseOrCodeContainingIgnoreCase(
      String name, String code, Pageable pageable);

  // filter by active + search
  Page<Product> findByActiveAndNameContainingIgnoreCaseOrActiveAndCodeContainingIgnoreCase(
      boolean active1, String name,
      boolean active2, String code,
      Pageable pageable);
}

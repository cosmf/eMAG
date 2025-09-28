package com.example.emag.repo;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.example.emag.domain.ClientHistory;

public interface ClientHistoryRepository extends MongoRepository<ClientHistory, String> {
}

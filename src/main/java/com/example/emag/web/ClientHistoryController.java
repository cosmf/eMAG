package com.example.emag.web;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.emag.domain.ClientHistory;
import com.example.emag.repo.ClientHistoryRepository;

@RestController
@RequestMapping("/api/client-history")
public class ClientHistoryController {
    private final ClientHistoryRepository repository;

    public ClientHistoryController(ClientHistoryRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<ClientHistory> list() {
        return repository.findAll();
    }
}

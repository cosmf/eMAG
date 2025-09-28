package com.example.emag.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.example.emag.domain.ClientHistory;
import com.example.emag.domain.enums.ExitStatus;
import com.example.emag.model.Client;
import com.example.emag.repo.ClientHistoryRepository;
import com.example.emag.repo.ClientRepository;
import com.example.emag.repo.ProductRepository;

@Service
public class ClientService {
    private final ClientRepository clients;
    private final ProductRepository products;
    private final ClientHistoryRepository clientHistoryRepository;

    public ClientService(ClientRepository clients, ProductRepository products, ClientHistoryRepository clientHistoryRepository) {
        this.clients = clients;
        this.products = products;
        this.clientHistoryRepository = clientHistoryRepository;
    }

    public Client create(Client c) { return clients.save(c); }

    public List<Client> list() { return clients.findAll(); }

    public Client get(String id) {
        return clients.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Client not found"));
    }

    public Client update(String id, Client changes) {
        Client c = get(id);
        c.setFirstName(changes.getFirstName());
        c.setLastName(changes.getLastName());
        c.setEmail(changes.getEmail());
        return clients.save(c);
    }

    public void delete(String id) { 
        Client client = get(id);
        
        // Delete all products attached to this client first
        for (String productId : client.getProductIds()) {
            try {
                products.deleteById(productId);
            } catch (Exception e) {
                // Log error but continue with client deletion
                System.err.println("Failed to delete product " + productId + ": " + e.getMessage());
            }
        }
        
        // Add client to history before deletion
        ClientHistory history = ClientHistory.builder()
            .client(client)
            .exitStatus(ExitStatus.NORMAL)
            .exitReason("Client deleted via API - all products removed")
            .build();
        
        clientHistoryRepository.save(history);
        
        // Now delete the client
        clients.deleteById(id);
    }

    public Client attachProduct(String clientId, String productId) {
        if (!products.existsById(productId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found");
        }
        Client c = get(clientId);
        c.getProductIds().add(productId);
        return clients.save(c);
    }

    public Client detachProduct(String clientId, String productId) {
        Client c = get(clientId);
        c.getProductIds().remove(productId);
        return clients.save(c);
    }
}

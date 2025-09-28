package com.example.emag.service;

import com.example.emag.model.Client;
import com.example.emag.model.Product;
import com.example.emag.repo.ClientRepository;
import com.example.emag.repo.ProductRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.util.List;

@Service
public class ProductService {
    private final ProductRepository products;
    private final ClientRepository clients;

    public ProductService(ProductRepository products, ClientRepository clients) {
        this.products = products;
        this.clients = clients;
    }

    public Product create(Product p) { return products.save(p); }

    public List<Product> list() { return products.findAll(); }

    public Product get(String id) {
        return products.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
    }

    public Page<Product> search(String q, Boolean active, int page, int size) {
        Pageable pageable = PageRequest.of(page, Math.min(size, 100));
        String term = (q == null) ? "" : q;

        if (active == null) {
            return products.findByNameContainingIgnoreCaseOrCodeContainingIgnoreCase(term, term, pageable);
        }
        return products.findByActiveAndNameContainingIgnoreCaseOrActiveAndCodeContainingIgnoreCase(
            active, term, active, term, pageable);
    }

    public Product update(String id, Product changes) {
        Product p = get(id);
        p.setName(changes.getName());
        p.setPrice(changes.getPrice());
        p.setActive(changes.isActive());
        return products.save(p);
    }

    public void delete(String id) {
        // Rule: do not delete if attached to any client
        List<Client> usedBy = clients.findByProductIdsContains(id);
        if (!usedBy.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Product attached to clients");
        }
        products.deleteById(id);
    }
}

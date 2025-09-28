package com.example.emag.web;

import com.example.emag.dto.CreateClientRequest;
import com.example.emag.model.Client;
import com.example.emag.service.ClientService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/clients")
public class ClientController {
  private final ClientService service;
  public ClientController(ClientService service) { this.service = service; }

  @PostMapping
  public Client create(@RequestBody @Valid CreateClientRequest req) {
    return service.create(Client.builder()
        .cnp(req.cnp())
        .firstName(req.firstName())
        .lastName(req.lastName())
        .email(req.email())
        .build());
  }

  @GetMapping public List<Client> list() { return service.list(); }
  @GetMapping("/{id}") public Client get(@PathVariable String id) { return service.get(id); }
  @PutMapping("/{id}") public Client update(@PathVariable String id, @RequestBody Client c) { return service.update(id, c); }
  @DeleteMapping("/{id}") public void delete(@PathVariable String id) { service.delete(id); }

  @PostMapping("/{id}/products/{productId}") public Client attach(@PathVariable String id, @PathVariable String productId) {
    return service.attachProduct(id, productId);
  }
  @DeleteMapping("/{id}/products/{productId}") public Client detach(@PathVariable String id, @PathVariable String productId) {
    return service.detachProduct(id, productId);
  }
}

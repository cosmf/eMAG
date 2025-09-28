package com.example.emag.web;

import com.example.emag.dto.CreateProductRequest;
import com.example.emag.model.Product;
import com.example.emag.service.ProductService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {
  private final ProductService service;
  public ProductController(ProductService service) { this.service = service; }

  @PostMapping
  public Product create(@RequestBody @Valid CreateProductRequest req) {
    return service.create(Product.builder()
        .code(req.code())
        .name(req.name())
        .price(req.price() != null ? req.price() : BigDecimal.ZERO)
        .active(true)
        .build());
  }

  @GetMapping public List<Product> list() { return service.list(); }
  @GetMapping("/{id}") public Product get(@PathVariable String id) { return service.get(id); }
  @PutMapping("/{id}") public Product update(@PathVariable String id, @RequestBody Product p) { return service.update(id, p); }
  @DeleteMapping("/{id}") public void delete(@PathVariable String id) { service.delete(id); }

  @GetMapping("/search")
    public Page<Product> search(
        @RequestParam(required = false) String q,
        @RequestParam(required = false) Boolean active,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
    return service.search(q, active, page, size);
    }
}

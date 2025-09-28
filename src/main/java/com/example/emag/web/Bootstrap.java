// package com.example.emag.web;

// import com.example.emag.model.Client;
// import com.example.emag.model.Product;
// import com.example.emag.repo.ClientRepository;
// import com.example.emag.repo.ProductRepository;
// import org.springframework.boot.CommandLineRunner;
// import org.springframework.stereotype.Component;

// import java.math.BigDecimal;

// @Component
// public class Bootstrap implements CommandLineRunner {
//     private final ProductRepository products;
//     private final ClientRepository clients;

//     public Bootstrap(ProductRepository products, ClientRepository clients) {
//         this.products = products;
//         this.clients = clients;
//     }

//     @Override public void run(String... args) {
//         if (products.count() == 0) {
//             var p1 = products.save(Product.builder().code("P-001").name("Scalpel").price(new BigDecimal("49.90")).active(true).build());
//             var p2 = products.save(Product.builder().code("P-002").name("Suture Kit").price(new BigDecimal("89.00")).active(true).build());

//             var c1 = Client.builder().cnp("1234567890123").firstName("Ana").lastName("Pop").email("ana@example.com").build();
//             c1.getProductIds().add(p1.getId());
//             c1.getProductIds().add(p2.getId());
//             clients.save(c1);

//             clients.save(Client.builder().cnp("9876543210987").firstName("Mihai").lastName("Ionescu").email("mihai@example.com").build());
//             System.out.println("Seeded demo data.");
//         }
//     }
// }

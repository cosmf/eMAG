package com.example.emag;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import com.example.emag.domain.enums.ClientStatus;
import com.example.emag.domain.enums.ContractStatus;
import com.example.emag.domain.enums.ProductStatus;
import com.example.emag.domain.enums.ProductType;
import com.example.emag.model.Client;
import com.example.emag.model.ClientProduct;
import com.example.emag.model.Product;
import com.example.emag.repo.ClientProductRepository;
import com.example.emag.repo.ClientRepository;
import com.example.emag.repo.ProductRepository;

/**
 * For local dev only; requires spring.profiles.active=dev
 */
@Component
@Profile("dev")
public class DevDataSeeder implements ApplicationRunner {
    
    private final ProductRepository productRepository;
    private final ClientRepository clientRepository;
    private final ClientProductRepository clientProductRepository;
    
    public DevDataSeeder(ProductRepository productRepository, 
                        ClientRepository clientRepository,
                        ClientProductRepository clientProductRepository) {
        this.productRepository = productRepository;
        this.clientRepository = clientRepository;
        this.clientProductRepository = clientProductRepository;
    }
    
    @Override
    public void run(org.springframework.boot.ApplicationArguments args) throws Exception {
        // Seed products if none exist
        if (productRepository.count() == 0) {
            seedProducts();
        }
        
        // Seed test client if not exists
        String testCnp = "9999999999999";
        Client devClient = clientRepository.findByCnp(testCnp).orElse(null);
        if (devClient == null) {
            devClient = seedTestClient(testCnp);
        }
        
        // Seed client-product if not exists
        String testContractNo = "CN-DEV-0001";
        if (!clientProductRepository.existsByContractNo(testContractNo)) {
            seedClientProduct(devClient, testContractNo);
        }
    }
    
    private void seedProducts() {
        // CURRENT_ACCOUNT product
        Product currentAccount = Product.builder()
            .code("PROD-CURRENT-001")
            .name("Current Account")
            .price(BigDecimal.ZERO)
            .active(true)
            .type(ProductType.CURRENT_ACCOUNT)
            .status(ProductStatus.ACTIVE)
            .build();
        productRepository.save(currentAccount);
        
        // INVESTMENT_ACCOUNT product
        Product investmentAccount = Product.builder()
            .code("PROD-INVESTMENT-001")
            .name("Investment Account")
            .price(BigDecimal.ZERO)
            .active(true)
            .type(ProductType.INVESTMENT_ACCOUNT)
            .status(ProductStatus.ACTIVE)
            .build();
        productRepository.save(investmentAccount);
        
        // CREDIT_ACCOUNT product
        Product creditAccount = Product.builder()
            .code("PROD-CREDIT-001")
            .name("Credit Account")
            .price(BigDecimal.ZERO)
            .active(true)
            .type(ProductType.CREDIT_ACCOUNT)
            .status(ProductStatus.ACTIVE)
            .build();
        productRepository.save(creditAccount);
    }
    
    private Client seedTestClient(String cnp) {
        Client client = Client.builder()
            .cnp(cnp)
            .firstName("Dev")
            .lastName("Tester")
            .email("dev@test.com")
            .status(ClientStatus.ACTIVE)
            .build();
        return clientRepository.save(client);
    }
    
    private void seedClientProduct(Client client, String contractNo) {
        // Find the CURRENT_ACCOUNT product
        Product currentAccountProduct = productRepository.findAll().stream()
            .filter(p -> p.getType() == ProductType.CURRENT_ACCOUNT)
            .findFirst()
            .orElseGet(() -> {
                // If not found, create it
                Product product = Product.builder()
                    .code("PROD-CURRENT-001")
                    .name("Current Account")
                    .price(BigDecimal.ZERO)
                    .active(true)
                    .type(ProductType.CURRENT_ACCOUNT)
                    .status(ProductStatus.ACTIVE)
                    .build();
                return productRepository.save(product);
            });
        
        ClientProduct clientProduct = ClientProduct.builder()
            .client(client)
            .product(currentAccountProduct)
            .status(ContractStatus.ACTIVE)
            .iban("RO49AAAA1B31007593840000")
            .balance(BigDecimal.ZERO)
            .currency("RON")
            .creationDate(LocalDate.now())
            .expirationDate(LocalDate.now().plusYears(1))
            .interestRate(BigDecimal.valueOf(0.05))
            .lastUpdateDate(Instant.now())
            .contractNo(contractNo)
            .build();
        
        clientProductRepository.save(clientProduct);
    }
}

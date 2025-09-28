package com.example.emag;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.example.emag.model.Client;
import com.example.emag.model.Product;
import com.example.emag.repo.ClientRepository;
import com.example.emag.repo.ProductRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureWebMvc
public class EmagApplicationTests {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ObjectMapper objectMapper;

    private MockMvc mockMvc;

    @org.junit.jupiter.api.BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        // Clean up test data
        clientRepository.deleteAll();
        productRepository.deleteAll();
    }

    @Test
    void contextLoads() {
        // This test ensures the Spring context loads successfully
    }

    @Test
    void testCreateClient() throws Exception {
        String clientJson = """
            {
                "cnp": "1234567890123",
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@example.com"
            }
            """;

        mockMvc.perform(post("/api/clients")
                .contentType(MediaType.APPLICATION_JSON)
                .content(clientJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.cnp").value("1234567890123"))
                .andExpect(jsonPath("$.firstName").value("John"))
                .andExpect(jsonPath("$.lastName").value("Doe"))
                .andExpect(jsonPath("$.email").value("john.doe@example.com"));
    }

    @Test
    void testCreateProduct() throws Exception {
        String productJson = """
            {
                "code": "TEST-001",
                "name": "Test Product",
                "price": 100.50
            }
            """;

        mockMvc.perform(post("/api/products")
                .contentType(MediaType.APPLICATION_JSON)
                .content(productJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value("TEST-001"))
                .andExpect(jsonPath("$.name").value("Test Product"))
                .andExpect(jsonPath("$.price").value(100.50))
                .andExpect(jsonPath("$.active").value(true));
    }

    @Test
    void testGetClients() throws Exception {
        // Create a test client
        Client client = Client.builder()
                .cnp("1234567890123")
                .firstName("John")
                .lastName("Doe")
                .email("john.doe@example.com")
                .build();
        clientRepository.save(client);

        mockMvc.perform(get("/api/clients"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].cnp").value("1234567890123"))
                .andExpect(jsonPath("$[0].firstName").value("John"));
    }

    @Test
    void testGetProducts() throws Exception {
        // Create a test product
        Product product = Product.builder()
                .code("TEST-001")
                .name("Test Product")
                .price(new BigDecimal("100.50"))
                .active(true)
                .build();
        productRepository.save(product);

        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].code").value("TEST-001"))
                .andExpect(jsonPath("$[0].name").value("Test Product"));
    }

    @Test
    void testAttachProductToClient() throws Exception {
        // Create test client and product
        Client client = Client.builder()
                .cnp("1234567890123")
                .firstName("John")
                .lastName("Doe")
                .email("john.doe@example.com")
                .build();
        client = clientRepository.save(client);

        Product product = Product.builder()
                .code("TEST-001")
                .name("Test Product")
                .price(new BigDecimal("100.50"))
                .active(true)
                .build();
        product = productRepository.save(product);

        mockMvc.perform(post("/api/clients/{clientId}/products/{productId}", 
                        client.getId(), product.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.productIds").isArray())
                .andExpect(jsonPath("$.productIds[0]").value(product.getId()));
    }

    @Test
    void testSearchProducts() throws Exception {
        // Create test products
        Product product1 = Product.builder()
                .code("TEST-001")
                .name("Test Product 1")
                .price(new BigDecimal("100.50"))
                .active(true)
                .build();
        productRepository.save(product1);

        Product product2 = Product.builder()
                .code("TEST-002")
                .name("Another Product")
                .price(new BigDecimal("200.00"))
                .active(true)
                .build();
        productRepository.save(product2);

        mockMvc.perform(get("/api/products/search")
                .param("q", "test")
                .param("active", "true")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.totalElements").value(1));
    }
}

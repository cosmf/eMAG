package com.example.emag.model;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import com.example.emag.domain.enums.ContractStatus;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document("client_products")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClientProduct {
    @Id
    private String id;

    @Indexed
    @DBRef
    private Client client;

    @Indexed
    @DBRef
    private Product product;

    @Builder.Default
    @Field("status")
    private ContractStatus status = ContractStatus.ACTIVE;

    @Field("iban")
    private String iban;

    @Builder.Default
    @Field("balance")
    private BigDecimal balance = BigDecimal.ZERO;

    @Builder.Default
    @Field("currency")
    private String currency = "RON";

    @Field("creationDate")
    private LocalDate creationDate;

    @Field("expirationDate")
    private LocalDate expirationDate;

    @Field("interestRate")
    private BigDecimal interestRate;

    @Field("lastUpdateDate")
    private Instant lastUpdateDate;

    @Indexed(unique = true)
    @Field("contractNo")
    private String contractNo;
}

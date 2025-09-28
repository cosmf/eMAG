package com.example.emag.model;

import java.math.BigDecimal;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import com.example.emag.domain.enums.ProductStatus;
import com.example.emag.domain.enums.ProductType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document("products")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Product {
  @Id
  private String id;

  @Indexed(unique = true)
  private String code;

  private String name;
  private BigDecimal price;
  private boolean active;

  @Indexed
  @Field("type")
  private ProductType type;

  @Indexed
  @Field("status")
  @Builder.Default
  private ProductStatus status = ProductStatus.ACTIVE;
}

package com.example.emag.model;

import java.util.HashSet;
import java.util.Set;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import com.example.emag.domain.enums.ClientStatus;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document("clients")
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Client {
  @Id
  private String id;

  @Field("cnp")
  @Indexed(unique = true)
  private String cnp;

  private String firstName;
  private String lastName;
  private String email;

  @Builder.Default
  @Field("status")
  private ClientStatus status = ClientStatus.ACTIVE;

  @Builder.Default
  private Set<String> productIds = new HashSet<>();
}

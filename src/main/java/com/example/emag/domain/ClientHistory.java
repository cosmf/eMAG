package com.example.emag.domain;

import java.time.Instant;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import com.example.emag.domain.enums.ExitStatus;
import com.example.emag.model.Client;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document("client_history")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClientHistory {
    @Id
    private String id;

    @DBRef
    @Field("client")
    private Client client;

    @Field("exitStatus")
    private ExitStatus exitStatus;

    @Field("exitReason")
    private String exitReason;

    @Builder.Default
    @Field("creationTimestamp")
    private Instant creationTimestamp = Instant.now();
}

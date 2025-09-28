package com.example.emag.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record CreateProductRequest(
        @NotBlank String code,
        @NotBlank String name,
        @NotNull BigDecimal price
) {}
